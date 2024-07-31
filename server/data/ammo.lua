item_list.ammo = {

    ammo_pistol = {
        id = 'ammo_pistol',
        category = 'ammo',
        label = 'Pistol Ammo',
        description = 'Generic pistol ammo useable by pistol weapon types.', 
        model = 'prop_ld_ammo_pack_01',
        droppable = true,
        remove_on_use = true,
        modifiers = {
            ammo = { amount = 12 }
        },
        event = {
            event_type = 'client',
            event = 'boii_items:cl:reload_weapon',
            params = { item = 'ammo_pistol' }
        }
    }

}