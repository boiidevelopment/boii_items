--- Toggle clothing items.
-- @param item: The item being equipped.
-- @param clothing_data table: Incoming clothing data params.
RegisterNetEvent('boii_items:cl:toggle_clothing', function(item, clothing_data)
    local player_ped = PlayerPedId()
    local gender = (IsPedModel(player_ped, `mp_m_freemode_01`) and 'm') or (IsPedModel(player_ped, `mp_f_freemode_01`) and 'f')
    if not gender or not clothing_data[gender] then
        print('Gender or clothing data not found.')
        return
    end
    local outfit = clothing_data[gender]
    if equipped_clothing[item] then
        SetPedComponentVariation(player_ped, outfit.component, equipped_clothing[item].drawable, equipped_clothing[item].texture, 0)
        equipped_clothing[item] = nil
    else
        equipped_clothing[item] = {
            drawable = GetPedDrawableVariation(player_ped, outfit.component),
            texture = GetPedTextureVariation(player_ped, outfit.component)
        }
        SetPedComponentVariation(player_ped, outfit.component, outfit.drawable, outfit.texture, 0)
    end
end)
