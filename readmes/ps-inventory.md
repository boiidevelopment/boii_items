# PS Setup Instructions

### Drop Items

Doing the following will allow for the use of the `boii_items` on_drop setup, if any items are found within boii_items first, they will be dropped through the system instead of ps-inventory default.

In `ps-inventory/server/main.lua` find the function `CreateNewDrop` and replace with the one below;

```lua
local function CreateNewDrop(source, fromSlot, toSlot, itemAmount, created)
	itemAmount = tonumber(itemAmount) or 1
	local Player = QBCore.Functions.GetPlayer(source)
	local itemData = GetItemBySlot(source, fromSlot)

	if not itemData then return end

	local boii_item = exports.boii_items:get_item(itemData.name)
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
