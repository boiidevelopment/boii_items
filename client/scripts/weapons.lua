--- Event to equip or remove a weapon.
--- @param item_id: Received item id.
--- @param weapon_data: Table of weapon data held by inventory.
RegisterNetEvent('boii_items:cl:equip_weapon', function(item_id, weapon_data)
    local player_ped = PlayerPedId()
    local weapon_hash = GetHashKey(item_id)
    if current_weapon and current_weapon.hash == weapon_hash then
        SetCurrentPedWeapon(player_ped, `WEAPON_UNARMED`, true)
        RemoveAllPedWeapons(player_ped, true)
        current_weapon = nil
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
--- @param data table: Contains the ammo type and count to be reloaded.
RegisterNetEvent('boii_items:cl:reload_weapon', function(data)
    local player_ped = PlayerPedId()
    local weapon_hash = GetSelectedPedWeapon(player_ped)
    local ammo_count = tonumber(item_list[data.item].modifiers.ammo.amount)
    if current_weapon and current_weapon.hash == weapon_hash then
        utils.fw.has_item(data.item, 1, function(has_ammo_item)
            if has_ammo_item then
                local is_compatible = false
                for _, ammo_type in ipairs(current_weapon.data.ammo_types) do
                    if ammo_type == data.item then
                        is_compatible = true
                        break
                    end
                end
                if not is_compatible then
                    print('Ammo type is not compatible with the equipped weapon.')
                    return
                end
                local current_ammo = GetAmmoInPedWeapon(player_ped, weapon_hash)
                local ammo_to_add = current_ammo + ammo_count
                if ammo_to_add > 0 then
                    SetPedAmmo(player_ped, weapon_hash, ammo_to_add)
                    current_weapon.data.ammo = ammo_to_add
                    TriggerServerEvent('boii_items:sv:remove_item', data.item, 1)
                    TriggerServerEvent('boii_items:sv:update_item_data', current_weapon.item_id, current_weapon.data)
                end
            else
                print('Ammo item not found in inventory.')
            end
        end)
    else
        print('Current weapon is not the expected weapon for reloading or not equipped.')
    end
end)

--- Modify a weapon.
-- @param data table: Incoming attachment data
RegisterNetEvent('boii_items:cl:modify_weapon', function(data)
    local player_ped = PlayerPedId()
    local weapon_hash = GetSelectedPedWeapon(player_ped)
    local compatibility = item_list[data.item].attachments.compatibility
    utils.fw.has_item(data.item, 1, function()
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
