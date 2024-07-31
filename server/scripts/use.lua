--- Uses an item.
-- @param _src player: Players source id.
-- @param item_id string: Name of item.
function use_item(_src, item_id)
    if not _src then 
        debug_log('warn', 'Function: use_item | Note: Source parameter missing') 
        return 
    end
    
    local item = items.get_item(item_id)
    if not item then 
        debug_log('warn', 'Function: use_item | Note: Item not found for item_id: ' .. item_id) 
        return 
    end
    
    local has_item = utils.fw.has_item(_src, item_id, 1)
    if not has_item then 
        debug_log('warn', 'Function: use_item | Note: Item not found in inventory') 
        return 
    end
    
    if item.animation and next(item.animation) ~= nil then 
        TriggerClientEvent('boii_items:cl:play_animation', _src, item.animation) 
        return 
    end

    if item.progressbar and next(item.progressbar) ~= nil then 
        TriggerClientEvent('boii_items:cl:progressbar', _src, item.progressbar) 
        return 
    end

    if item.event and next(item.event) ~= nil then
        local event_type = item.event.event_type
        local event = item.event.event
        local params = item.event.params
        if event_type == 'client' then
            TriggerClientEvent(event, _src, params)
        elseif event_type == 'server' then
            TriggerEvent(event, _src, params)
        end
        return
    end

    -- Merged consume item logic
    debug_log('info', string.format('Consume item event fired by player %d for item ID %s.', _src, item_id))

    if item.remove_on_use then
        utils.fw.adjust_inventory(_src, {
            items = {
                { item_id = item.id, action = 'remove', quantity = 1 },
            }, 
            note = 'Consumables: Used an item.', 
            should_save = true
        })
    end

    if item.modifiers then
        if item.modifiers.statuses then
            utils.fw.adjust_statuses(_src, item.modifiers.statuses)
            debug_log('info', string.format('Statuses modified for player %d using item ID %s.', _src, item_id))
        end

        if item.modifiers.buffs then
            for _, buff in ipairs(item.modifiers.buffs) do
                TriggerClientEvent('boii_items:cl:apply_buff', _src, buff.id, buff.duration)
            end
        end

        if item.modifiers.debuffs then
            for _, debuff in ipairs(item.modifiers.debuffs) do
                TriggerClientEvent('boii_items:cl:apply_debuff', _src, debuff.id, debuff.duration)
            end
        end

        if item.modifiers.effect then
            TriggerClientEvent('boii_items:cl:effects', -1, _src, item.modifiers.effect)
        end

        if item.modifiers.repair then
            item.modifiers.repair.item = item_id
            if item.modifiers.repair.type == 'weapon' then
                TriggerClientEvent('boii_items:cl:repair_weapon', _src, item.modifiers.repair)
            elseif item.modifiers.repair.type == 'vehicle' then
                TriggerClientEvent('boii_items:cl:repair_vehicle', _src, item.modifiers.repair)
            else
                debug_log('err', 'Repair type is not covered.')
            end
        end
    end

    if item.notify and next(item.notify) ~= nil then
        utils.ui.notify(_src, item.notify)
    end
end

exports('use_item', use_item)
items.use_item = use_item

--- Uses a weapon and optionally sets its ammo count.
-- @param _src player: Players source id.
-- @param item_id string: Name of item.
-- @param ammo_count integer: Optional initial ammo count for the weapon.
local function use_weapon(_src, item_id)
    local weapon = utils.fw.get_item(_src, item_id)
    if not weapon then debug_log('err', 'Weapon not found or not in inventory for item_id:', item_id) return end
    weapon.data = weapon.data or {
        ammo = 0,
        attachments = {},
        durability = 100
    }
    TriggerClientEvent('boii_items:cl:equip_weapon', _src, item_id, weapon.data)
end

exports('use_weapon', use_weapon)
items.use_weapon = use_weapon

--- @section Events

--- Handles using items.
-- @param item_id string: The ID of the item being used.
RegisterServerEvent('boii_items:sv:use_item', function(item_id)
    local _src = source
    use_item(_src, item_id)
end)

--- Handles using items.
-- @param item_id string: The ID of the item being used.
RegisterServerEvent('boii_items:sv:use_weapon', function(item_id)
    local _src = source
    use_weapon(_src, item_id)
end)

--- @section Testing

RegisterCommand('items:test_use', function(source, args, raw)
    local item_id = args[1]
    use_item(source, item_id)
end)
