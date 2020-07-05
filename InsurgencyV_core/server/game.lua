
resitance = 0
army = 0

points = {
    army = 0,
    resitance = 0,
}


function DeleteEntityYes(net)
    Citizen.InvokeNative(`DELETE_ENTITY` & 0xFFFFFFFF, net)
end





Citizen.CreateThread(function()
    while true do
        for k,v in pairs(captureZone) do
            if v.team == "army" then
                points.army = points.army + 5
            elseif v.item == "resistance" then
                points.resitance = points.resitance + 5
            end
        end
        TriggerClientEvent("V:Sync", -1, resitance, army, points)
        Wait(5000)
    end
end)