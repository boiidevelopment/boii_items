# PS Setup Instructions

### Add Items

Doing the following will allow for items to be added to the player from boii_items data bypassing QBCore.Shared.

In `ps-inventory/server/main.lua` find and replace the `AddItem` function with the one below: 

```lua
local function AddItem(source, item, amount, slot, info, created)
    local Player = QBCore.Functions.GetPlayer(source)

    if not Player then return false end

    local totalWeight = GetTotalWeight(Player.PlayerData.items)
    local boii_item = exports.boii_items:find_item(item)
    local itemInfo = boii_item or QBCore.Shared.Items[item:lower()]
    local time = os.time()

    if not itemInfo then
        print('AddItem: Invalid item')
        return false
    end

    if not created then
        itemInfo['created'] = time
    else
        itemInfo['created'] = created
    end

    amount = tonumber(amount) or 1
    slot = tonumber(slot) or GetFirstSlotByItem(Player.PlayerData.items, item)
    info = info or {}
    itemInfo['created'] = created or time
    info.quality = info.quality or 100

    if itemInfo['type'] == 'weapon' then
        info.serie = info.serie or tostring(QBCore.Shared.RandomInt(2) .. QBCore.Shared.RandomStr(3) .. QBCore.Shared.RandomInt(1) .. QBCore.Shared.RandomStr(2) .. QBCore.Shared.RandomInt(3) .. QBCore.Shared.RandomStr(4))
        info.quality = info.quality or 100
    end

    if (totalWeight + (itemInfo['weight'] * amount)) <= Config.MaxInventoryWeight then
        if slot and Player.PlayerData.items[slot] and ((Player.PlayerData.items[slot].name and Player.PlayerData.items[slot].name:lower() == item:lower()) or (Player.PlayerData.items[slot].id and Player.PlayerData.items[slot].id:lower() == item:lower())) and itemInfo['type'] == 'item' and not itemInfo['unique'] then
            if Player.PlayerData.items[slot].info.quality == info.quality then
                Player.PlayerData.items[slot].amount = Player.PlayerData.items[slot].amount + amount
                Player.Functions.SetPlayerData("items", Player.PlayerData.items)
                if Player.Offline then return true end
                TriggerEvent('qb-log:server:CreateLog', 'playerinventory', 'AddItem', 'green', '**' .. GetPlayerName(source) .. ' (citizenid: ' .. Player.PlayerData.citizenid .. ' | id: ' .. source .. ')** got item: [slot:' .. slot .. '], itemname: ' .. (Player.PlayerData.items[slot].name or Player.PlayerData.items[slot].id) .. ', added amount: ' .. amount .. ', new total amount: ' .. Player.PlayerData.items[slot].amount)
                return true
            else
                for i = 1, Config.MaxInventorySlots, 1 do
                    if Player.PlayerData.items[i] == nil then
                        Player.PlayerData.items[i] = {
                            name = boii_item and itemInfo.id or itemInfo['name'],
                            amount = amount,
                            info = info or '',
                            label = itemInfo['label'],
                            description = itemInfo['description'] or '',
                            weight = itemInfo['weight'],
                            type = itemInfo['type'],
                            unique = itemInfo['unique'],
                            image = itemInfo['image'],
                            slot = i,
                        }

                        if boii_item then
                            Player.PlayerData.items[i].category = itemInfo.category
                            Player.PlayerData.items[i].model = itemInfo.model
                            Player.PlayerData.items[i].max_stack = itemInfo.max_stack 
                            if boii_item.category == 'weapons' then
                                if not Player.PlayerData.items[i].info.serie then
                                    Player.PlayerData.items[i].info.serie = tostring(QBCore.Shared.RandomInt(2) .. QBCore.Shared.RandomStr(3) .. QBCore.Shared.RandomInt(1) .. QBCore.Shared.RandomStr(2) .. QBCore.Shared.RandomInt(3) .. QBCore.Shared.RandomStr(4))
                                end
                                if not Player.PlayerData.items[i].info.quality then
                                    Player.PlayerData.items[i].info.quality = 100
                                end
                            end
                        end

                        Player.Functions.SetPlayerData("items", Player.PlayerData.items)
                        if Player.Offline then return true end
                        TriggerEvent('qb-log:server:CreateLog', 'playerinventory', 'AddItem', 'green', '**' .. GetPlayerName(source) .. ' (citizenid: ' .. Player.PlayerData.citizenid .. ' | id: ' .. source .. ')** got item: [slot:' .. i .. '], itemname: ' .. (Player.PlayerData.items[i].name or Player.PlayerData.items[i].id) .. ', added amount: ' .. amount .. ', new total amount: ' .. Player.PlayerData.items[i].amount)
                        return true
                    end
                end
            end
        elseif not itemInfo['unique'] and slot or slot and Player.PlayerData.items[slot] == nil then
            Player.PlayerData.items[slot] = {
                name = boii_item and itemInfo.id or itemInfo['name'],
                amount = amount,
                info = info or '',
                label = itemInfo['label'],
                description = itemInfo['description'] or '',
                weight = itemInfo['weight'],
                type = itemInfo['type'],
                unique = itemInfo['unique'],
                image = itemInfo['image'],
                slot = slot,
            }

            if boii_item then
                Player.PlayerData.items[slot].category = itemInfo.category
                Player.PlayerData.items[slot].model = itemInfo.model
                Player.PlayerData.items[slot].max_stack = itemInfo.max_stack 
                if boii_item.category == 'weapons' then
                    if not Player.PlayerData.items[slot].info.serie then
                        Player.PlayerData.items[slot].info.serie = tostring(QBCore.Shared.RandomInt(2) .. QBCore.Shared.RandomStr(3) .. QBCore.Shared.RandomInt(1) .. QBCore.Shared.RandomStr(2) .. QBCore.Shared.RandomInt(3) .. QBCore.Shared.RandomStr(4))
                    end
                    if not Player.PlayerData.items[slot].info.quality then
                        Player.PlayerData.items[slot].info.quality = 100
                    end
                end
            end

            Player.Functions.SetPlayerData("items", Player.PlayerData.items)
            if Player.Offline then return true end
            TriggerEvent('qb-log:server:CreateLog', 'playerinventory', 'AddItem', 'green', '**' .. GetPlayerName(source) .. ' (citizenid: ' .. Player.PlayerData.citizenid .. ' | id: ' .. source .. ')** got item: [slot:' .. slot .. '], itemname: ' .. (Player.PlayerData.items[slot].name or Player.PlayerData.items[slot].id) .. ', added amount: ' .. amount .. ', new total amount: ' .. Player.PlayerData.items[slot].amount)
            return true
        elseif itemInfo['unique'] or (not slot or slot == nil) or itemInfo['type'] == 'weapon' then
            for i = 1, Config.MaxInventorySlots, 1 do
                if Player.PlayerData.items[i] == nil then
                    Player.PlayerData.items[i] = {
                        name = boii_item and itemInfo.id or itemInfo['name'],
                        amount = amount,
                        info = info or '',
                        label = itemInfo['label'],
                        description = itemInfo['description'] or '',
                        weight = itemInfo['weight'],
                        type = itemInfo['type'],
                        unique = itemInfo['unique'],
                        image = itemInfo['image'],
                        slot = i,
                    }

                    if boii_item then
                        Player.PlayerData.items[i].category = itemInfo.category
                        Player.PlayerData.items[i].model = itemInfo.model
                        Player.PlayerData.items[i].max_stack = itemInfo.max_stack 
                        if boii_item.category == 'weapons' then
                            if not Player.PlayerData.items[i].info.serie then
                                Player.PlayerData.items[i].info.serie = tostring(QBCore.Shared.RandomInt(2) .. QBCore.Shared.RandomStr(3) .. QBCore.Shared.RandomInt(1) .. QBCore.Shared.RandomStr(2) .. QBCore.Shared.RandomInt(3) .. QBCore.Shared.RandomStr(4))
                            end
                            if not Player.PlayerData.items[i].info.quality then
                                Player.PlayerData.items[i].info.quality = 100
                            end
                        end
                    end

                    Player.Functions.SetPlayerData("items", Player.PlayerData.items)
                    if Player.Offline then return true end
                    TriggerEvent('qb-log:server:CreateLog', 'playerinventory', 'AddItem', 'green', '**' .. GetPlayerName(source) .. ' (citizenid: ' .. Player.PlayerData.citizenid .. ' | id: ' .. source .. ')** got item: [slot:' .. i .. '], itemname: ' .. (Player.PlayerData.items[i].name or Player.PlayerData.items[i].id) .. ', added amount: ' .. amount .. ', new total amount: ' .. Player.PlayerData.items[i].amount)
                    return true
                end
            end
        end
    elseif not Player.Offline then
        QBCore.Functions.Notify(source, "Inventory too full", 'error')
    end
    return false
end
```


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
