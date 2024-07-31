--- @section Events

--- Event to play animation
--- @param data table: Animation data.
RegisterNetEvent('boii_items:cl:play_animation', function(data)
    if not data then debug_log('warn', 'Event: boii_items_new:cl:play_animation | Note: Animation data missing.') return end
    local player_ped = PlayerPedId()
    utils.player.play_animation(player_ped, data, function()
        if data.on_success then
            if data.on_success.event_type == 'client' then
                TriggerEvent(data.on_success.event, data.on_success.params)
            elseif data.on_success.event_type == 'server' then
                TriggerServerEvent(data.on_success.event, data.on_success.params)
            end
        end
    end)
end)

--- Event to use progressbar.
--- @param data table: Progressbar data.
RegisterNetEvent('boii_items:cl:progressbar', function(data)
    if not data then debug_log('warn', 'Event: boii_items_new:cl:progressbar | Note: Progressbar data is missing.') return end
    utils.ui.progressbar(data)
end)

--- Event to use an item.
--- @param params: Parameters table sent from inventory actions.
RegisterNetEvent('boii_items:cl:use', function(params)
    local item_data = params.item
    TriggerServerEvent('boii_utils:sv:use_item', item_data.id)
end)