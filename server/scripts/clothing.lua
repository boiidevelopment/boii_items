--- Handles equipping clothing.
--- @param _src: Players source ID.
--- @param item: Item being equipped.
local function equip_clothing(_src, item)
    if not item then
        print('Item missing.')
        return
    end
    local item_data = item_list.clothing[item]
    if not item_data then
        print('Item data not provided.')
        return
    end
    if not utils.fw.has_item(_src, item, 1) then
        print('Does not have item.')
        return
    end
    if item_data.modifiers and item_data.modifiers.clothing then
        TriggerClientEvent('boii_items:cl:toggle_clothing', _src, item, item_data.modifiers.clothing)
    end
end

exports('equip_clothing', equip_clothing)
items.equip_clothing = equip_clothing

--- @section Events

--- Handles equipping clothing.
--- @param item: Item being equipped.
RegisterServerEvent('boii_items:sv:equip_clothing', function(data)
    local _src = source
    if not data.item then
        print('Item not provided.')
        return
    end
    equip_clothing(_src, data.item)
end)
