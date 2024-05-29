--[[
     ____   ____ _____ _____   _   _____  ________      ________ _      ____  _____  __  __ ______ _   _ _______ 
    |  _ \ / __ \_   _|_   _| | | |  __ \|  ____\ \    / /  ____| |    / __ \|  __ \|  \/  |  ____| \ | |__   __|
    | |_) | |  | || |   | |   | | | |  | | |__   \ \  / /| |__  | |   | |  | | |__) | \  / | |__  |  \| |  | |   
    |  _ <| |  | || |   | |   | | | |  | |  __|   \ \/ / |  __| | |   | |  | |  ___/| |\/| |  __| | . ` |  | |   
    | |_) | |__| || |_ _| |_  | | | |__| | |____   \  /  | |____| |___| |__| | |    | |  | | |____| |\  |  | |   
    |____/ \____/_____|_____| | | |_____/|______|   \/   |______|______\____/|_|    |_|  |_|______|_| \_|  |_|   
                              | |                                                                                
                              |_|                 ITEMS
]]

--- @section Dependencies
--- Import utility library from a shared resource.
utils = exports.boii_utils:get_utils()

--- @section State bags

--- @field dropped_items: Stores dropped items.
local dropped_items = {}

--- @section Tables

--- @field player_buffs: Stores active buffs & debuffs for player.
local player_buffs = {}

--- @section Global functions

--- Handles debug logging.
-- @function debug_log
-- @param type string: The type of debug message.
-- @param message string: The debug message.
function debug_log(type, message)
    if config.debug and utils.debug[type] then
        utils.debug[type](message)
    end
end

--- @section Local functions

--- Finds a specific item in the item_list by its ID.
-- @param target_id string: The unique identifier of the item to find.
-- @return table|nil: The item's data if found within any category. Nil if the item is not found.
local function find_item(target_id)
    for category_name, category_items in pairs(item_list) do
        if category_items[target_id] then
            return category_items[target_id]
        end
    end
    return nil
end
exports('find_item', find_item)

--- Uses an item.
-- @param _src player: Players source id.
-- @param item_id string: Name of item.
local function use_item(_src, item_id)
    if not _src then
        print('_src not provided')
        return
    end
    local item = find_item(item_id)
    if not item then
        print('item not found for item_id:', item_id)
        return
    end
    local has_item = utils.fw.has_item(_src, item_id, 1)
    if not has_item then
        print('Item not found as item in inventory')
        return
    end
    if not item.on_use then
        print('on_use data not found for item:', item_id)
        return
    end
    if item.on_use.progressbar then
        TriggerClientEvent('boii_items:cl:progressbar', _src, item.on_use.progressbar)
        return
    end
    if item.on_use.event then
        if item.on_use.event.event_type == 'client' then
            TriggerClientEvent(item.on_use.event.event, _src, item.on_use.event.params)
        elseif item.on_use.event.event_type == 'server' then
            TriggerEvent(item.on_use.event.event, _src, item.on_use.event.params)
        end
    end
    if item.on_use.statuses and next(item.on_use.statuses) ~= nil then
        utils.fw.adjust_statuses(_src, item.on_use.statuses)
    end
    if item.on_use.buffs or item.on_use.debuffs or item.on_use.effects then
        local player = exports.boii_statuses:get_player(_src)
        if item.on_use.buffs then
            for _, buff_id in ipairs(item.on_use.buffs) do
                player.apply_effect('buffs', buff_id)
            end
        end
        if item.on_use.debuffs then
            for _, debuff_id in ipairs(item.on_use.debuffs) do
                player.apply_effect('debuffs', debuff_id)
            end
        end
        if item.on_use.effects then
            for _, effect_id in ipairs(item.on_use.effects) do
                player.apply_effect('effects', effect_id)
            end
        end
    end
    if item.on_use.notify then
        utils.ui.notify(_src, item.on_use.notify)
    end
end
exports('use_item', use_item)

--- Uses a weapon and optionally sets its ammo count.
-- @param _src player: Players source id.
-- @param item_id string: Name of item.
-- @param ammo_count integer: Optional initial ammo count for the weapon.
local function use_weapon(_src, item_id)
    local weapon = utils.fw.get_item(_src, item_id)
    if not weapon then
        print('Weapon not found or not in inventory for item_id:', item_id)
        return
    end
    weapon.data = weapon.data or {
        ammo = 0,
        attachments = {},
        durability = 100
    }
    TriggerClientEvent('boii_items:cl:equip_weapon', _src, item_id, weapon.data)
    print(string.format("Weapon equipped by player %d: %s with ammo %d", _src, item_id, weapon.data.ammo))
end
exports('use_weapon', use_weapon)

--- Initializes usable items on load
local function initialize_usable_items()
    local registered_items = {}
    local duplicate_items = {}
    for category, items in pairs(item_list) do
        for item_id, item_data in pairs(items) do
            if registered_items[item_id] then
                if not duplicate_items[item_id] then
                    duplicate_items[item_id] = {categories = {registered_items[item_id]}, count = 1}
                end
                duplicate_items[item_id].categories[#duplicate_items[item_id].categories + 1] = category
                duplicate_items[item_id].count = duplicate_items[item_id].count + 1
                break
            else
                registered_items[item_id] = category
                if item_data.category == 'weapons' then
                    utils.items.register(item_id, function(_src)
                        if _src and _src ~= 0 then
                            use_weapon(_src, item_id)
                        end
                    end)
                end
                if item_data.on_use then
                    utils.items.register(item_id, function(_src)
                        if _src and _src ~= 0 then
                            use_item(_src, item_id)
                        end
                    end)
                end
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
initialize_usable_items()

--- Drops an item from the player's inventory and creates a item in the world.
-- @param _src number: The source player identifier.
-- @param item_id string: The ID of the item being dropped.
-- @param amount number: The quantity of the item to drop.
local function drop_item(_src, item_id, amount)
    local item_data = find_item(item_id)
    if not item_data then
        print('Item not found for item_id:', item_id)
        return
    end
    if utils.fw.has_item(_src, item_id, amount) then
        local item_details = utils.fw.get_item(_src, item_id)
        local item_meta = item_details.data or item_details.metadata or item_details.info or {}
        utils.fw.adjust_inventory(_src, {
            items = {{ item_id = item_id, action = 'remove', quantity = amount, data = item_meta }},
            note = 'Dropping an item.',
            should_save = true
        })
        local drop_position = GetEntityCoords(GetPlayerPed(_src))
        local drop_data = {
            model = item_data.model or 'prop_paper_bag_small',
            position = drop_position,
            item_id = item_id,
            label = item_data.label,
            amount = amount,
            category = item_data.category,
            data = item_meta
        }
        TriggerClientEvent('boii_items:cl:drop_item', -1, _src, drop_data)
        if item_data.on_drop then
            utils.ui.notify(_src, {
                type = 'success',
                header = 'INVENTORY',
                message = 'You dropped ' .. amount .. 'x '.. item_data.label.. ' on the ground.',
                duration = 3000
            })
        end
    else
        if item_data.on_drop then
            utils.ui.notify(_src, {
                type = 'error',
                header = 'INVENTORY',
                message = 'Couldnt find the item to drop it.',
                duration = 3000
            })
        end
    end
end
exports('drop_item', drop_item)

--- Executes the pick up process, including inventory adjustment and object removal.
-- @param _src: Source player.
-- @param net_id: Network ID of the object
-- @param unique_id: Unique ID for the drop.
local function pick_up_item(_src, net_id, unique_id)
    db.get_drop(unique_id, function(drop_data)
        if drop_data then
            utils.fw.adjust_inventory(_src, {
                items = {{ item_id = drop_data.item_id, action = 'add', quantity = drop_data.amount, data = drop_data.data }},
                validation_data = {
                    location = drop_data.position,
                    distance = 5.0,
                    drop_player = false
                },
                note = 'Picking up an item.',
                should_save = true
            })
            utils.ui.notify(_src, {
                type = 'success',
                header = 'ITEM PICK UP',
                message = 'You picked up ' .. drop_data.amount .. 'x ' .. drop_data.label,
                duration = 3000
            })
            db.remove_drop(unique_id)
            TriggerClientEvent('boii_items:cl:pick_up_item', -1, _src, net_id, unique_id)
        else
            utils.ui.notify(_src, {
                type = 'error',
                header = 'ITEM PICK UP',
                message = 'The drop could not be found.',
                duration = 3000
            })
        end
    end)
end
exports('pick_up_item', pick_up_item)

--- Consumes a item.
-- @param _src: Players source ID.
-- @param item_id string: The ID of the item being consumed.
local function consume_item(_src, data)
    debug_log('info', string.format('Consume item event fired by player %d for item ID %s.', _src, data.item))
    if not data.item then 
        debug_log('info', 'Item missing.') 
        return 
    end

    local item_data, category_name = find_item(data.item)
    if item_data and item_data.on_use then
        if data.statuses and next(data.statuses) ~= nil then
            utils.fw.adjust_statuses(_src, data.statuses)
            debug_log('info', string.format('Statuses modified for player %d using item ID %s.', _src, data.item))
        end
        if (data.buffs and next(data.buffs) ~= nil) or (data.debuffs and next(data.debuffs) ~= nil) or (data.effects and next(data.effects) ~= nil) then
           
            local player = exports.boii_statuses:get_player(_src)
            if data.buffs and next(data.buffs) ~= nil then
                for _, buff_id in ipairs(data.buffs) do
                    player.apply_effect('buffs', buff_id)
                end
            end
            if data.debuffs and next(data.debuffs) ~= nil then
                for _, debuff_id in ipairs(data.debuffs) do
                    player.apply_effect('debuffs', debuff_id)
                end
            end
            if data.effects and next(data.effects) ~= nil then
                for _, effect_id in ipairs(data.effects) do
                    player.apply_effect('effects', effect_id)
                end
            end
        end
        utils.fw.adjust_inventory(_src, {
            items = {
                { item_id = item_data.id, action = 'remove', quantity = 1 },
            }, 
            note = 'Consumables: Used an item.', 
            should_save = true
        })
    else
        debug_log('err', string.format('Error: Item ID {%s} not found or not usable.', data.item))
    end
end
exports('consume_item', consume_item)

--- Adds drop data.
-- @param _src: Players source ID.
-- @param id: Unique ID for the drop.
-- @param drop_data: Table of data for the drop.
local function add_drop_data(_src, id, drop_data)
    local player_id = utils.fw.get_player_id(_src)
    if id and drop_data then
        dropped_items[id] = drop_data
        db.add_drop(id, player_id, drop_data)
    else
        print("Invalid drop data or ID provided.")
    end
end
exports('add_drop_data', add_drop_data)

--- Updates item data.
-- @param _src: Players source ID.
-- @param item_id: The item to update.
-- @param updates: Table of updates to apply to item.
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

--- Handles equipping clothing.
-- @param _src: Players source ID.
-- @param item: Item being equipped.
local function equip_clothing(_src, item)
    if not item then
        print('Item data not provided.')
        return
    end
    if utils.fw.has_item(_src, item.id, 1) then
        TriggerClientEvent('boii_items:cl:toggle_clothing', _src, item.id, item.component, item.drawable, item.texture)
    else
        utils.ui.notify(_src, {
            type = 'error',
            header = 'CLOTHING EQUIP',
            message = 'You dont have a ' .. item.id .. ' in your inventory.',
            duration = 3000
        })
    end
end
exports('equip_clothing', equip_clothing)

--- Removes an item on use from client side.
-- @param _src number: The player's server ID.
-- @param item string: The item ID to remove
-- @param amount number: The amount to remove.
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

--- @section Events

--- Handles using items.
-- @param item_id string: The ID of the item being used.
RegisterServerEvent('boii_items:sv:use_item', function(item_id)
    local _src = source
    use_item(_src, item_id)
end)

--- Handles consuming food or drink items.
-- @param _src The source player identifier.
-- @param params: Parameters received.
RegisterServerEvent('boii_items:sv:consume_item', function(params)
    local _src = source
    local on_use_data = {
        item = params.item,
        statuses = params.statuses or {},
        buffs = params.buffs or {},
        debuffs = params.debuffs or {},
        effects = params.effects or {}
    }
    consume_item(_src, on_use_data)
end)

--- Triggers an item drop.
-- @param params: Parameters received.
RegisterServerEvent('boii_items:sv:drop', function(params)
    local _src = source
    local item_id = params.item
    local amount = params.amount or 1
    drop_item(_src, item_id, amount)
end)

--- Picks up an item.
-- @param params: Parameters received.
RegisterServerEvent('boii_items:sv:pick_up_item', function(params)
    local _src = source
    local net_id = params.net_id
    local unique_id = params.unique_id
    pick_up_item(_src, net_id, unique_id)
end)

--- Adds drop data.
-- @param id: Unique ID for the drop.
-- @param drop_data: Table of data for the drop.
RegisterServerEvent('boii_items:sv:add_drop_data', function(id, drop_data)
    local _src = source
    local player_id = utils.fw.get_player_id(_src)
    if id and drop_data then
        add_drop_data(_src, id, drop_data)
    else
        print("Invalid drop data or ID provided.")
    end
end)

--- Updates item data.
-- @param item_id: The item to update.
-- @param updates: Table of updates to apply to item.
RegisterServerEvent('boii_items:sv:update_item_data', function(item_id, updates)
    local _src = source
    if not item_id or not updates then
        print('Item ID or updates not provided.')
        return
    end
    update_item_data(_src, item_id, updates)
end)

--- Handles equipping clothing.
-- @param item: Item being equipped.
RegisterServerEvent('boii_items:sv:equip_clothing', function(item)
    local _src = source
    if not item then
        print('Item not provided.')
        return
    end
    equip_clothing(_src, item)
end)

--- Removes an item on use from client side.
-- @param item string: The item ID to remove
-- @param amount number: The amount to remove.
RegisterServerEvent('boii_items:sv:remove_item', function(item, amount)
    local _src = source
    if not item or not amount then
        print('Item or amount not provided.')
        return
    end
    remove_item(_src, item, amount)
end)

--- @section Callbacks

--- Callback filtered config to client.
-- @param _src number: The player's server ID.
-- @param data table: Request data (unused but included for callback pattern consistency).
-- @param cb function: Callback function to return the configuration data.
utils.callback.register('boii_items:sv:request_config', function(_src, data, cb)
    local client_config = {}
    client_config.debug = config.debug
    local client_items = item_list
    cb(client_config, client_items)
end)

--- @section Threads
