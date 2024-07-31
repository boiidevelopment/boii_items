item_list.medical = {

    painkillers = {
        id = 'painkillers',
        label = 'Painkillers',
        category = 'medical',
        model = 'prop_cs_pills',
        droppable = true,
        modifiers = {
            statuses = {
                health = { add = 20, remove = 0 }
            }
        },
        animation = {
            dict = 'mp_suicide',
            anim = 'pill',
            flags = 49,
            duration = 3000,
            freeze = false,
            continuous = false,
            on_success = {
                event_type = 'server',
                event = 'boii_items:sv:consume_item',
                params = { item = 'painkillers' }
            }
        }
    }

}
