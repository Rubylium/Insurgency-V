


local safezone = {
    vector3(-2337.62, 3263.19, 31.83),
    vector3(2930.63, 4623.93, 47.72),
}



Citizen.CreateThread(function()
    while player == nil do Wait(100) end
    while player.coords == nil do Wait(100) end
    while true do
        Wait(1000)
        for k,v in pairs(safezone) do
            local dst = GetDistanceBetweenCoords(v, player.coords, false)
            if dst < 30.0 then
                RageUI.Text({message = "You are in safezone ...", time_display = 1000})
                SetEntityInvincible(player.ped, true)
                if IsPedInAnyVehicle(player.ped, false) then
                    SetEntityInvincible(GetVehiclePedIsIn(player.ped, false), true)
                end
                break
            else
                SetEntityInvincible(player.ped, false)
                if IsPedInAnyVehicle(player.ped, false) then
                    SetEntityInvincible(GetVehiclePedIsIn(player.ped, false), false)
                end
            end
        end
    end
end)