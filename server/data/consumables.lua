--- First item in the list is a full example of what can be used when creating items.
--- Sections are executed in a specific order when using items, so if you have an animation and progress bar setup the animation will be triggered and not the progress bar.
--- Execution order: animation, progressbar, event.
item_list.consumables = {
    water = {
        id = 'water',
        label = 'Water',
        category = 'consumables',
        model = 'prop_cs_burger_01',
        droppable = true,
        modifiers = {
            debuffs = {
                { id = 'mild_sickness', duration = 6 },
            },
            statuses = {
                hunger = { add = 3, remove = 0 },
                thirst = { add = 20, remove = 0 },
                stress = { add = 0, remove = 5 },
                --[[
                health = { add = 0, remove = 0 },
                armour = { add = 0, remove = 0 },
                stamina = { add = 0, remove = 0 },
                oxygen = { add = 0, remove = 0 },
                hygiene = { add = 0, remove = 0 },
                ]]
            }
        },
        animation = {
            dict = 'mp_player_intdrink',
            anim = 'loop_bottle',
            flags = 49,
            duration = 5000,
            freeze = false,
            continuous = false,
            props = {
                { model = 'ba_prop_club_water_bottle', bone = 60309, coords = vector3(0.0, 0.0, 0.05), rotation = vector3(0.0, 0.0, 0.0), soft_pin = false, collision = false, is_ped = true, rot_order = 1, sync_rot = true }
            },
            on_success = {
                event_type = 'server',
                event = 'boii_items:sv:consume_item',
                params = { item = 'water' }
            }
        },
        --[[
        progressbar = {
            header = 'Eating Burger..',
            icon = 'fa-solid fa-hamburger',
            duration = 2500,
            disable_controls = {
                mouse = false,
                movement = false,
                car_movement = false,
                combat = false
            },
            animation = { dict = 'mp_player_intdrink', anim = 'loop_bottle', flags = 49, blend_in = 8.0, blend_out = -8.0, duration = -1, playback = 1, lock_x = 0, lock_y = 0, lock_z = 0 },
            props = {
                { model = 'ba_prop_club_water_bottle', bone = 60309, coords = vector3(0.0, 0.0, 0.05), rotation = vector3(0.0, 0.0, 0.0), soft_pin = false, collision = false, is_ped = true, rot_order = 1, sync_rot = true }
            },
            on_success = {
                event_type = 'server',
                event = 'boii_items:sv:consume_item',
                params = { item = 'burger' }
            },
            on_cancel = {
                event_type = 'server',
                event = 'boii_items:sv:consume_item',
                params = { item = 'burger' }
            }
        }
        event = {
            event_type = 'server',
            event = 'boii_items:sv:consume_item',
            params = { item = 'burger' }
        },
        notify = {
            type = 'success',
            header = 'DRINKING',
            message = 'You drank some water.',
            duration = 3000
        }
        ]]
    },
    burger = {
        id = 'burger',
        label = 'Burger',
        category = 'consumables',
        model = 'prop_cs_burger_01',
        droppable = true,
        modifiers = {
            statuses = {
                hunger = { add = 3, remove = 0 },
                thirst = { add = 20, remove = 0 }
            }
        },
        animation = {
            dict = 'mp_player_inteat@burger',
            anim = 'mp_player_int_eat_burger_fp',
            flags = 49,
            duration = 5000,
            freeze = true,
            continuous = false,
            props = {
                { model = 'prop_cs_burger_01', bone = 18905, coords = vector3(0.13, 0.05, 0.02), rotation = vector3(-50.0, 16.0, 60.0), soft_pin = false, collision = false, is_ped = true, rot_order = 1, sync_rot = true }
            },
            on_success = {
                event_type = 'server',
                event = 'boii_items:sv:consume_item',
                params = { item = 'burger' }
            }
        }
    }
}