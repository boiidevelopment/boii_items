# PS Setup Instructions

### Use Items

Doing the following will allow for the use of the `boii_items` on_use setup, if any items are found within boii_items first, they will be used through the system instead of ps-inventory default.

In `ps-inventory/server/main.lua` find the event `UseItemSlot` and replace with the one below:

```lua
RegisterNetEvent('inventory:server:UseItemSlot', function(slot)
	local src = source

	local Player = QBCore.Functions.GetPlayer(src)
	local itemData = Player.Functions.GetItemBySlot(slot)
	if itemData then

		local boii_item = exports.boii_items:find_item(itemData.name)
		if boii_item and (boii_item.on_use or boii_item.category == 'weapons') then
			TriggerClientEvent('ps-inventory:client:closeinv', src)
			if boii_item.category == 'weapons' then
				exports.boii_items:use_weapon(src, itemData.name)
			else
				exports.boii_items:use_item(src, itemData.name)
			end
			TriggerClientEvent('inventory:client:ItemBox', src, { label = boii_item.label, image = boii_item.image, amount = boii_item.quantity }, 'use')
			return
		end

		local itemInfo = QBCore.Shared.Items[itemData.name]
		if itemData.type == "weapon" then
			if itemData.info.quality then
				if itemData.info.quality > 0 then
					TriggerClientEvent("inventory:client:UseWeapon", src, itemData, true)
				else
					TriggerClientEvent("inventory:client:UseWeapon", src, itemData, false)
				end
			else
				TriggerClientEvent("inventory:client:UseWeapon", src, itemData, true)
			end
			TriggerClientEvent('inventory:client:ItemBox', src, itemInfo, "use")
		elseif itemData.useable then
			if itemData.info.quality then
				if itemData.info.quality > 0 then
					UseItem(itemData.name, src, itemData)
					TriggerClientEvent('inventory:client:ItemBox', src, itemInfo, "use")
				else
					if itemInfo['delete'] and RemoveItem(src,itemData.name,1,slot) then
						TriggerClientEvent('inventory:client:ItemBox',src, itemInfo, "remove")
					else
						TriggerClientEvent("QBCore:Notify", src, "You can't use this item", "error")
					end
				end
			else
				UseItem(itemData.name, src, itemData)
				TriggerClientEvent('inventory:client:ItemBox', src, itemInfo, "use")
			end
		end
	end
end)
```

In `ps-inventory/server/main.lua` find the event `UseItem` and replace with the one below:

```lua
RegisterNetEvent('inventory:server:UseItem', function(inventory, item)
	local src = source
	local Player = QBCore.Functions.GetPlayer(src)
	if inventory == "player" or inventory == "hotbar" then
		local itemData = Player.Functions.GetItemBySlot(item.slot)
		if itemData then

			local boii_item = exports.boii_items:find_item(itemData.name)
			if boii_item and (boii_item.on_use or boii_item.category == 'weapons') then
				TriggerClientEvent(src, 'ps-inventory:client:closeinv')
				if boii_item.category == 'weapons' then
					exports.boii_items:use_weapon(src, itemData.name)
				else
					exports.boii_items:use_item(src, itemData.name)
				end
				TriggerClientEvent('inventory:client:ItemBox', src, { label = boii_item.label, image = boii_item.image, amount = boii_item.quantity }, 'use')
				return
			end

			local itemInfo = QBCore.Shared.Items[itemData.name]
			if itemData.type ~= "weapon" then
				if itemData.info.quality then
					if itemData.info.quality <= 0 then
						if itemInfo['delete'] and RemoveItem(src,itemData.name,1,item.slot) then
							TriggerClientEvent("QBCore:Notify", src, "You can't use this item", "error")
							TriggerClientEvent('inventory:client:ItemBox',src, itemInfo, "remove")
							return
	else
							TriggerClientEvent("QBCore:Notify", src, "You can't use this item", "error")
							return
						end
					end
				end
			end
			UseItem(itemData.name, src, itemData)
			TriggerClientEvent('inventory:client:ItemBox', src, itemInfo, "use")
		end
	end
end)
```

### Drop Items

Doing the following will allow for the use of the `boii_items` on_drop setup, if any items are found within boii_items first, they will be dropped through the system instead of ps-inventory default.

In `ps-inventory/server/main.lua` find the function `CreateNewDrop` and replace with the one below;

```lua
local function CreateNewDrop(source, fromSlot, toSlot, itemAmount, created)
	itemAmount = tonumber(itemAmount) or 1
	local Player = QBCore.Functions.GetPlayer(source)
	local itemData = GetItemBySlot(source, fromSlot)

	if not itemData then return end

	local boii_item = exports.boii_items:find_item(itemData.name)
    if boii_item and boii_item.on_drop then
        TriggerClientEvent('ps-inventory:client:closeinv', source)
		exports.boii_items:drop_item(source, itemData.name, itemAmount)
        return
    end

	local coords = GetEntityCoords(GetPlayerPed(source))
	if RemoveItem(source, itemData.name, itemAmount, itemData.slot) then
		TriggerClientEvent("inventory:client:CheckWeapon", source, itemData.name)
		local itemInfo = QBCore.Shared.Items[itemData.name:lower()]
		local dropId = CreateDropId()
		Drops[dropId] = {}
		Drops[dropId].coords = coords
		Drops[dropId].createdTime = os.time()

		Drops[dropId].items = {}

		Drops[dropId].items[toSlot] = {
			name = itemInfo["name"],
			amount = itemAmount,
			info = itemData.info or "",
			label = itemInfo["label"],
			description = itemInfo["description"] or "",
			weight = itemInfo["weight"],
			type = itemInfo["type"],
			unique = itemInfo["unique"],
			useable = itemInfo["useable"],
			image = itemInfo["image"],
			created = created,
			slot = toSlot,
			id = dropId,
		}
		TriggerEvent("qb-log:server:CreateLog", "drop", "New Item Drop", "red", "**".. GetPlayerName(source) .. "** (citizenid: *"..Player.PlayerData.citizenid.."* | id: *"..source.."*) dropped new item; name: **"..itemData.name.."**, amount: **" .. itemAmount .. "**")
		TriggerClientEvent("inventory:client:DropItemAnim", source)
		TriggerClientEvent("inventory:client:AddDropItem", -1, dropId, source, coords)
		if itemData.name:lower() == "radio" then
			TriggerClientEvent('Radio.Set', source, false)
		end
	else
		TriggerClientEvent("QBCore:Notify", source, "You don't have this item!", "error")
		return
	end
end
```
