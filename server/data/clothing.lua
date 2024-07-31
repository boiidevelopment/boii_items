item_list.clothing = {

    body_armour = {
        id = 'body_armour',
        label = 'Body Armour',
        category = 'clothing',
        model = 'prop_armour_pickup',
        usable = true,
        droppable = true,
        remove_on_use = false,
        modifiers = {
            clothing = {
                m = { component = 9, drawable = 12, texture = 0 }, -- mp_m_freemode_01 only
                f = { component = 9, drawable = 8, texture = 0 } -- mp_f_freemode_01 only
            }
        },
        animation = {
            dict = 'clothingshirt',
            anim = 'try_shirt_positive_d',
            flags = 49,
            duration = 1000,
            freeze = false,
            continuous = false,
            on_success = {
                event_type = 'server',
                event = 'boii_items:sv:equip_clothing',
                params = { item = 'body_armour' }
            }
        }
    }

}