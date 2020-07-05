

local captureZone = {
    {label = "Test zone", team = "Neutral"},
}



RegisterNetEvent("V:CapturePoint")
AddEventHandler("V:CapturePoint", function(id, team)
    if team ~= "army" and team ~= "resistance" then
        return
    end
    if captureZone[id] ~= nil then
        captureZone[id].team = team
        TriggerClientEvent("V:ZoneCaptured", -1, captureZone[id].label, captureZone[id].team, id)
    end
end)