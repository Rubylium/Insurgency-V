

RegisterCommand("reset", function(source, args, rawCommand)
    if source == 0 then
        local vehs = GetAllVehicles()
        for k,v in pairs(vehs) do
            DeleteEntityYes(v)
        end
    end
end, true)


function DeleteEntityYes(net)
    Citizen.InvokeNative(`DELETE_ENTITY` & 0xFFFFFFFF, net)
end