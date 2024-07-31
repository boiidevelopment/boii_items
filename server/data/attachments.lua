item_list.attachments = {

    default_clip_pistol = {
        id = 'default_clip_pistol',
        category = 'attachment',
        label = 'Default Clip: Pistol',
        description = 'Default clip for various pistol types.',
        model = 'prop_box_guncase_02a',
        droppable = true,
        remove_on_use = false,
        modifiers = {
            attachments = { 
                compatibility = {
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
                }
            }
        },
        event = {
            event_type = 'client',
            event = 'boii_items:cl:modify_weapon',
            params = { item = 'default_clip_pistol' }
        }
    },
    
    extended_clip_pistol = {
        id = 'extended_clip_pistol',
        category = 'attachment',
        label = 'Extended Clip: Pistol',
        description = 'Extended clip for various pistol types.',
        model = 'prop_box_guncase_02a',
        droppable = true,
        remove_on_use = false,
        modifiers = {
            attachments = { 
                compatibility = {
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
                }
            }
        },
        event = {
            event_type = 'client',
            event = 'boii_items:cl:modify_weapon',
            params = { item = 'extended_clip_pistol' }
        }
    },
    
    wep_flashlight = {
        id = 'wep_flashlight',
        category = 'attachment',
        label = 'Flashlight Attachment',
        description = 'Flashlight attachment usable by various weapons.',
        model = 'prop_box_guncase_02a',
        droppable = true,
        remove_on_use = false,
        modifiers = {
            attachments = { 
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
                }
            }
        },
        event = {
            event_type = 'client',
            event = 'boii_items:cl:modify_weapon',
            params = { item = 'wep_flashlight' }
        }
    }

}