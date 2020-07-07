


local safezone = {
    vector3(-2337.62, 3263.19, 31.83),
    vector3(182.16, 2708.5, 41.29),
}



Citizen.CreateThread(function()
    Wait(5000)
    while player == nil do Wait(100) end
    while player.coords == nil do Wait(100) end
    while true do
        Wait(1)
        local InZone = false
        for k,v in pairs(safezone) do
            local dst = GetDistanceBetweenCoords(v, player.coords, false)
            if dst < 30.0 then
                RageUI.Text({message = "You are in safezone ...", time_display = 1000})
                SetEntityInvincible(GetPlayerPed(-1), true)
                if IsPedInAnyVehicle(GetPlayerPed(-1), false) then
                    SetEntityInvincible(GetVehiclePedIsIn(GetPlayerPed(-1), false), true)
                end
                InZone = true
                break
            else
                if not InZone then
                    SetEntityInvincible(GetPlayerPed(-1), false)
                    if IsPedInAnyVehicle(GetPlayerPed(-1), false) then
                        SetEntityInvincible(GetVehiclePedIsIn(GetPlayerPed(-1), false), false)
                    end
                end
            end
        end
    end
end)