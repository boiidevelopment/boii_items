# QBCore Setup Instructions

## QBCore New Inventory

### Add Items

Doing the following will allow for items to be added to the player from boii_items data bypassing QBCore.Shared.

In `qb-inventory/server/functions.lua` find and replace the `AddItem` function with the one below: 

```lua
--- Adds an item to the player's inventory or a specific inventory.
--- @param identifier string The identifier of the player or inventory.
--- @param item string The name of the item to add.
--- @param amount number The amount of the item to add.
--- @param slot number (optional) The slot to add the item to. If not provided, it will find the first available slot.
--- @param info table (optional) Additional information about the item.
--- @param reason string (optional) The reason for adding the item.
--- @return boolean Returns true if the item was successfully added, false otherwise.
function AddItem(identifier, item, amount, slot, info, reason)
    local boii_item = exports.boii_items:find_item(item)
    local itemInfo = boii_item or QBCore.Shared.Items[item:lower()]
    
    if not itemInfo then
        print('AddItem: Invalid item')
        return false
    end
    
    local inventory, inventoryWeight, inventorySlots
    local player = QBCore.Functions.GetPlayer(identifier)

    if player then
        inventory = player.PlayerData.items
        inventoryWeight = Config.MaxWeight
        inventorySlots = Config.MaxSlots
    elseif Inventories[identifier] then
        inventory = Inventories[identifier].items
        inventoryWeight = Inventories[identifier].maxweight
        inventorySlots = Inventories[identifier].slots
    elseif Drops[identifier] then
        inventory = Drops[identifier].items
        inventoryWeight = Drops[identifier].maxweight
        inventorySlots = Drops[identifier].slots
    end

    if not inventory then
        print('AddItem: Inventory not found')
        return false
    end

    local totalWeight = GetTotalWeight(inventory)
    if totalWeight + (itemInfo.weight * amount) > inventoryWeight then
        print('AddItem: Not enough weight available')
        return false
    end

    amount = tonumber(amount) or 1
    local updated = false

    if not itemInfo.unique then
        slot = slot or GetFirstSlotByItem(inventory, item)
        if slot then
            for _, invItem in pairs(inventory) do
                if invItem.slot == slot then
                    invItem.amount = invItem.amount + amount
                    updated = true
                    break
                end
            end
        end
    end

    if not updated then
        slot = slot or GetFirstFreeSlot(inventory, inventorySlots)
        if not slot then
            print('AddItem: No free slot available')
            return false
        end

        local newItem = {
            name = item,
            amount = amount,
            info = info or {},
            label = itemInfo.label,
            description = itemInfo.description or '',
            weight = itemInfo.weight,
            type = itemInfo.type,
            unique = itemInfo.unique,
            image = itemInfo.image,
            slot = slot,
        }

        if boii_item then
            newItem.category = itemInfo.category
            newItem.model = itemInfo.model
            newItem.max_stack = itemInfo.max_stack
            if boii_item.category == 'weapons' then
                if not newItem.info.serie then
                    newItem.info.serie = tostring(QBCore.Shared.RandomInt(2) .. QBCore.Shared.RandomStr(3) .. QBCore.Shared.RandomInt(1) .. QBCore.Shared.RandomStr(2) .. QBCore.Shared.RandomInt(3) .. QBCore.Shared.RandomStr(4))
                end
                if not newItem.info.quality then
                    newItem.info.quality = 100
                end
            end
        else
            newItem.useable = itemInfo.useable
            newItem.shouldClose = itemInfo.shouldClose
            newItem.combinable = itemInfo.combinable
            if QBCore.Shared.SplitStr(item, '_')[1] == 'weapon' then
                if not newItem.info.serie then
                    newItem.info.serie = tostring(QBCore.Shared.RandomInt(2) .. QBCore.Shared.RandomStr(3) .. QBCore.Shared.RandomInt(1) .. QBCore.Shared.RandomStr(2) .. QBCore.Shared.RandomInt(3) .. QBCore.Shared.RandomStr(4))
                end
                if not newItem.info.quality then
                    newItem.info.quality = 100
                end
            end
        end

        inventory[slot] = newItem
    end

    if player then player.Functions.SetPlayerData('items', inventory) end
    local invName = player and GetPlayerName(identifier) .. ' (' .. identifier .. ')' or identifier
    local addReason = reason or 'No reason specified'
    local resourceName = GetInvokingResource() or 'qb-inventory'
    TriggerEvent(
        'qb-log:server:CreateLog',
        'playerinventory',
        'Item Added',
        'green',
        '**Inventory:** ' .. invName .. ' (Slot: ' .. slot .. ')\n' ..
        '**Item:** ' .. item .. '\n' ..
        '**Amount:** ' .. amount .. '\n' ..
        '**Reason:** ' .. addReason .. '\n' ..
        '**Resource:** ' .. resourceName
    )
    return true
end
```

### Remove Items

Doing the following will allow for items to be removed from the player from boii_items data bypassing QBCore.Shared.

In `qb-inventory/server/functions.lua` find and replace the `RemoveItem` function with the one below: 

```lua
-- Removes an item from a player's inventory.
--- @param identifier string - The identifier of the player.
--- @param item string - The name of the item to remove.
--- @param amount number - The amount of the item to remove.
--- @param slot number - The slot number of the item in the inventory. If not provided, it will find the first slot with the item.
--- @param reason string - The reason for removing the item. Defaults to 'No reason specified' if not provided.
--- @return boolean - Returns true if the item was successfully removed, false otherwise.
function RemoveItem(identifier, item, amount, slot, reason)
    local boii_item = exports.boii_items:find_item(item)
    local itemInfo = boii_item or QBCore.Shared.Items[item:lower()]

    if not itemInfo then
        print('RemoveItem: Invalid item')
        return false
    end

    local inventory
    local player = QBCore.Functions.GetPlayer(identifier)

    if player then
        inventory = player.PlayerData.items
    elseif Inventories[identifier] then
        inventory = Inventories[identifier].items
    elseif Drops[identifier] then
        inventory = Drops[identifier].items
    end

    if not inventory then
        print('RemoveItem: Inventory not found')
        return false
    end

    slot = tonumber(slot) or GetFirstSlotByItem(inventory, item)

    if not slot then
        print('RemoveItem: Slot not found')
        return false
    end

    local inventoryItem = inventory[slot]
    if not inventoryItem or inventoryItem.name:lower() ~= item:lower() then
        print('RemoveItem: Item not found in slot')
        return false
    end

    amount = tonumber(amount)
    if inventoryItem.amount < amount then
        print('RemoveItem: Not enough items in slot')
        return false
    end

    inventoryItem.amount = inventoryItem.amount - amount
    if inventoryItem.amount <= 0 then
        inventory[slot] = nil
    end

    if player then player.Functions.SetPlayerData('items', inventory) end
    local invName = player and GetPlayerName(identifier) .. ' (' .. identifier .. ')' or identifier
    local removeReason = reason or 'No reason specified'
    local resourceName = GetInvokingResource() or 'qb-inventory'
    TriggerEvent(
        'qb-log:server:CreateLog',
        'playerinventory',
        'Item Removed',
        'red',
        '**Inventory:** ' .. invName .. ' (Slot: ' .. slot .. ')\n' ..
        '**Item:** ' .. item .. '\n' ..
        '**Amount:** ' .. amount .. '\n' ..
        '**Reason:** ' .. removeReason .. '\n' ..
        '**Resource:** ' .. resourceName
    )
    return true
end
```

### Use Items

Doing the following will allow for the use of the `boii_items` on_use setup, if any items are found within boii_items first, they will be used through the system instead of qbcore default.

In `qb-inventory/server/main.lua` find the following event `useItem` and replace with the one below:

```lua
RegisterNetEvent('qb-inventory:server:useItem', function(item)
    local boii_item = exports.boii_items:find_item(item.name)
    if boii_item and (boii_item.on_use or boii_item.category == 'weapons') then
        TriggerClientEvent(source, 'qb-inventory:client:closeInv')
        if boii_item.category == 'weapons' then
            exports.boii_items:use_weapon(source, item.name)
        else
            exports.boii_items:use_item(source, item.name)
        end
        TriggerClientEvent('qb-inventory:client:ItemBox', source, { label = boii_item.label, image = boii_item.image, amount = boii_item.quantity }, 'use')
        return
    end
    
    local itemData = GetItemBySlot(source, item.slot)
    if not itemData then return end
    local itemInfo = QBCore.Shared.Items[itemData.name]
    if itemData.type == 'weapon' then
        TriggerClientEvent('qb-weapons:client:UseWeapon', source, itemData, itemData.info.quality and itemData.info.quality > 0)
        TriggerClientEvent('qb-inventory:client:ItemBox', source, itemInfo, 'use')
    else
        UseItem(itemData.name, source, itemData)
        TriggerClientEvent('qb-inventory:client:ItemBox', source, itemInfo, 'use')
    end
end)
```

### Drop Items

Doing the following will allow for the use of the `boii_items` on_drop setup, if any items are found within boii_items first, they will be dropped through the system instead of qbcore default.

In `qb-inventory/client/drops.lua` find the nui callback `DropItem` and replace with the one below;

```lua
RegisterNUICallback('DropItem', function(item, cb)
    local boii_item = exports.boii_items:find_item(item.name)
    if boii_item and boii_item.on_drop then
        TriggerEvent('qb-inventory:client:closeInv')
        TriggerServerEvent('boii_items:sv:drop', { item = item.name, amount = item.amount })
        return
    end
    
    QBCore.Functions.TriggerCallback('qb-inventory:server:createDrop', function(dropId)
        if dropId then
            while not NetworkDoesNetworkIdExist(dropId) do Wait(10) end
            local bag = NetworkGetEntityFromNetworkId(dropId)
            SetModelAsNoLongerNeeded(bag)
            PlaceObjectOnGroundProperly(bag)
            FreezeEntityPosition(bag, true)
            local newDropId = 'drop-' .. dropId
            cb(newDropId)
        else
            cb(false)
        end
    end, item)
end)
```

## QBCore Old Inventory : todo

### Use Items


### Drop Items
