# BOII | Development - Items

# THIS IS STILL BEING WORKED ON AND WILL BE RELASED AS SOON AS POSSIBLE

## 🌍 Overview

A comprehensive, mostly standalone item management resource.
This resource was created with the intention of filling the need for a shared item section within the BOII framework.
However as this resource relies on our curent boii_utils this can be used on any framework you require. 
The system includes a extensive item setup to allow for on use effects, from handling progress bars, modifying statuses, to applying buffs.
Also includeds a item drop system to allow players to drop synced item props for others to pick up.

Enjoy! 

## 🌐 Features

- **Indepth Item Setup:** Includes a indepth setup for a variety of items.
- **Consumable Items:** Preset to allow for using food and drink items to modify statuses.
- **Usable Weapons:** System allows for usable weapons along with persistant ammo and attachment data.
- **Equipable Clothing:** Includes setup for equipable clothing.
- **Item Drop System:** Any item registered to be droppable can be dropped and a prop will be created persistant in the game world.

## 💹 Dependencies
 
- `boii_utils`

## 📦 Installation

### Prerequisites

- Downloading `boii_utils`:

1. Download the utility library from one of our platforms; 

- https://github.com/boiidevelopment/boii_utils
- https://boiidevelopment.tebex.io/package/5972340

2. Edit `client/config.lua` & `server/config.lua`:

- Set your framework choice under `config.framework`
- Set your notifications choice under `config.notifications`

Any other changes to the configs you wish to make can also be made.

### Script installation

1. Customisation:

- Customise `server/config.lua`
- Customise `server/items/*` to include any items you wish the system to use

2. Installation:

- Drag and drop `boii_items` into your server resources
- Add `ensure boii_items` into your `server.cfg` ensuring it is placed after `boii_utils`

```
ensure boii_utils
ensure boii_items
```

Note: The database tables will be created automatically on first load.

3. Restart server:

- Once you have completed the above steps you are ready to restart your server and test out the script.

## 📝 API

You have access to various functions and exports throughout the resource.

### Client 


### Server

Using Items: 

If you need to trigger a usable item from an external resource you do so using the following: 

- Server side export:
```lua
--- Uses an item.
-- @param _src player: Players source id.
-- @param item_id string: Name of item.
exports.boii_items:use_item(_src, item_id)
```

- Server side event:
```lua
--- Handles using items.
-- @param item_id string: The ID of the item being used.
RegisterServerEvent('boii_items:sv:use_item', function(item_id)
    local _src = source
    use_item(_src, item_id)
end)
```

Dropping Items:

If you need to trigger a item drop from an external resource you do so using the following: 

```lua
--- Drops an item from the player's inventory and creates a item in the world.
-- @param _src number: The source player identifier.
-- @param item_id string: The ID of the item being dropped.
-- @param amount number: The quantity of the item to drop.
exports.boii_items:drop_item(_src, item_id, amount)
```

Picking Up Items:

If you need to trigger a item pick up from an external resource you do so using the following export: 

```lua
--- Executes pick up item.
-- @param _src: Source player.
-- @param net_id: Network ID of the object
-- @param unique_id: Unique ID for the drop.
exports.boii_items:pick_up_item(_src, net_id, unique_id)
```

Consuming Items: 

If you need to trigger consuming items from an external resource you do so using the following:

Either; 

```lua
--- Executes consume item.
-- @param _src: Source player.
-- @param item_id string: The ID of the item being consumed.
exports.boii_items:consume_item(_src, item_id)
```

## 📝 Documentation

https://docs.boii.dev/fivem-resources/free-resources/boii_items

## 📩 Support

https://discord.gg/boiidevelopment
