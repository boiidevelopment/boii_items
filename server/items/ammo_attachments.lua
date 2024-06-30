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

item_list.ammo = {

    ammo_pistol = {
        id = 'ammo_pistol', -- Unique ID for the item, this should match the key.
        category = 'ammo', -- Category for the item.
        label = 'Pistol Ammo', -- Human readable label for the item.
        description = 'Generic pistol ammo useable by pistol weapon types.', -- Item description.
        image = 'ammo_pistol.png', -- Image for the item.
        model = 'prop_ld_ammo_pack_01', -- Prop model to spawn if item is dropped.
        weight = 200, -- Item weight in grams.
        max_stack = nil, -- Max amount of items allowed per stack *(this will be used in boii_inventory)*.
        unique = false, -- Unique flag for genuinely unique items *(this will be used in boii_inventory)*.
        grid = { width = 1, height = 1 }, -- Used by boii_inventory
        on_use = { -- Define on_use for the item. All items with this section will be initialized as usable on resource start.
            progressbar = { -- Runs a progress bar on item use *(coded with boii_ui in mind however is adaptable to any progress bar)*.
                header = 'Reloading Weapon..', -- Bar header.
                icon = 'fa-solid fa-person-rifle', -- Bar icon.
                duration = 2500, -- Bar timer.
                disabled_controls = { -- Disables controls whilst bar is active.
                    -- mouse = false, -- Disables mouse controls.
                    -- movement = false, -- Disables player movement on foot.
                    -- car_movement = false, -- Disables player movement in a vehicle
                    combat = true, -- Disables player combat.
                },
                on_success = { -- Triggers if the progress bar finished successfully.
                    event = {
                        event_type = 'client', -- Event type: 'server' | 'client'
                        event = 'boii_items:cl:reload_weapon',  -- The event to fire.
                        params = { -- Event parameters.
                            item = 'ammo_pistol', -- Sending item id to ensure we can retreive correct item.
                            ammo_count = 12 -- The amount of ammo to add to compatible weapons.
                        },
                        -- effects = { }, -- Applies screen effects to player on use, using boii_statuses.
                        -- buffs = { }, -- Applies a buff to player on use, using boii_statuses.
                        -- debuffs = { } -- Applies a debuff to player on use, using boii_statuses.
                    },
                    notify = { -- Notification sent on success.
                        type = 'success',
                        header = 'EATING',
                        message = 'You reloaded your weapon.',
                        duration = 3000
                    },
                },
                on_cancel = { -- Triggers if the player cancels the progress bar.
                    notify = { -- Notification sent on cancel.
                        type = 'error',
                        header = 'EATING',
                        message = 'You stopped reloading your weapon..',
                        duration = 3000
                    },
                }
            },
            --[[    
            event = {
                event_type = 'client', -- Event type: 'server' | 'client'
                event = 'boii_items:cl:reload_weapon',  -- The event to fire.
                params = { -- Event parameters.
                    item = 'ammo_pistol', -- Sending item id to ensure we can retreive correct item.
                    ammo_count = 12 -- The amount of ammo to add to compatible weapons.
                },
                -- effects = { }, -- Applies screen effects to player on use, using boii_statuses.
                -- buffs = { }, -- Applies a buff to player on use, using boii_statuses.
                -- debuffs = { } -- Applies a debuff to player on use, using boii_statuses.
            }
            ]]
        },
        on_drop = { -- If items include this section they become droppable.
            event = { -- Event fired when item is dropped.
                event_type = 'server', -- Event type: 'server' | 'client'
                event = 'boii_items:cl:drop_item', -- The event to fire.
                params = { -- Event parameters.
                    item = 'ammo_pistol' -- Sending item id to ensure we can retreive correct item.
                }
            }
        }
        -- data = {} -- Used to store and track additional item data.
    }
}

item_list.weapon_attachments = {

    default_clip_pistol = {
        id = 'default_clip_pistol', -- Unique ID for the item, this should match the key.
        category = 'weapon_attachment', -- Category for the item.
        label = 'Default Clip: Pistol', -- Human readable lable for the item.
        description = 'Default clip for various pistol types.', -- Item description.
        image = 'default_clip_pistol.png', -- Image for the item.
        model = 'prop_box_guncase_02a', -- Prop model to spawn if item is dropped.
        weight = 100, -- Item weight in grams.
        max_stack = nil, -- Max amount of items allowed per stack *(this will be used in boii_inventory)*.
        unique = false, -- Unique flag for genuinely unique items *(this will be used in boii_inventory)*.
        grid = { width = 1, height = 1 }, -- Used by boii_inventory
        on_use = { -- Define on_use for the item. All items with this section will be initialized as usable on resource start.
            progressbar = { -- Runs a progress bar on item use *(coded with boii_ui in mind however is adaptable to any progress bar)*.
                header = 'Modifying Weapon...', -- Bar header.
                icon = 'fa-solid fa-screwdriver-wrench', -- Bar icon
                duration = 2500, -- Bar duration in ms
                disabled_controls = { -- Disables controls whilst bar is active.
                    -- mouse = false, -- Disables mouse controls.
                    -- movement = false, -- Disables player movement on foot.
                    -- car_movement = false, -- Disables player movement in a vehicle
                    combat = true, -- Disables player combat.
                },
                on_success = { -- Triggers if the progress bar finished successfully.
                    event = {
                        event_type = 'client', -- Event type: 'server' | 'client'
                        event = 'boii_items:cl:modify_weapon', -- The event to fire.
                        params = { -- Event parameters. 
                            item = 'default_clip_pistol', -- Sending item id to ensure we can retreive correct item.
                            compatibility = { -- Defines what weapons the attachments are usable by and the corresponding component to equip.
                                { weapon = 'weapon_pistol', component = 'COMPONENT_PISTOL_CLIP_01' },
                                { weapon = 'weapon_pistol_mk2', component = 'COMPONENT_PISTOL_MK2_CLIP_01' },
                                { weapon = 'weapon_combatpistol', component = 'COMPONENT_COMBATPISTOL_CLIP_01' },
                                { weapon = 'weapon_appistol', component = 'COMPONENT_APPISTOL_CLIP_01' },
                                { weapon = 'weapon_pistol50', component = 'COMPONENT_PISTOL50_CLIP_01' },
                                { weapon = 'weapon_revolver', component = 'COMPONENT_REVOLVER_CLIP_01' },
                                { weapon = 'weapon_snspistol', component = 'COMPONENT_SNSPISTOL_CLIP_01' },
                                { weapon = 'weapon_snspistol_mk2', component = 'COMPONENT_SNSPISTOL_MK2_CLIP_01' },
                                { weapon = 'weapon_heavypistol', component = 'COMPONENT_HEAVYPISTOL_CLIP_01' },
                                { weapon = 'weapon_vintagepistol', component = 'COMPONENT_VINTAGEPISTOL_CLIP_01' },
                                { weapon = 'weapon_ceramicpistol', component = 'COMPONENT_CERAMICPISTOL_CLIP_01' },
                            },
                            -- effects = { }, -- Applies screen effects to player on use, using boii_statuses.
                            -- buffs = { }, -- Applies a buff to player on use, using boii_statuses.
                            -- debuffs = { } -- Applies a debuff to player on use, using boii_statuses.
                        }
                    },
                    notify = { -- Notification sent on success.
                        type = 'success',
                        header = 'Modification Success',
                        message = 'You modified your weapon.',
                        duration = 3000
                    },
                },
                on_cancel = { -- Triggers if the player cancels the progress bar.
                    notify = { -- Notification sent on cancel.
                        type = 'error',
                        header = 'Modification Cancelled',
                        message = 'You stopped modifying your weapon.',
                        duration = 3000
                    },
                }
            }
        },
        --[[
        event = {
            event_type = 'client', -- Event type: 'server' | 'client'
            event = 'boii_items:cl:modify_weapon', -- The event to fire.
            params = { -- Event parameters. 
                item = 'default_clip_pistol', -- Sending item id to ensure we can retreive correct item.
                compatibility = { -- Defines what weapons the attachments are usable by and the corresponding component to equip.
                    { weapon = 'weapon_pistol', component = 'COMPONENT_PISTOL_CLIP_01' },
                    { weapon = 'weapon_pistol_mk2', component = 'COMPONENT_PISTOL_MK2_CLIP_01' },
                    { weapon = 'weapon_combatpistol', component = 'COMPONENT_COMBATPISTOL_CLIP_01' },
                    { weapon = 'weapon_appistol', component = 'COMPONENT_APPISTOL_CLIP_01' },
                    { weapon = 'weapon_pistol50', component = 'COMPONENT_PISTOL50_CLIP_01' },
                    { weapon = 'weapon_revolver', component = 'COMPONENT_REVOLVER_CLIP_01' },
                    { weapon = 'weapon_snspistol', component = 'COMPONENT_SNSPISTOL_CLIP_01' },
                    { weapon = 'weapon_snspistol_mk2', component = 'COMPONENT_SNSPISTOL_MK2_CLIP_01' },
                    { weapon = 'weapon_heavypistol', component = 'COMPONENT_HEAVYPISTOL_CLIP_01' },
                    { weapon = 'weapon_vintagepistol', component = 'COMPONENT_VINTAGEPISTOL_CLIP_01' },
                    { weapon = 'weapon_ceramicpistol', component = 'COMPONENT_CERAMICPISTOL_CLIP_01' },
                },
                -- effects = { }, -- Applies screen effects to player on use, using boii_statuses.
                -- buffs = { }, -- Applies a buff to player on use, using boii_statuses.
                -- debuffs = { } -- Applies a debuff to player on use, using boii_statuses.
            }
        },
        effects = { }, -- Applies screen effects to player on use, using boii_statuses.
        buffs = { }, -- Applies a buff to player on use, using boii_statuses.
        debuffs = { } -- Applies a debuff to player on use, using boii_statuses.
        ]]
        on_drop = { -- If items include this section they become droppable.
            event = { -- Event fired when item is dropped.
                event_type = 'server', -- Event type: 'server' | 'client'
                event = 'boii_items:cl:drop_item', -- The event to fire.
                params = { -- Event parameters.
                    item = 'default_clip_pistol' -- Sending item id to ensure we can retreive correct item.
                }
            }
        }
    },

    extended_clip_pistol = {
        id = 'extended_clip_pistol',
        category = 'weapon_attachment',
        label = 'Extended Clip: Pistol',
        description = 'Extended clip for various pistol types.',
        image = 'extended_clip_pistol.png',
        model = 'prop_box_guncase_02a',
        weight = 100,
        max_stack = nil,
        unique = false,
        grid = { width = 1, height = 1 },
        on_use = {
            progressbar = {
                header = 'Modifying Weapon...',
                icon = 'fa-solid fa-screwdriver-wrench',
                duration = 2500,
                disabled_controls = {
                    combat = true
                },
                on_success = {
                    event = {
                        event_type = 'client',
                        event = 'boii_items:cl:modify_weapon',
                        params = { 
                            item = 'extended_clip_pistol',
                            compatibility = {
                                { weapon = 'weapon_pistol', component = 'COMPONENT_PISTOL_CLIP_02' },
                                { weapon = 'weapon_pistol_mk2', component = 'COMPONENT_PISTOL_MK2_CLIP_02' },
                                { weapon = 'weapon_combatpistol', component = 'COMPONENT_COMBATPISTOL_CLIP_02' },
                                { weapon = 'weapon_appistol', component = 'COMPONENT_APPISTOL_CLIP_02' },
                                { weapon = 'weapon_pistol50', component = 'COMPONENT_PISTOL50_CLIP_02' },
                                { weapon = 'weapon_snspistol', component = 'COMPONENT_SNSPISTOL_CLIP_02' },
                                { weapon = 'weapon_snspistol_mk2', component = 'COMPONENT_SNSPISTOL_MK2_CLIP_02' },
                                { weapon = 'weapon_heavypistol', component = 'COMPONENT_HEAVYPISTOL_CLIP_02' },
                                { weapon = 'weapon_vintagepistol', component = 'COMPONENT_VINTAGEPISTOL_CLIP_02' },
                                { weapon = 'weapon_ceramicpistol', component = 'COMPONENT_CERAMICPISTOL_CLIP_02' },
                            }
                        }
                    },
                    notify = {
                        type = 'success',
                        header = 'Modification Success',
                        message = 'You modified your weapon.',
                        duration = 3000
                    },
                },
                on_cancel = {
                    notify = {
                        type = 'error',
                        header = 'Modification Cancelled',
                        message = 'You stopped modifying your weapon.',
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
                    item = 'default_clip_pistol'
                }
            }
        }
    },

    attachment_flashlight = {
        id = 'attachment_flashlight',
        category = 'weapon_attachment',
        label = 'Flashlight Attachment',
        description = 'Flashlight attachment usable by various weapons.',
        image = 'attachment_flashlight.png',
        model = 'prop_box_guncase_02a',
        weight = 100,
        compatibility = {
            { weapon = 'weapon_pistol', component = 'COMPONENT_AT_PI_FLSH' },
            { weapon = 'weapon_pistol_mk2', component = 'COMPONENT_AT_PI_FLSH_02' },
            { weapon = 'weapon_combatpistol', component = 'COMPONENT_AT_PI_FLSH' },
            { weapon = 'weapon_appistol', component = 'COMPONENT_AT_PI_FLSH' },
            { weapon = 'weapon_pistol50', component = 'COMPONENT_AT_PI_FLSH' },
            { weapon = 'weapon_revolver_mk2', component = 'COMPONENT_AT_PI_FLSH' },
            { weapon = 'weapon_snspistol', component = 'COMPONENT_SNSPISTOL_CLIP_02' },
            { weapon = 'weapon_snspistol_mk2', component = 'COMPONENT_AT_PI_FLSH_03' },
            { weapon = 'weapon_heavypistol', component = 'COMPONENT_AT_PI_FLSH' },
            { weapon = 'weapon_microsmg', component = 'COMPONENT_AT_PI_FLSH' }
        },
        on_use = {
            progressbar = {
                header = 'Modifying Weapon...',
                icon = 'fa-solid fa-screwdriver-wrench',
                duration = 2500,
                disabled_controls = {
                    combat = true
                },
                on_success = {
                    event = {
                        event_type = 'client',
                        event = 'boii_items:cl:modify_weapon',
                        params = { item = 'extended_clip_pistol' },
                    },
                    notify = {
                        type = 'success',
                        header = 'Modification Success',
                        message = 'You modified your weapon.',
                        duration = 3000
                    },
                },
                on_cancel = {
                    notify = {
                        type = 'error',
                        header = 'Modification Cancelled',
                        message = 'You stopped modifying your weapon.',
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
                    item = 'default_clip_pistol'
                }
            }
        }
    },

}