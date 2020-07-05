RegisterCommand("reset", function(source, args, rawCommand)
    if source == 0 then
        local vehs = GetAllVehicles()
        for k,v in pairs(vehs) do
            DeleteEntityYes(v)
        end

        resitance = 0
        army = 0
    end
end, true)