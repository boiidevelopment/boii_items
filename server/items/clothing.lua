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

item_list.clothing = {

    body_armour = {
        id = 'body_armour', -- Unique ID for the item, this should match the key.
        category = 'clothing', -- Category for the item.
        label = 'Body Armour', -- Human readable label for the item.
        description = 'A simple protective vest.', -- Item description.
        image = 'body_armour.png', -- Image for the item.
        model = 'prop_armour_pickup', -- Prop model to spawn if item is dropped.
        weight = 500, -- Item weight in grams.
        max_stack = nil, -- Max amount of items allowed per stack *(this will be used in boii_inventory)*.
        unique = false, -- Unique flag for genuinely unique items *(this will be used in boii_inventory)*.
        grid = { width = 1, height = 1 }, -- Used by boii inventory
        on_use = { -- Define on_use for the item. All items with this section will be initialized as usable on resource start.
            event = { -- Event to run when item is used.
                event_type = 'client', -- Event type: 'server' | 'client'
                event = 'boii_items:cl:equip_clothing', -- The event to fire.
                params = { -- Event parameters.
                    item = 'body_armour', -- Sending item id to ensure we can retreive correct item.
                    clothing = { -- Clothing values.
                        m = { component = 9, drawable = 12, texture = 0 }, -- mp_m_freemode_01
                        f = { component = 9, drawable = 8, texture = 0 } -- mp_f_freemode_01
                    }
                }
            }
        },
        on_drop = { -- If items include this section they become droppable.
            event = { -- Event fired when item is dropped.
                event_type = 'server', -- Event type: 'server' | 'client'
                event = 'boii_items:cl:drop_item', -- The event to fire.
                params = { -- Event parameters.
                    item = 'body_armour' -- Sending item id to ensure we can retreive correct item.
                }
            }
        }
        -- data = {} -- Used to store and track additional item data.
    }

}
