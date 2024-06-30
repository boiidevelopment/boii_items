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

item_list.kits = {

    repair_kit_pistol = {
        id = 'repair_kit_pistol', -- Unique ID for the item, this should match the key.
        category = 'kits', -- Category for the item.
        label = 'Pistol Repair Kit', -- Human readable label for the item.
        description = 'A kit for repairing standard issue pistols. Restores up to 50% of the weapon\'s durability.',  -- Item description.
        image = 'repair_kit_pistol.png',  -- Image for the item.
        model = 'prop_toolchest_01', -- Prop model to spawn if item is dropped.
        weight = 500, -- Item weight in grams.
        max_stack = nil, -- Max amount of items allowed per stack *(this will be used in boii_inventory)*.
        unique = false, -- Unique flag for genuinely unique items *(this will be used in boii_inventory)*.
        grid = { width = 1, height = 1 }, -- Grid size settings for boii_inventory
        on_use = { -- Define on_use for the item. All items with this section will be initialized as usable on resource start.
            progressbar = { -- Runs a progress bar on item use *(coded with boii_ui in mind however is adaptable to any progress bar)*.
                header = 'Repairing Weapon..', -- Bar header.
                icon = 'fa-solid fa-screwdriver-wrench', -- Bar icon.
                duration = 5500,  -- Bar timer.
                animation = { dict = 'mini@repair', anim = 'fixing_a_ped', flags = 49, blend_in = 8.0, blend_out = -8.0, duration = -1, playback = 1, lock_x = 0, lock_y = 0, lock_z = 0 },  -- Animation to run whilst bar is active.
                -- props = {}, -- Props to use when running bar *(boii_ui supports unlimited props, most othe progress bars only support 2)*.
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
                        event_type = 'client', -- Event type: 'server' | 'client'
                        event = 'boii_items:cl:repair_weapon', -- The event to fire.
                        params = { -- Event parameters.
                            item = 'repair_kit_pistol', -- Sending item id to ensure we can retreive correct item.
                            repair_amount = 50, -- The amount to be added to the weapons durability.
                            compatible = { -- Table of compatible weapons.
                                'weapon_pistol', 'weapon_pistol_mk2', 'weapon_combatpistol'
                            }
                        },
                        -- effects = { }, -- Applies screen effects to player on use, using boii_statuses.
                        -- buffs = { }, -- Applies a buff to player on use, using boii_statuses.
                        -- debuffs = { } -- Applies a debuff to player on use, using boii_statuses.
                    },
                    notify = { -- Notification sent on success.
                        type = 'success',
                        header = 'Weapon Repair',
                        message = 'You used a pistol repair kit.',
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
            }
            --[[
            event = {
                event_type = 'client', -- Event type: 'server' | 'client'
                event = 'boii_items:cl:repair_weapon', -- The event to fire.
                params = { -- Event parameters.
                    item = 'repair_kit_pistol', -- Sending item id to ensure we can retreive correct item.
                    repair_amount = 50, -- The amount to be added to the weapons durability.
                    compatible = { -- Table of compatible weapons.
                        'weapon_pistol', 'weapon_pistol_mk2', 'weapon_combatpistol'
                    }
                },
                -- effects = { }, -- Applies screen effects to player on use, using boii_statuses.
                -- buffs = { }, -- Applies a buff to player on use, using boii_statuses.
                -- debuffs = { } -- Applies a debuff to player on use, using boii_statuses.
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
                    item = 'repair_kit_pistol' -- Sending item id to ensure we can retreive correct item.
                }
            }
        }
        -- data = {}
    }

}
