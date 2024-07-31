--- Updates item data.
--- @param _src: Players source ID.
--- @param item_id: The item to update.
--- @param updates: Table of updates to apply to item.
local function update_item_data(_src, item_id, updates)
    local item = utils.fw.get_item(_src, item_id)
    if not item then print('Item not found in inventory:', item_id) return end
    for key, value in pairs(updates) do
        item.data[key] = value
    end
    utils.fw.update_inventory_data(_src, item_id, item.data)
end

exports('update_item_data', update_item_data)
items.update_item_data = update_item_data

--- Updates item data.
--- @param item_id: The item to update.
--- @param updates: Table of updates to apply to item.
RegisterServerEvent('boii_items:sv:update_item_data', function(item_id, updates)
    local _src = source
    if not item_id or not updates then print('Item ID or updates not provided.') return end
    update_item_data(_src, item_id, updates)
end)