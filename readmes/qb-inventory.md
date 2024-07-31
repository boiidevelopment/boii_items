# QBCore Setup Instructions

## QBCore New Inventory

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

### Drop Items

Setup instructions here should be virtually the same a ps-inventory.
This will be updated asap however a lot of people are moving away from the old inventory now.