


function InitPlayerClass()
    player = {
        pPed = function()
            return self.ped
        end,

        pVeh = function()
            return self.veh
        end,

        pLastVeh = function()
            return self.lastVeh
        end,

        phealth = function()
            return self.health
        end,

        pName = function()
            return self.name
        end,
    }

    -- Main player loop
    Citizen.CreateThread(function()
        while true do
            player.ped = GetPlayerPed(-1)
            player.veh = GetVehiclePedIsIn(player.ped, 0)
            player.lastVeh = GetVehiclePedIsIn(player.ped, 1)
            player.health = GetEntityHealth(player.ped)
            player.name = GetPlayerName(GetPlayerIndex())
            Wait(1000)
        end
    end)
end