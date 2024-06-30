--[[
     ____   ____ _____ _____   _   _____  ________      ________ _      ____  _____  __  __ ______ _   _ _______ 
    |  _ \ / __ \_   _|_   _| | | |  __ \|  ____\ \    / /  ____| |    / __ \|  __ \|  \/  |  ____| \ | |__   __|
    | |_) | |  | || |   | |   | | | |  | | |__   \ \  / /| |__  | |   | |  | | |__) | \  / | |__  |  \| |  | |   
    |  _ <| |  | || |   | |   | | | |  | |  __|   \ \/ / |  __| | |   | |  | |  ___/| |\/| |  __| | . ` |  | |   
    | |_) | |__| || |_ _| |_  | | | |__| | |____   \  /  | |____| |___| |__| | |    | |  | | |____| |\  |  | |   
    |____/ \____/_____|_____| | | |_____/|______|   \/   |______|______\____/|_|    |_|  |_|______|_| \_|  |_|   
                              | |                                                                                
                              |_|                 ITEMS
]]

item_list.consumables = {

    water = {
        id = 'water', -- Unique ID for the item, this should match the key.
        category = 'consumables', -- Category for the item.
        label = 'Water', -- Human readable lable for the item.
        description = 'A refreshing bottle of water.', -- Item description.
        image = 'water.png', -- Image for the item.
        model = 'ba_prop_club_water_bottle', -- Prop model to spawn if item is dropped.
        weight = 330, -- Item weight in grams.
        max_stack = nil, -- Max amount of items allowed per stack **(only used by boii inventory you can remove if not required)**.
        unique = false, -- Unique flag for genuinely unique items **(only used by boii inventory you can remove if not required)**.
        grid = { width = 1, height = 1 }, -- Item grid size **(only used by boii inventory you can remove if not required)**.
        on_use = { -- Define on_use for the item. All items with this section will be initialized as usable on resource start.
            progressbar = { -- Runs a progress bar on item use *(coded with boii_ui in mind however is adaptable to any progress bar)*.
                header = 'Drinking Water..', -- Bar header.
                icon = 'fa-solid fa-water', -- Bar icon
                duration = 2500, -- Bar duration in ms
                animation = { dict = 'mp_player_intdrink', anim = 'loop_bottle', flags = 49, blend_in = 8.0, blend_out = -8.0, duration = -1, playback = 1, lock_x = 0, lock_y = 0, lock_z = 0 }, -- Animation to run whilst bar is active.
                props = { -- Props to use when running bar *(boii_ui supports unlimited props, most othe progress bars only support 2)*.
                    { model = 'ba_prop_club_water_bottle', bone = 60309, coords = vector3(0.0, 0.0, 0.05), rotation = vector3(0.0, 0.0, 0.0), soft_pin = false, collision = false, is_ped = true, rot_order = 1, sync_rot = true } -- Prop to create and attach to player.
                },
                --[[
                disabled_controls = { -- Disables controls whilst bar is active.
                    mouse = false, -- Disables mouse controls.
                    movement = false, -- Disables player movement on foot.
                    car_movement = false, -- Disables player movement in a vehicle
                    combat = false, -- Disables player combat.
                },
                ]]
                on_success = { -- Triggers if the progress bar finished successfully.
                    event = {
                        event_type = 'server', -- Event type: 'server' | 'client'
                        event = 'boii_items:sv:consume_item', -- The event to fire.
                        params = { -- Event parameters.
                            item = 'water', -- Sending item id to ensure we can retreive correct item.
                            statuses = { -- Statuses can be adjusted. You can use all of them or just one of them, entirely up to you.
                                --health = { add = 0, remove = 0 },
                                --armour = { add = 0, remove = 0 },
                                hunger = { add = 3, remove = 0 },
                                thirst = { add = 20, remove = 0 },
                                stress = { add = 0, remove = 5 },
                                --stamina = { add = 0, remove = 0 },
                                --oxygen = { add = 0, remove = 0 },
                                --hygiene = { add = 0, remove = 0 },
                            },
                            -- effects = { }, -- Applies screen effects to player on use, using boii_statuses.
                            -- buffs = { }, -- Applies a buff to player on use, using boii_statuses.
                            -- debuffs = { } -- Applies a debuff to player on use, using boii_statuses.
                        },
                    },
                    notify = { -- Notification sent on success.
                        type = 'success',
                        header = 'DRINKING',
                        message = 'You drank a bottle of water.',
                        duration = 3000
                    },
                },
                on_cancel = { -- Triggers if the player cancels the progress bar.
                    notify = { -- Notification sent on cancel.
                        type = 'error',
                        header = 'DRINKING',
                        message = 'You stopped drinking your water..',
                        duration = 3000
                    },
                }
            },
            --[[    
            event = { -- Use events directly without the need for a progress bar.
                event_type = 'server', -- Event type: 'server' | 'client'
                event = 'boii_items:sv:consume_item', -- The event to fire.
                params = { -- Event parameters.
                    item = 'water', -- Sending item id to ensure we can retreive correct item.
                    statuses = { -- Statuses can be adjusted. You can use all of them or just one of them, entirely up to you.
                        health = { add = 0, remove = 0 },
                        armour = { add = 0, remove = 0 },
                        hunger = { add = 3, remove = 0 },
                        thirst = { add = 20, remove = 0 },
                        stress = { add = 0, remove = 0 },
                        stamina = { add = 0, remove = 0 },
                        oxygen = { add = 0, remove = 0 },
                        hygiene = { add = 0, remove = 0 },
                    },
                    effects = { }, -- Applies screen effects to player on use, using boii_statuses.
                    buffs = { }, -- Applies a buff to player on use, using boii_statuses.
                    debuffs = { } -- Applies a debuff to player on use, using boii_statuses.
                },
            },
            effects = { }, -- Applies screen effects to player on use, using boii_statuses.
            buffs = { }, -- Applies a buff to player on use, using boii_statuses.
            debuffs = { } -- Applies a debuff to player on use, using boii_statuses.
            ]]
        },
        on_drop = { -- If items include this section they become droppable.
            event = { -- Event fired when item is dropped.
                event_type = 'server', -- Event type: 'server' | 'client'
                event = 'boii_items:cl:drop_item', -- The event to fire.
                params = { -- Event parameters.
                    item = 'water' -- Sending item id to ensure we can retreive correct item.
                }
            }
        },
        data = { -- Used to store and track additional item data.
            quality = 100 -- Quality of consumables this will be used for degrading food/drinks in a future update.
        }
    },

    burger = {
        id = 'burger',
        category = 'consumables',
        label = 'Burger',
        description = 'A cheap but filling burger.',
        image = 'burger.png',
        weight = 200,
        model = 'prop_cs_burger_01',
        max_stack = nil,
        unique = false,
        grid = { width = 1, height = 1 },
        on_use = {
            progressbar = {
                header = 'Eating Burger..',
                icon = 'fa-solid fa-burger',
                duration = 2500,
                animation = { dict = 'mp_player_inteat@burger', anim = 'mp_player_int_eat_burger', flags = 49, blend_in = 8.0, blend_out = -8.0, duration = -1, playback = 1, lock_x = 0, lock_y = 0, lock_z = 0 },
                props = {
                    { model = 'prop_cs_burger_01', bone = 18905, coords = vector3(0.13, 0.05, 0.02), rotation = vector3(-50.0, 16.0, 60.0), soft_pin = false, collision = false, is_ped = true, rot_order = 1, sync_rot = true }
                },
                on_success = {
                    event = {
                        event_type = 'server',
                        event = 'boii_items:sv:consume_item',
                        params = {
                            item = 'burger',
                            statuses = {
                                hunger = { add = 30, remove = 0 },
                                thirst = { add = 5, remove = 0 },
                                stress = { add = 0, remove = 10 }
                            }
                        },
                    },
                    notify = {
                        type = 'success',
                        header = 'EATING',
                        message = 'You ate a burger.',
                        duration = 3000
                    },
                },
                on_cancel = {
                    notify = {
                        type = 'error',
                        header = 'EATING',
                        message = 'You stopped eating your burger..',
                        duration = 3000
                    },
                }
            }
        },
        on_drop = {
            event = {
                event_type = 'server',
                event = 'boii_items:cl:drop_item',
                params = {
                    item = 'burger'
                }
            }
        },
        data = {
            quality = 100
        }
    }
}