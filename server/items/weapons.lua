--[[
     ____   ____ _____ _____   _   _____  ________      ________ _      ____  _____  __  __ ______ _   _ _______ 
    |  _ \ / __ \_   _|_   _| | | |  __ \|  ____\ \    / /  ____| |    / __ \|  __ \|  \/  |  ____| \ | |__   __|
    | |_) | |  | || |   | |   | | | |  | | |__   \ \  / /| |__  | |   | |  | | |__) | \  / | |__  |  \| |  | |   
    |  _ <| |  | || |   | |   | | | |  | |  __|   \ \/ / |  __| | |   | |  | |  ___/| |\/| |  __| | . ` |  | |   
    | |_) | |__| || |_ _| |_  | | | |__| | |____   \  /  | |____| |___| |__| | |    | |  | | |____| |\  |  | |   
    |____/ \____/_____|_____| | | |_____/|______|   \/   |______|______\____/|_|    |_|  |_|______|_| \_|  |_|   
                              | |                                                                                
                              |_|                  ITEMS
]]

item_list.weapons = {

    weapon_pistol = {
        id = 'weapon_pistol', -- Unique ID for the item, this should match the key.
        category = 'weapons', -- Category for the item.
        label = 'Pistol', -- Human readable lable for the item.
        description = 'A standard semi-automatic handgun.', -- Item description.
        image = 'weapon_pistol.png', -- Image for the item.
        model = 'prop_box_guncase_01a', -- Prop model to spawn if item is dropped.
        weight = 1500, -- Item weight in grams.
        max_stack = nil, -- Max amount of items allowed per stack *(this will be used in boii_inventory)*.
        unique = false, -- Unique flag for genuinely unique items *(this will be used in boii_inventory)*.
        grid = { width = 2, height = 2 },
        ammo_types = { 'ammo_pistol' }, -- Table of supported ammo types; ammo must be setup correctly in item_list.ammo.
        on_drop = { -- If items include this section they become droppable.
            event = { -- Event fired when item is dropped.
                event_type = 'server', -- Event type: 'server' | 'client'
                event = 'boii_items:cl:drop_item', -- The event to fire.
                params = { -- Event parameters.
                    item = 'weapon_pistol' -- Sending item id to ensure we can retreive correct item.
                }
            }
        },
        data = { -- Used to store and track additional item data.
            ammo = 0, -- Starting ammo when a weapon is first received.
            attachments = {}, -- Table to store equipped attachments.
            durability = 100 -- Starting durability when a weapon is first received.
        }
    }

}
