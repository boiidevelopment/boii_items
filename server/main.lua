--- @section Local functions

--- Initializes usable items on load.
local function initialize_usable_items()
    local registered_items = {}
    local duplicate_items = {}

    for category, items in pairs(item_list) do
        for item_id, item_data in pairs(items) do
            if not item_data.usable then break end
            if registered_items[item_id] then
                if not duplicate_items[item_id] then
                    duplicate_items[item_id] = { categories = { registered_items[item_id] }, count = 1 }
                end
                duplicate_items[item_id].categories[#duplicate_items[item_id].categories + 1] = category
                duplicate_items[item_id].count = duplicate_items[item_id].count + 1
                debug_log('warn', 'Skipping duplicate item: ' .. item_id .. ' in category: ' .. category)
            else
                registered_items[item_id] = category
                if item_data.category == 'weapons' then
                    utils.fw.register_item(item_id, function(source)
                        if source and source ~= 0 then
                            use_weapon(source, item_id)
                        end
                    end)
                else
                    utils.fw.register_item(item_id, function(source)
                        if source and source ~= 0 then
                            use_item(source, item_id)
                        end
                    end)
                end
                debug_log('info', 'Registered item: ' .. item_id .. ' in category: ' .. category)
            end
        end
    end
    if next(duplicate_items) then
        debug_log('warn', 'Duplicate items found and skipped. Please remove one of them:')
        for item_id, data in pairs(duplicate_items) do
            debug_log('warn', 'Item ID: ' .. item_id .. ', Categories: ' .. table.concat(data.categories, ', ') .. ', Count: ' .. data.count)
        end
    end
    debug_log('info', 'Initialization of usable items within categories completed.')
end

CreateThread(function()
    Wait(1000)
    initialize_usable_items()
end)

--- Removes an item on use from client side.
--- @param _src number: The players server ID.
--- @param item string: The item ID to remove
--- @param amount number: The amount to remove.
local function remove_item(_src, item, amount)
    if not _src or not item or not amount then
        print('Source, item or amount not provided.')
        return
    end
    utils.fw.adjust_inventory(_src, {
        items = {
            { item_id = item, action = 'remove', quantity = amount },
        }, 
        note = 'Items: Removed an item.', 
        should_save = true
    })
end

exports('remove_item', remove_item)
items.remove_item = remove_item

--- Updates item data.
--- @param _src: Players source ID.
--- @param item_id: The item to update.
--- @param updates: Table of updates to apply to item.
local function update_item_data(_src, item_id, updates)
    local item = utils.fw.get_item(_src, item_id)
    if not item then
        print('Item not found in inventory:', item_id)
        return
    end
    for key, value in pairs(updates) do
        item.data[key] = value
    end
    utils.fw.update_inventory_data(_src, item_id, item.data)
    print(string.format("Item updated for player %d: %s", _src, item_id))
end

exports('update_item_data', update_item_data)
items.update_item_data = update_item_data

--- @section Events

--- Removes an item on use from client side.
--- @param item string: The item ID to remove
--- @param amount number: The amount to remove.
RegisterServerEvent('boii_items:sv:remove_item', function(item, amount)
    local _src = source
    if not item or not amount then
        print('Item or amount not provided.')
        return
    end
    remove_item(_src, item, amount)
end)

--- Updates item data.
--- @param item_id: The item to update.
--- @param updates: Table of updates to apply to item.
RegisterServerEvent('boii_items:sv:update_item_data', function(item_id, updates)
    local _src = source
    if not item_id or not updates then
        print('Item ID or updates not provided.')
        return
    end
    update_item_data(_src, item_id, updates)
end)
