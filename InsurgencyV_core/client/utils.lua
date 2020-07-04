

function LoadModel(model)
    local model = GetHashKey(model)
    RequestModel(model)
    while not HasModelLoaded(model) do Wait(0) end
end


function ShowHelpNotification(msg, thisFrame)
	AddTextEntry('HelpNotif', msg)
	DisplayHelpTextThisFrame('HelpNotif', false)
end


function SpawnVeh(model)
    LoadModel(model)
    local veh = CreateVehicle(GetHashKey(model), player.coords, GetEntityHeading(player.ped), 1, 0)
    SetPedIntoVehicle(player.pPed, veh, -1)
end