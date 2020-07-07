

captureZone = {
    {label = "Silo", team = "Neutral"},
    {label = "Crossroad", team = "Neutral"},
    {label = "Color montain", team = "Neutral"},
    {label = "Sandy Shores", team = "Neutral"},
    {label = "Montain house", team = "Neutral"},
    {label = "Fuel farm", team = "Neutral"},
    {label = "Liquor market", team = "Neutral"},
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


RegisterNetEvent("V:RequestBlipSync")
AddEventHandler("V:RequestBlipSync", function()
    TriggerClientEvent("V:SyncBlips", source, captureZone)
end)