item_list.drugs = {
    
    --- boii_dispensaries
    pink_runtz_joint = {
        id = 'pink_runtz_joint',
        label = 'Pink Runtz: Joint',
        category = 'drugs',
        model = 'p_cs_joint_02',
        usable = true,
        droppable = true,
        remove_on_use = true,
        modifiers = {
            effect = { category = 'drugs', id = 'joint', duration = 30 },
            buffs = {
                { id = 'stamina', duration = 30 },
                { id = 'health', duration = 30 },
                { id = 'speed', duration = 30 }
            },
            statuses = {
                hunger = { add = 0, remove = 5 },
                thirst = { add = 0, remove = 5 },
                armour = { add = 10, remove = 0 },
                stress = { add = 0, remove = 15 },
            }
        },
        animation = {
            dict = 'timetable@gardener@smoking_joint',
            anim = 'smoke_idle',
            flags = 49,
            duration = 5000,
            freeze = true,
            continuous = false,
            props = {
                { model = 'prop_sh_joint_01', bone = 57005, coords = vector3(0.12, 0.03, -0.05), rotation = vector3(0.0, 10.0, 70.0), soft_pin = false, collision = false, is_ped = true, rot_order = 1, sync_rot = true }
            },
            on_success = {
                event_type = 'server',
                event = 'boii_items:sv:consume_item',
                params = { item = 'pink_runtz_joint' }
            }
        }
    }

}