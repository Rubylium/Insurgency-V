
resitance = 0
army = 0

points = {
    army = 0,
    resitance = 0,
}

RegisterNetEvent("V:JoinArmy")
AddEventHandler("V:JoinArmy", function()
    army = army + 1
    TriggerClientEvent("V:Sync", -1, resitance, army, points, GetNumPlayerIndices())
end)

RegisterNetEvent("V:JoinResistance")
AddEventHandler("V:JoinResistance", function()
    resitance = resitance + 1 
    TriggerClientEvent("V:Sync", -1, resitance, army, points, GetNumPlayerIndices())
end)

local WaitingForEndGame = false
Citizen.CreateThread(function()
    while true do
        local armyZone = 0
        local resistanceZone = 0
        local endGameDueToMaxZoneCaptured = false

        if not WaitingForEndGame then
            for k,v in pairs(captureZone) do
                if v.team == "army" then
                    armyZone = armyZone + 1
                    points.army = points.army + 5
                elseif v.team == "resistance" then
                    resistanceZone = resistanceZone + 1
                    points.resitance = points.resitance + 5
                end
            end

            if armyZone == #captureZone then
                endGameDueToMaxZoneCaptured = true
            end

            if resistanceZone == #captureZone then
                endGameDueToMaxZoneCaptured = true
            end
            TriggerClientEvent("V:Sync", -1, resitance, army, points, GetNumPlayerIndices(), endGameDueToMaxZoneCaptured)
            if points.army > 3000 or points.resitance > 3000 then WaitingForEndGame = true end
        end
        print("Army: "..points.army.." vs Resistance: "..points.resitance)
        Wait(5000)
    end
end)

local JustRestared = false
RegisterNetEvent("V:EndGame")
AddEventHandler("V:EndGame", function()
    if JustRestared then return end
    WaitingForEndGame = true
    JustRestared = true


    resitance = 0
    army = 0
    
    points = {
        army = 0,
        resitance = 0,
    }
    
    captureZone = {
        {label = "Silo", team = "Neutral"},
        {label = "Crossroad", team = "Neutral"},
        {label = "Color montain", team = "Neutral"},
        {label = "Sandy Shores", team = "Neutral"},
        {label = "Montain house", team = "Neutral"},
        {label = "Fuel farm", team = "Neutral"},
        {label = "Liquor market", team = "Neutral"},
    }

    local vehs = GetAllVehicles()
    for k,v in pairs(vehs) do
        DeleteEntityYes(v)
    end


    TriggerClientEvent("V:ResetGame", -1)
    Wait(20*1000)
    JustRestared = false
    WaitingForEndGame = false
end)
