debuffs = {
    stamina = function(duration)
        local stamina_debuff = true
        local start_time = GetGameTimer()
        while stamina_debuff do
            SetPlayerStamina(PlayerId(), GetPlayerStamina(PlayerId()) - math.random(1, 8))
            Wait(1000)
            if GetGameTimer() - start_time > duration then
                stamina_debuff = false
            end
        end
    end,
    health = function(duration)
        local player_ped = PlayerPedId()
        local health_debuff = true
        local start_time = GetGameTimer()
        while health_debuff do
            local health = GetEntityHealth(ped)
            SetEntityHealth(ped, health - 2)
            Wait(1000)
            if GetGameTimer() - start_time > duration then
                health_debuff = false
            end
        end
    end,
    mild_sickness = function(duration)
        local player_ped = PlayerPedId()
        send_notification('DEBUFF', 'You feel sick..', 'info', 3500)
        Wait(duration)
        utils.player.play_animation(player_ped, {
            dict = 'move_m@_idles@out_of_breath',
            anim = 'idle_a',
            flags = 49,
            duration = 5000,
            freeze = true,
            continuous = false
        }, function()
            utils.player.play_animation(player_ped, {
                dict = 're@construction',
                anim = 'out_of_breath',
                flags = 49,
                duration = 3000,
                freeze = true,
                continuous = false
            }, function()
                SetEntityHealth(player_ped, GetEntityHealth(player_ped) - math.random(5, 10))
            end)
        end)
    end
}

--- Event to apply debuffs
--- @field debuff_name string: Name of the debuff to apply.
--- @field duration number: Duration for debuff in seconds.
RegisterNetEvent('boii_items:cl:apply_debuff', function(debuff_name, duration)
    local debuff = debuffs[debuff_name]
    if debuff then
        debuff(duration * 1000)
    else
        print('No debuff found for:', debuff_name)
    end
end)