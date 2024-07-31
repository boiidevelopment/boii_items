effects = {
    drugs = {
        joint = function(duration)
            Wait(2000)
            ShakeGameplayCam('SMALL_EXPLOSION_SHAKE', 0.08)
            StartScreenEffect('DrugsMichaelAliensFight', 0, true)       
            Wait(duration)
            ClearTimecycleModifier()
            StopScreenEffect('DrugsMichaelAliensFight')
            ShakeGameplayCam('SMALL_EXPLOSION_SHAKE', 0.0)
        end,
        edibles = function(duration)
            Wait(2000)
            ShakeGameplayCam('SMALL_EXPLOSION_SHAKE', 0.08)
            SetTimecycleModifier('spectator5')       
            Wait(duration)
            ClearTimecycleModifier()
            ShakeGameplayCam('SMALL_EXPLOSION_SHAKE', 0.0)
        end,
        bong = function(duration)
            Wait(2000)
            ShakeGameplayCam('SMALL_EXPLOSION_SHAKE', 0.08)
            SetTimecycleModifier('spectator8')       
            Wait(duration)
            ClearTimecycleModifier()
            ShakeGameplayCam('SMALL_EXPLOSION_SHAKE', 0.0)
        end
    }
}

--- Event to trigger effects.
RegisterNetEvent('boii_items:cl:effects', function(_src, data)
    if not _src then print('Player source missing.') return end
    if not data then print('Data missing.') return end
    if _src == GetPlayerServerId(PlayerId()) then
        local category = effects[data.category]
        if category then
            local effect = category[data.id]
            if effect then
                effect(data.duration * 1000)
            else
                print('No effect found for:', data.id)
            end
        else
            print('No category found for:', data.category)
        end
    end
end)
