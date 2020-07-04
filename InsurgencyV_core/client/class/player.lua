


function InitPlayerClass()
    local player = {}

    -- Main player loop
    Citizen.CreateThread(function()
        while true do
            player.ped = GetPlayerPed(-1)
            player.veh = GetVehiclePedIsIn(player.ped, 0)
            player.lastVeh = GetVehiclePedIsIn(player.ped, 1)
            player.health = GetEntityHealth(player.ped)
            Wait(1000)
        end
    end)


    function pPed()
        return player.ped
    end

    function pVeh()
        return player.veh
    end

    function pLastVeh()
        return player.lastVeh
    end

    function phealth()
        return player.health
    end
end