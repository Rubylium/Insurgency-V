RegisterCommand("devmod", function(source, args, rawCommand)
    EnableDevMod(true)
end, true)

local InDev = false
function EnableDevMod(status)
    if not status then InDev = false return end
    InDev = true
    Citizen.CreateThread(function()
        while InDev do
            print(GetEntityCoords(GetPlayerPed(-1)), GetEntityHeading(GetPlayerPed(-1)))
            Wait(500)
        end
    end)
end