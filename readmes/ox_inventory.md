# Ox Inventory Setup

### Use Items

Doing the following will allow for the use of the `boii_items` on_use setup, if any items are found within boii_items first, they will be used through the system instead of ox_inventory default.

In `ox_inventory/client.lua` find the function `useItem` and replace with the function below:

```lua
local function useItem(data, cb, noAnim)
	local slotData, result = PlayerData.inventory[data.slot]
	local boii_item = exports.boii_items:find_item(data.name)
	if boii_item and boii_item.on_use then
        TriggerEvent('boii_items:cl:use', { item = { id = data.name } })
		return
	end
	if not slotData or not canUseItem(data.ammo and true) then
        if currentWeapon then
            return lib.notify({ id = 'cannot_perform', type = 'error', description = locale('cannot_perform') })
        end
        return
    end
	if currentWeapon?.timer and currentWeapon.timer > 100 then return end
    if invOpen and data.close then client.closeInventory() end
    usingItem = true
    ---@type boolean?
    result = lib.callback.await('ox_inventory:useItem', 200, data.name, data.slot, slotData.metadata, noAnim)
	if result and cb then
		local success, response = pcall(cb, result and slotData)
		if not success and response then
			warn(('^1An error occurred while calling item "%s" callback!\n^1SCRIPT ERROR: %s^0'):format(slotData.name, response))
		end
	end
    if result then
        TriggerEvent('ox_inventory:usedItem', slotData.name, slotData.slot, next(slotData.metadata) and slotData.metadata)
    end
	Wait(500)
    usingItem = false
end
```

### Drop Items

Doing the following will allow for the use of the `boii_items` on_drop setup, if any items are found within boii_items first, they will be dropped through the system instead of ox_inventory default.

In `ox_inventory/client.lua` find the NUI callback `swapItems` and replace with the one below; 

```lua
RegisterNUICallback('swapItems', function(data, cb)
    if swapActive or not invOpen or invBusy or usingItem then return cb(false) end

	local p_items = exports.ox_inventory:GetPlayerItems()
	for i, d in pairs(p_items) do
		if d.slot == data.fromSlot then
			local boii_item = exports.boii_items:find_item(d.name)
			if boii_item and boii_item.on_drop then
				TriggerServerEvent('boii_items:sv:drop', { item = d.name, amount = d.count })
				return
			end
		end
	end

    swapActive = true

	if data.toType == 'newdrop' then
		if cache.vehicle or IsPedFalling(playerPed) then
			swapActive = false
			return cb(false)
		end

		local coords = GetEntityCoords(playerPed)

		if IsEntityInWater(playerPed) then
			local destination = vec3(coords.x, coords.y, -200)
			local handle = StartShapeTestLosProbe(coords.x, coords.y, coords.z, destination.x, destination.y, destination.z, 511, cache.ped, 4)

			while true do
				Wait(0)
				local retval, hit, endCoords = GetShapeTestResult(handle)

				if retval ~= 1 then
					if not hit then return end

					data.coords = vec3(endCoords.x, endCoords.y, endCoords.z + 1.0)

					break
				end
			end
		else
			data.coords = coords
		end
    end

	if currentInstance then
		data.instance = currentInstance
	end

	if currentWeapon and data.fromType ~= data.toType then
		if (data.fromType == 'player' and data.fromSlot == currentWeapon.slot) or (data.toType == 'player' and data.toSlot == currentWeapon.slot) then
			currentWeapon = Weapon.Disarm(currentWeapon, true)
		end
	end

	local success, response, weaponSlot = lib.callback.await('ox_inventory:swapItems', false, data)
    swapActive = false

	cb(success or false)

	if success then
        if weaponSlot and currentWeapon then
            currentWeapon.slot = weaponSlot
        end

		if response then
			updateInventory(response.items, response.weight)
		end
	elseif response then
		if type(response) == 'table' then
			SendNUIMessage({ action = 'refreshSlots', data = { items = response } })
		else
			lib.notify({ type = 'error', description = locale(response) })
		end
	end
end)
```