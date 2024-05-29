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

--- @section Constants

TARGET = config.target

--- @section Variables

--- @field is_focused: Tracks ui focus state.
local is_focused = false

--- @field current_weapon: Variable to store the players current equiped weapon.
local current_weapon = {}

--- @field equipped_clothing: Stores current equipped clothing to allow for toggle back.
local equipped_clothing = {}

--- @section Global functions.

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

--- Internal Helper function to handle triggering events and notifications
local function handle_event(outcome)
    if outcome.event then
        if outcome.event.event_type == 'server' then
            TriggerServerEvent(outcome.event.event, outcome.event.params)
        elseif outcome.event.event_type == 'client' then
            TriggerEvent(outcome.event.event, outcome.event.params)
        end
    end
    if outcome.notify then
        utils.ui.notify({
            header = outcome.notify.header,
            message = outcome.notify.message,
            type = outcome.notify.type,
            duration = outcome.notify.duration
        })
    end
    progress_active = false
end

--- Finds a specific item in the item_list by its ID.
-- @param target_id string: The unique identifier of the item to find.
-- @return table|nil: The item's data if found within any category. Nil if the item is not found.
-- @return string|nil: The name of the category where the item was found. Nil if the item is not found.
-- @usage
--[[
    local item_data = items.find('water')
    if item_data then
        print('Found item: ' .. json.encode(item_data))
        -- Process item_data
    else
        print('Item not found')
    end
]]
local function find_item(target_id)
    for _, category_items in pairs(item_list) do
        if category_items[target_id] then
            local item = category_items[target_id]
            return item
        end
    end
    return nil
end
exports('find_item', find_item)

--- @section Events

--- Event to use an item.
-- @param event_data table: Event data received from server.
RegisterNetEvent('boii_items:cl:progressbar', function(data)
    if not data then
        utils.ui.notify({
            type = 'error',
            header = 'Item Use Error',
            message = 'Failed to process item usage due to incorrect data.',
            duration = 5000
        })
        print("Invalid event data received for using item.")
        return
    end
    utils.ui.progressbar(data, function(success)
        if success then
            print("Item use completed successfully.")
        else
            print("Item use was cancelled or failed to complete.")
        end
    end)
end)

--- Event triggered on item use
-- @param params: Parameters table sent from inventory actions.
RegisterNetEvent('boii_items:cl:use', function(params)
    local item_data = params.item
    TriggerServerEvent('boii_utils:sv:use_item', item_data.id)
end)

--- Event to drop an item.
-- @param _src number: The server ID of the player who is dropping the item.
-- @param drop_data table: Contains details about the dropped item.
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
    else
        print("Player ID does not match source. Skipping animation.")
    end
    local obj = CreateObject(GetHashKey(drop_data.model), drop_data.position.x, drop_data.position.y, drop_data.position.z, true, true, true)
    PlaceObjectOnGroundProperly(obj)
    FreezeEntityPosition(obj, true)
    SetEntityCollision(obj, true, true)
    if not NetworkGetEntityIsNetworked(obj) then
        NetworkRegisterEntityAsNetworked(obj)
    end
    local entity_net_id = NetworkGetNetworkIdFromEntity(obj)
    local entity_id = 'dropped_item_' .. tostring(entity_net_id)
    if TARGET == 'boii_target' then
        exports.boii_target:add_entity_zone({ obj }, {
            id = entity_id,
            icon = 'fa-solid fa-hand',
            distance = 2.5,
            debug = true,
            sprite = false,
            actions = {
                {
                    label = 'Pick Up ' .. drop_data.amount .. 'x '.. drop_data.label,
                    icon = 'fa-solid fa-box-open',
                    action_type = 'function',
                    action = function() 
                        TriggerServerEvent('boii_items:sv:pick_up_item', { unique_id = entity_id, net_id = entity_net_id })
                    end
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
                    label = 'Pick Up ' .. drop_data.amount .. 'x '.. drop_data.label,
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
            label = 'Pick Up ' .. drop_data.amount .. 'x '.. drop_data.label,
            distance = 2.5,
            onSelect = function()
                TriggerServerEvent('boii_items:sv:pick_up_item', { unique_id = entity_id, net_id = entity_net_id })
            end
        })
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
    if TARGET == 'boii_target' then
        exports.boii_target:remove_target(entity_id)
    elseif TARGET == 'qb-target' then
        exports['qb-target']:RemoveZone(entity_id)
    elseif TARGET == 'ox_target' then
        exports.ox_target:removeEntity(net_id, entity_id)
    end
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
    else
        print("Entity does not exist.")
    end
end)

--- Event to equip or remove a weapon.
-- @param item_id: Received item id.
-- @param weapon_data: Table of weapon data held by inventory.
RegisterNetEvent('boii_items:cl:equip_weapon', function(item_id, weapon_data)
    local player_ped = PlayerPedId()
    local weapon_hash = GetHashKey(item_id)
    if current_weapon and current_weapon.hash == weapon_hash then
        SetCurrentPedWeapon(player_ped, `WEAPON_UNARMED`, true)
        RemoveAllPedWeapons(player_ped, true)
        current_weapon = nil
        print("Weapon unequipped: " .. item_id)
        return
    end
    GiveWeaponToPed(player_ped, weapon_hash, weapon_data.ammo, false, true)
    SetPedAmmo(player_ped, weapon_hash, weapon_data.ammo)
    current_weapon = { hash = weapon_hash, item_id = item_id, data = weapon_data }
    if weapon_data.attachments then
        for attachment_id, is_equipped in pairs(weapon_data.attachments) do
            if is_equipped then
                local attachment_item = find_item(attachment_id)
                if attachment_item then
                    for _, compat in ipairs(attachment_item.compatibility) do
                        if compat.weapon == item_id then
                            local component_hash = GetHashKey(compat.component)
                            GiveWeaponComponentToPed(player_ped, weapon_hash, component_hash)
                            print("Attachment equipped: " .. attachment_id .. " with component: " .. compat.component)
                            break
                        end
                    end
                else
                    print("Attachment item data not found for: " .. attachment_id)
                end
            end
        end
    end
end)

--- Event triggered to reload a weapon.
-- This event is called when a player attempts to reload their weapon with specific ammo.
-- @param params table: Contains the ammo type and count to be reloaded.
RegisterNetEvent('boii_items:cl:reload_weapon', function(params)
    local player_ped = PlayerPedId()
    local weapon_hash = GetSelectedPedWeapon(player_ped)
    local ammo_type = params.item
    local ammo_count = tonumber(params.ammo_count)
    if current_weapon and current_weapon.hash == weapon_hash then
        local max_ammo = GetMaxAmmo(player_ped, weapon_hash)
        local current_ammo = GetAmmoInPedWeapon(player_ped, weapon_hash)
        local ammo_to_add = current_ammo + ammo_count
        if ammo_to_add > 0 then
            SetPedAmmo(player_ped, weapon_hash, ammo_to_add)
            current_weapon.data.ammo = ammo_to_add
            TriggerServerEvent('boii_items:sv:remove_item', ammo_type, 1)
            TriggerServerEvent('boii_items:sv:update_item_data', current_weapon.item_id, current_weapon.data)
        else
            print('No ammo added. Max capacity reached or invalid ammo count.')
        end
    else
        print('Current weapon is not the expected weapon for reloading or not equipped.')
    end
end)

--- Modify a weapon.
-- @param data table: Incoming attachment data
RegisterNetEvent('boii_items:cl:modify_weapon', function(data)
    local attachment = data.item
    local compatibility = data.compatibility
    local player_ped = PlayerPedId()
    local weapon_hash = GetSelectedPedWeapon(player_ped)
    utils.fw.has_item(attachment, 1, function()
        if current_weapon and current_weapon.hash == weapon_hash then
            local item_data = find_item(attachment)
            if not item_data then
                print('Attachment data not found.')
                return
            end
            local compatible = false
            local component_hash
            for _, compat in ipairs(compatibility) do
                if compat.weapon == current_weapon.item_id then
                    compatible = true
                    component_hash = GetHashKey(compat.component)
                    break
                end
            end
            if not compatible or not component_hash then
                print('The attachment is not compatible with the equipped weapon.')
                return
            end
            GiveWeaponComponentToPed(player_ped, weapon_hash, component_hash)
            if not current_weapon.data.attachments then
                current_weapon.data.attachments = {}
            end
            current_weapon.data.attachments[attachment] = true
            TriggerServerEvent('boii_items:sv:remove_item', attachment, 1)
            TriggerServerEvent('boii_items:sv:update_item_data', current_weapon.item_id, current_weapon.data)
        else
            print('No weapon equipped or mismatched weapon hash.')
        end
    end)
end)

--- Repair a weapon.
-- @param data: Incoming repair kit data.
RegisterNetEvent('boii_items:cl:repair_weapon', function(data)
    local player_ped = PlayerPedId()
    local weapon_hash = GetSelectedPedWeapon(player_ped)
    if not data.item or not data.repair_amount then
        print('Error: Missing item or repair amount data.')
        return
    end
    local repair_kit = data.item
    local repair_amount = data.repair_amount
    local compatible_weapons = data.compatible
    utils.fw.has_item(repair_kit, 1, function(has_repair_kit)
        if has_repair_kit then
            if current_weapon and current_weapon.hash == weapon_hash then
                if not utils.tables.table_contains(compatible_weapons, current_weapon.item_id) then
                    print('This repair kit is not compatible with your equipped weapon.')
                    return
                end
                if current_weapon.data.durability >= 100 then
                    print('Weapon does not need repairs.')
                    return
                end
                current_weapon.data.durability = math.min(100, current_weapon.data.durability + repair_amount)
                TriggerServerEvent('boii_items:sv:remove_item', repair_kit, 1)
                TriggerServerEvent('boii_items:sv:update_item_data', current_weapon.item_id, current_weapon.data)
                print('Weapon repaired to ' .. current_weapon.data.durability .. '% durability.')
            else
                print('No weapon equipped or mismatched weapon hash.')
            end
        else
            print('missing repair kit')
        end
    end)
end)

--- Toggle clothing items.
-- @param data table: Incoming clothing data params.
RegisterNetEvent('boii_items:cl:equip_clothing', function(data)
    local player_ped = PlayerPedId()
    local model_hash = GetEntityModel(player_ped)
    local clothing_data = data.clothing
    local gender = IsPedModel(player_ped, `mp_m_freemode_01`) and 'm' or 'f'
    local outfit = clothing_data[gender]
    if equipped_clothing[data.item] then
        SetPedComponentVariation(player_ped, outfit.component, equipped_clothing[data.item].drawable, equipped_clothing[data.item].texture, 0)
        equipped_clothing[data.item] = nil
    else
        equipped_clothing[data.item] = {
            drawable = GetPedDrawableVariation(player_ped, outfit.component),
            texture = GetPedTextureVariation(player_ped, outfit.component)
        }
        SetPedComponentVariation(player_ped, outfit.component, outfit.drawable, outfit.texture, 0)
    end
end)

--- @section Threads

--- Thread to handle player actions while aiming or shooting.
CreateThread(function()
    while true do
        local player_ped = PlayerPedId()
        local weapon_hash = GetSelectedPedWeapon(player_ped)
        if IsPlayerFreeAiming(PlayerId()) and current_weapon and current_weapon.hash == weapon_hash then
            local current_ammo = GetAmmoInPedWeapon(player_ped, weapon_hash)
            if current_ammo <= 0 or current_weapon.data.durability <= 0 then
                if current_ammo <= 0 then
                    TriggerEvent('chat:addMessage', {
                        color = {255, 0, 0},
                        multiline = true,
                        args = {"System", "You are out of ammo!"}
                    })
                elseif current_weapon.data.durability <= 0 then
                    DisablePlayerFiring(player_ped, true)
                    TriggerEvent('chat:addMessage', {
                        color = {255, 0, 0},
                        multiline = true,
                        args = {"System", "Your weapon is too damaged to use!"}
                    })
                end
            end
            if IsPedShooting(player_ped) then
                SetPedAmmo(player_ped, weapon_hash, current_ammo)
                current_weapon.data.ammo = current_ammo
                current_weapon.data.durability = utils.maths.round(current_weapon.data.durability - 0.1, 2)
                TriggerServerEvent('boii_items:sv:update_item_data', current_weapon.item_id, current_weapon.data)
            end
        end
        Wait(0)
    end
end)
