
resitance = {}
army = {}

points = {
    army = 0,
    resitance = 0,
}


local ClassCache = {}
classe = {
    resistance = {
        ["Rifleman"] = 0,
        ["Engineer"] = 0,
        ["Recon"] = 0,
        ["Medic"] = 0,
    },
    army = {
        ["Rifleman"] = 0,
        ["Engineer"] = 0,
        ["Recon"] = 0,
        ["Medic"] = 0,
    },
}

RegisterNetEvent("V:JoinClass")
AddEventHandler("V:JoinClass", function(team, class)
    if team == nil or class == nil then return end
    if ClassCache[source] ~= nil then
        local _team = ClassCache[source].teams
        local _class = ClassCache[source].classes
    
        if _team == "resistance" then
            classe.resistance[_class] = classe.resistance[_class] - 1
        elseif _team == "army" then
            classe.army[_class] = classe.army[_class] - 1
        end   
    end


    if team == "resistance" then
        classe.resistance[class] = classe.resistance[class] + 1
    elseif _team == "army" then
        classe.army[class] = classe.army[class] + 1
    end
    ClassCache[source] = {teams = team, classes = class}
    TriggerClientEvent("V:Sync", -1, #resitance, #army, points, GetNumPlayerIndices(), endGameDueToMaxZoneCaptured, classe)
end)

AddEventHandler('playerDropped', function (reason)
    if ClassCache[source] == nil then return end
    local team = ClassCache[source].teams
    local class = ClassCache[source].classes

    if team == "resistance" then
        classe.resistance[class] = classe.resistance[class] - 1
    elseif _team == "army" then
        classe.army[class] = classe.army[class] - 1
    end

    for k,v in pairs(army) do
        if GetPlayerPing(v.id) == 0 then
            table.remove(army, k)
            print("^1REMOVING: ^7"..v.." from army cache")
        end
    end

    for k,v in pairs(resitance) do
        if GetPlayerPing(v.id) == 0 then
            table.remove(resitance, k)
            print("^1REMOVING: ^7"..v.." from resistance cache")
        end
    end

    TriggerClientEvent("V:Sync", -1, #resitance, #army, points, GetNumPlayerIndices(), endGameDueToMaxZoneCaptured, classe)
end)

RegisterNetEvent("V:JoinArmy")
AddEventHandler("V:JoinArmy", function()
    table.insert(army, {id = source})
    for k,v in pairs(army) do
        if GetPlayerPing(v.id) == 0 then
            table.remove(army, k)
            print("^1REMOVING: ^7"..v.." from army cache")
        end
    end
    TriggerClientEvent("V:Sync", -1, #resitance, #army, points, GetNumPlayerIndices(), false, classe)
end)

RegisterNetEvent("V:JoinResistance")
AddEventHandler("V:JoinResistance", function()
    table.insert(resitance, {id = source})
    for k,v in pairs(resitance) do
        if GetPlayerPing(v.id) == 0 then
            table.remove(resitance, k)
            print("^1REMOVING: ^7"..v.." from resistance cache")
        end
    end
    TriggerClientEvent("V:Sync", -1, #resitance, #army, points, GetNumPlayerIndices(), false, classe)
end)

RegisterNetEvent("V:GetHealed")
AddEventHandler("V:GetHealed", function(id)
    TriggerClientEvent("V:GetHealed", id)
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
            TriggerClientEvent("V:Sync", -1, #resitance, #army, points, GetNumPlayerIndices(), endGameDueToMaxZoneCaptured, classe)
            if points.army > 3000 or points.resitance > 3000 then WaitingForEndGame = true end
        end
        Wait(5000)
    end
end)


Citizen.CreateThread(function()
    while true do
        local webhook = "https://discordapp.com/api/webhooks/730505958345801759/vt14-INulxcufdFmwYONFQ1zWhQW1hOT3TOgbgSEZ0t1K05vXiLLXnWN2GBT-djh3_3G"

        local connect = {
            {
                ["color"] = "8663711",
                ["title"] = "Insurgency Status game #1",
                ["description"] = "**Army stats:**\n**"..#army.."** players\n**"..points.army.."** points\n\n**Resistance stats**:\n**"..#resitance.."** players\n**"..points.resitance.."** points\n\n**"..GetNumPlayerIndices().."** players online.",
                ["footer"] = {
                    ["text"] = "Insurgency V - An Rubylium project.",
                },
            }
        }

        PerformHttpRequest(webhook, function(err, text, headers) end, 'POST', json.encode({username = DISCORD_NAME, embeds = connect}), { ['Content-Type'] = 'application/json' })
        Wait(5*60*1000)
    end
end)

local JustRestared = false
RegisterNetEvent("V:EndGame")
AddEventHandler("V:EndGame", function()
    if JustRestared then return end
    WaitingForEndGame = true
    JustRestared = true


    resitance = {}
    army = {}
    
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

    classe = {
        resistance = {
            ["Rifleman"] = 0,
            ["Engineer"] = 0,
            ["Recon"] = 0,
            ["Medic"] = 0,
        },
        army = {
            ["Rifleman"] = 0,
            ["Engineer"] = 0,
            ["Recon"] = 0,
            ["Medic"] = 0,
        },
    }

    local vehs = GetAllVehicles()
    for k,v in pairs(vehs) do
        DeleteEntityYes(v)
    end


    TriggerClientEvent("V:ResetGame", -1)
    Wait(320*1000)
    JustRestared = false
    WaitingForEndGame = false
end)
