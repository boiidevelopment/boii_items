--- Consumes an item.
--- @param _src: Players source ID.
--- @param item_id string: The ID of the item being consumed.
local function consume_item(_src, item_id)
    debug_log('info', string.format('Consume item event fired by player %d for item ID %s.', _src, item_id))
    if not item_id then debug_log('err', 'Item missing.') return end

    local item_data, category_name = items.get_item(item_id)
    if item_data then
        debug_log('info', string.format('Found item data for %s in category %s.', item_id, category_name))

        if item_data.modifiers and item_data.modifiers.repair then
            item_data.modifiers.repair.item = item_id
            if item_data.modifiers.repair.type == 'weapon' then
                TriggerClientEvent('boii_items:cl:repair_weapon', _src, item_data.modifiers.repair)
                return
            elseif item_data.modifiers.repair.type == 'vehicle' then
                TriggerClientEvent('boii_items:cl:repair_vehicle', _src, item_data.modifiers.repair)
                return
            else
                debug_log('err', 'Repair type is not covered.')
            end
        end

        if item_data.remove_on_use then
            utils.fw.adjust_inventory(_src, {
                items = {
                    { item_id = item_data.id, action = 'remove', quantity = 1 },
                }, 
                note = 'Consumables: Used an item.', 
                should_save = true
            })
        end

        if item_data.modifiers and item_data.modifiers.statuses then
            utils.fw.adjust_statuses(_src, item_data.modifiers.statuses)
            debug_log('info', string.format('Statuses modified for player %d using item ID %s.', _src, item_id))
        end

        if item_data.modifiers and item_data.modifiers.buffs then
            for _, buff in ipairs(item_data.modifiers.buffs) do
                TriggerClientEvent('boii_items:cl:apply_buff', _src, buff.id, buff.duration)
            end
        end

        if item_data.modifiers and item_data.modifiers.debuffs then
            for _, debuff in ipairs(item_data.modifiers.debuffs) do
                TriggerClientEvent('boii_items:cl:apply_debuff', _src, debuff.id, debuff.duration)
            end
        end

        if item_data.modifiers and item_data.modifiers.effect then
            TriggerClientEvent('boii_items:cl:effects', -1, _src, item_data.modifiers.effect)
        end
    else
        debug_log('err', string.format('Error: Item ID {%s} not found or not usable.', item_id))
    end
end

exports('consume_item', consume_item)
items.consume_item = consume_item

--- Handles consuming food or drink items.
--- @param _src The source player identifier.
--- @param data: Parameters received.
RegisterServerEvent('boii_items:sv:consume_item', function(data)
    local _src = source
    if not data or not data.item then debug_log('err', 'Item missing.') return end
    consume_item(_src, data.item)
end)
