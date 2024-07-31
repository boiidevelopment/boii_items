--- Repair a weapon.
--- @param data: Incoming repair kit data.
RegisterNetEvent('boii_items:cl:repair_weapon', function(data)
    local player_ped = PlayerPedId()
    local weapon_hash = GetSelectedPedWeapon(player_ped)
    if not data.item or not data.amount then
        print('Error: Missing item or repair amount data.')
        return
    end
    utils.fw.has_item(data.item, 1, function(has_repair_kit)
        if has_repair_kit then
            if current_weapon and current_weapon.hash == weapon_hash then
                if not utils.tables.table_contains(data.compatible, current_weapon.item_id) then
                    print('This repair kit is not compatible with your equipped weapon.')
                    return
                end
                if current_weapon.data.durability >= 100 then
                    print('Weapon does not need repairs.')
                    return
                end
                current_weapon.data.durability = math.min(100, current_weapon.data.durability + data.amount)
                TriggerServerEvent('boii_items:sv:remove_item', data.item, 1)
                TriggerServerEvent('boii_items:sv:update_item_data', current_weapon.item_id, current_weapon.data)
                print('Weapon repaired to ' .. current_weapon.data.durability .. '% durability.')
            else
                print('No weapon equipped or mismatched weapon hash.')
            end
        else
            print('Missing repair kit.')
        end
    end)
end)

--- Repair a vehicle.
--- @param data: Incoming repair kit data.
RegisterNetEvent('boii_items:cl:repair_vehicle', function(data)
    local player_ped = PlayerPedId()
    local vehicle_data = utils.vehicles.get_vehicle_details(false)
    if not data.item or not data.amount then print('Error: Missing item or repair amount data.') return end
    utils.fw.has_item(data.item, 1, function(has_repair_kit)
        if has_repair_kit then
            if vehicle_data.vehicle and DoesEntityExist(vehicle_data.vehicle) then
                if data.compatible then
                    if not utils.tables.table_contains(data.compatible, vehicle_data.class) then print('This repair kit is not compatible with this vehicle class.') return end
                end
                local engine_health = GetVehicleEngineHealth(vehicle_data.vehicle)
                local body_health = GetVehicleBodyHealth(vehicle_data.vehicle)
                if engine_health >= 1000 and body_health >= 1000 then print('Vehicle does not need repairs.') return end
                SetVehicleEngineHealth(vehicle_data.vehicle, engine_health + data.amount)
                SetVehicleBodyHealth(vehicle_data.vehicle, body_health + data.amount)
                TriggerServerEvent('boii_items:sv:remove_item', data.item, 1)
                print('Vehicle repaired by ' .. data.amount .. ' health points.')
            else
                print('Player is not in a vehicle.')
            end
        else
            print('Missing repair kit.')
        end
    end)
end)