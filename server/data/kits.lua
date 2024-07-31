item_list.kits = {
    weapon_repair_kit = {
        id = 'weapon_repair_kit',
        label = 'Weapon Repair Kit',
        category = 'kits',
        model = 'prop_tool_box_01',
        droppable = true,
        remove_on_use = true,
        modifiers = {
            repair = { type = 'weapon', compatible = { 'weapon_pistol', 'weapon_pistol_mk2', 'weapon_combatpistol' }, amount = 50 }
        },
        animation = {
            dict = 'mini@repair',
            anim = 'fixing_a_ped',
            flags = 49,
            duration = 10000,
            freeze = true,
            continuous = false,
            on_success = {
                event_type = 'server',
                event = 'boii_items:sv:consume_item',
                params = { item = 'weapon_repair_kit' }
            }
        }
    },
    vehicle_repair_kit = {
        id = 'vehicle_repair_kit',
        label = 'Vehicle Repair Kit',
        category = 'kits',
        model = 'prop_tool_box_02',
        droppable = true,
        remove_on_use = true,
        modifiers = {
            repair = { type = 'vehicle', compatible = { 'Compacts', 'Coupes', 'Sedans' }, amount = 500.0 }
        },
        animation = {
            dict = 'mini@repair',
            anim = 'fixing_a_ped',
            flags = 49,
            duration = 10000,
            freeze = true,
            continuous = false,
            on_success = {
                event_type = 'server',
                event = 'boii_items:sv:consume_item',
                params = { item = 'vehicle_repair_kit' }
            }
        }
    }
}
