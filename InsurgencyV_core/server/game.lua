
resitance = 0
army = 0

points = {
    army = 0,
    resitance = 0,
}

RegisterNetEvent("V:JoinArmy")
AddEventHandler("V:JoinArmy", function()
    army = army + 1
end)

RegisterNetEvent("V:JoinResistance")
AddEventHandler("V:JoinResistance", function()
    resitance = resitance + 1 
end)

local WaitingForEndGame = false
Citizen.CreateThread(function()
    while true do
        if not WaitingForEndGame then
            for k,v in pairs(captureZone) do
                if v.team == "army" then
                    points.army = points.army + 5
                elseif v.team == "resistance" then
                    points.resitance = points.resitance + 5
                end
            end
            TriggerClientEvent("V:Sync", -1, resitance, army, points, GetNumPlayerIndices())
            if points.army > 5000 or points.resitance > 5000 then WaitingForEndGame = true end
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
        {label = "Sandy Shores",team = "Neutral"},
        {label = "Yellow Jack", team = "Neutral"},
        {label = "Mine", team = "Neutral"},
        {label = "Montain house", team = "Neutral"},
        {label = "Fuel farm",  team = "Neutral"},
        {label = "Church", team = "Neutral"},
        {label = "Vacation house", team = "Neutral"},
        {label = "Deposit", team = "Neutral"},
        {label = "Camp", team = "Neutral"},
        {label = "Liquor market", team = "Neutral"},
    }


    TriggerClientEvent("V:ResetGame", -1)
    Wait(20*1000)
    JustRestared = false
    WaitingForEndGame = false
end)
