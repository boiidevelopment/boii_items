--- Event to drop an item.
--- @param _src number: The server ID of the player who is dropping the item.
--- @param drop_data table: Contains details about the dropped item.
RegisterNetEvent('boii_items:cl:drop_item', function(_src, drop_data)
    local player_id = PlayerId()
    local player_ped = PlayerPedId()
    local weapon_hash = GetHashKey(drop_data.item_id)
    local anim_dict = 'random@domestic'
    local anim_name = 'pickup_low'
    if GetPlayerFromServerId(_src) == player_id then
        utils.requests.anim(anim_dict)
        TaskPlayAnim(PlayerPedId(), anim_dict, anim_name, 8.0, -8.0, -1, 50, 0, false, false, false)
        if current_weapon and current_weapon.hash == weapon_hash then
            SetCurrentPedWeapon(player_ped, `WEAPON_UNARMED`, true)
            RemoveAllPedWeapons(player_ped, true)
            current_weapon = nil
        end
        Wait(1000)
        ClearPedTasksImmediately(PlayerPedId())
    end
    local obj = CreateObject(GetHashKey(drop_data.model), drop_data.position.x, drop_data.position.y, drop_data.position.z, true, true, true)
    PlaceObjectOnGroundProperly(obj)
    FreezeEntityPosition(obj, true)
    SetEntityCollision(obj, true, true)
    if not NetworkGetEntityIsNetworked(obj) then
        NetworkRegisterEntityAsNetworked(obj)
    end
    local entity_net_id = NetworkGetNetworkIdFromEntity(obj)
    local entity_id = drop_data.unique_id
    if USE_TARGET then
        if TARGET == 'boii_target' then
            exports.boii_target:add_entity_zone({ obj }, {
                id = entity_id,
                icon = 'fa-solid fa-hand',
                distance = 2.5,
                debug = false,
                sprite = false,
                actions = {
                    {
                        label = 'Pick Up ' .. drop_data.amount .. 'x ' .. drop_data.label,
                        icon = 'fa-solid fa-box-open',
                        action_type = 'server',
                        action = 'boii_items:sv:pick_up_item',
                        params = {
                            unique_id = entity_id,
                            net_id = entity_net_id
                        }
                    },
                }
            })
        elseif TARGET == 'qb-target' then
            exports['qb-target']:AddEntityZone(entity_id, obj, {
                name = entity_id,
                heading = 0.0,
                debugPoly = false,
            }, {
                distance = 2.5,
                options = {
                    {
                        icon = 'fa-solid fa-hand',
                        label = 'Pick Up ' .. drop_data.amount .. 'x ' .. drop_data.label,
                        action = function(entity)
                            TriggerServerEvent('boii_items:sv:pick_up_item', { unique_id = entity_id, net_id = entity_net_id })
                        end
                    }
                }
            })
        elseif TARGET == 'ox_target' then
            exports.ox_target:addLocalEntity(obj, {
                name = entity_id,
                icon = 'fa-solid fa-box-open',
                label = 'Pick Up ' .. drop_data.amount .. 'x ' .. drop_data.label,
                distance = 2.5,
                onSelect = function()
                    TriggerServerEvent('boii_items:sv:pick_up_item', { unique_id = entity_id, net_id = entity_net_id })
                end
            })
        end
    else
        local drawtext_shown = false
        CreateThread(function()
            while DoesEntityExist(obj) do
                local obj_coords = GetEntityCoords(obj)
                local player_coords = GetEntityCoords(PlayerPedId())
                local dist = #(obj_coords - player_coords)
                if dist < 2.5 then
                    if not drawtext_shown then
                        utils.ui.show_drawtext({
                            header = drop_data.label,
                            message = 'Press [E] to pick up '.. drop_data.amount .. 'x ' .. drop_data.label,
                            icon = 'fa-solid fa-box-open'
                        })
                        drawtext_shown = true
                    end

                    if IsControlJustReleased(0, 38) then
                        TriggerServerEvent('boii_items:sv:pick_up_item', { unique_id = entity_id, net_id = entity_net_id })
                        break
                    end
                else
                    if drawtext_shown then
                        utils.ui.hide_drawtext()
                        drawtext_shown = false
                    end
                end
                Wait(0)
            end
            if drawtext_shown then
                utils.ui.hide_drawtext()
            end
        end)
    end
    TriggerServerEvent('boii_items:sv:add_drop_data', entity_id, drop_data)
end)
--- Event to pick up an item.
-- @param _src number: The server ID of the player who is picking up the item.
-- @param net_id number: Network ID of the object being picked up.
-- @param entity_id string: Unique identifier for the item entity.
RegisterNetEvent('boii_items:cl:pick_up_item', function(_src, net_id, entity_id)
    local player_id = PlayerId()
    local obj = NetworkGetEntityFromNetworkId(net_id)
    if DoesEntityExist(obj) then
        if GetPlayerFromServerId(_src) == player_id then
            local anim_dict = 'random@domestic'
            local anim_name = 'pickup_low'
            utils.requests.anim(anim_dict)
            TaskPlayAnim(PlayerPedId(), anim_dict, anim_name, 8.0, -8.0, -1, 50, 0, false, false, false)
            Wait(1000)
            ClearPedTasksImmediately(PlayerPedId())
        end
        NetworkRequestControlOfEntity(obj)
        if NetworkHasControlOfEntity(obj) then
            DeleteEntity(obj)
        else
            print("Failed to delete entity. No network control.")
        end
        if TARGET == 'boii_target' then
            exports.boii_target:remove_target(entity_id)
        elseif TARGET == 'qb-target' then
            exports['qb-target']:RemoveZone(entity_id)
        elseif TARGET == 'ox_target' then
            exports.ox_target:removeEntity(net_id, entity_id)
        end
    else
        print("Entity does not exist.")
    end
end)