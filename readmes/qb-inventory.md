# QBCore Setup Instructions

## QBCore New Inventory

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