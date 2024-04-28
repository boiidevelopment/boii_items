# BOII | Development - Items

# THIS RESOURCE IS STILL IN ALPHA STAGES IT WILL BE IMPROVED ON. SOME BUGS ARE TOO BE EXPECTED!

![ITEMS_THUMB](https://github.com/boiidevelopment/boii_items/assets/90377400/ef81187a-ecf7-4fc3-a868-28614aa523fb)

## 🌍 Overview

A comprehensive, mostly standalone item management resource. 
This resource was created with the intention of filling the need for a shared item section within the BOII framework. 

However as this resource relies on our current boii_utils this can be used on any framework you require. 

The system includes a extensive item setup to allow for on use effects, from handling progress bars, modifying statuses, to applying buffs. 

Also included is an item drop system to allow players to drop synced item props for others to pick up.
*(for inventories you will have to modify this yourself)*

Enjoy!

## 🌐 Features

- **In-depth Item Setup:** Includes a in-depth setup for a variety of items.
- **Consumable Items:** Preset to allow for using food and drink items to modify statuses.
- **Usable Weapons:** System allows for usable weapons along with persistent ammo and attachment data.
- **Equipable Clothing:** Includes setup for equipable clothing.
- **Item Drop System:** Any item registered to be droppable can be dropped and a prop will be created persistent in the game world.

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

## 📝 Documentation

https://docs.boii.dev/fivem-resources/free-resources/boii_items

## 📩 Support

https://discord.gg/boiidevelopment
