RegisterCommand("reset", function(source, args, rawCommand)
    if source == 0 then
        local vehs = GetAllVehicles()
        for k,v in pairs(vehs) do
            DeleteEntityYes(v)
        end

    end
end, true)

RegisterNetEvent("DeleteEntity")
AddEventHandler("DeleteEntity", function(table)
    for k,v in pairs(table) do
        local net = NetworkGetEntityFromNetworkId(v)
        Citizen.InvokeNative(`DELETE_ENTITY` & 0xFFFFFFFF, net)
    end
end)


function DeleteEntityYes(net)
    Citizen.InvokeNative(`DELETE_ENTITY` & 0xFFFFFFFF, net)
end