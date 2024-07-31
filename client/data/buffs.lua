buffs = {
    stamina = function(duration)
        local stamina_buff = true
        local start_time = GetGameTimer()
        while stamina_buff do
            SetPlayerStamina(PlayerId(), GetPlayerStamina(PlayerId()) + math.random(5, 15))
            Wait(1000)
            if GetGameTimer() - start_time > duration then
                stamina_buff = false
            end
        end
    end,
    health = function(duration)
        local ped = PlayerPedId()
        local health_buff = true
        local start_time = GetGameTimer()
        while health_buff do
            local health = GetEntityHealth(ped)
            SetEntityHealth(ped, health + 2)
            Wait(1000)
            if GetGameTimer() - start_time > duration then
                health_buff = false
            end
        end
    end,
    speed = function(duration)
        local speed_buff = true
        local start_time = GetGameTimer()
        while speed_buff do
            SetRunSprintMultiplierForPlayer(PlayerId(), 1.49)
            Wait(1000)
            if GetGameTimer() - start_time > duration then
                speed_buff = false
            end
            SetRunSprintMultiplierForPlayer(PlayerId(), 1.0)
        end
    end
}

--- Event to apply buffs
--- @field buff_name string: Name of the buff to apply.
--- @field duration number: Duration for buff in seconds.
RegisterNetEvent('boii_items:cl:apply_buff', function(buff_name, duration)
    local buff = buffs[buff_name]
    if buff then
        buff(duration * 1000)
    else
        print('No buff found for:', buff_name)
    end
end)