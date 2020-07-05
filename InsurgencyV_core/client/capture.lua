
local captureZone = {
    {label = "Test zone", pos = vector3(13.0, 13.0, 13.0), blip = nil, blip2 = nil, team = "Neutral"},
}


local BlipsInfo = {
    ["army"] = {sprite = 590, color = 77},
    ["resistance"] = {sprite = 543, color = 49},
}

RegisterNetEvent("V:ZoneCaptured")
AddEventHandler("V:ZoneCaptured", function(label, team, id)
    SetAudioFlag("LoadMPData", true)
    PlaySoundFrontend(-1, "ASSASSINATIONS_HOTEL_TIMER_COUNTDOWN", "ASSASSINATION_MULTI", 1)
    ShowPopupWarning("Zone captured!", "The ~b~"..team.."~s~ has captured ~b~"..label.."~s~ zone.")

    RemoveBlip(captureZone[id].blip)
    RemoveBlip(captureZone[id].blip2)

    captureZone[id].blip = AddBlipForCoord(captureZone[id].pos)
    SetBlipSprite(captureZone[id].blip, BlipsInfo[team].sprite)
    SetBlipColour(captureZone[id].blip, BlipsInfo[team].color)
    SetBlipScale(captureZone[id].blip, 1.0)


    captureZone[id].blip2 = AddBlipForRadius(captureZone[id].pos, 20.0)
    SetBlipColour(captureZone[id].blip2, BlipsInfo[team].color)

    captureZone[id].team = team
end)




local InCapture = false
Citizen.CreateThread(function()

    while player.camp == nil do Wait(1) end
    for k,v in pairs(captureZone) do
        captureZone[k].blip = AddBlipForCoord(captureZone[k].pos)
        SetBlipSprite(captureZone[k].blip, 464)
        SetBlipColour(captureZone[k].blip, 55)
        SetBlipScale(captureZone[k].blip, 1.0)
    
        captureZone[k].blip2 = AddBlipForRadius(captureZone[k].pos, 20.0)
        SetBlipColour(captureZone[k].blip2, 55)
    end
    while true do
        local IsCaptureZone = false
        if not InCapture then
            for k,v in pairs(captureZone) do
                if captureZone[k].team ~= player.camp then
                    if GetDistanceBetweenCoords(v.pos, player.coords, true) < 20.0 then
                        InCapture = true
                        StartCapture(k, v.pos)
                        break
                    end
                end
            end
        end
        Wait(500)
    end
end)

local possibleMusic = {
    "https://www.youtube.com/watch?v=mLyzt8zlG-c",
    "https://www.youtube.com/watch?v=U-Az2g0nQeA",
    "https://www.youtube.com/watch?v=y9nbTiI2r8M",
    "https://www.youtube.com/watch?v=sj1ymUTzfvY",
    "https://www.youtube.com/watch?v=k61-CexDaDY",
    "https://www.youtube.com/watch?v=30fUOnV4WPc",
}
function StartCapture(id, pos)
    local oldTime = GetGameTimer()

    TriggerEvent("xsound:stateSound", "play", {
        soundId = "capture", 
        url = possibleMusic[math.random(1,#possibleMusic)], 
        volume = 0.2, 
        loop = true
    })

    Citizen.CreateThread(function()
        while InCapture do
            RageUI.Text({message = "Capture de zone en cours ..."})
            if GetDistanceBetweenCoords(pos, player.coords, true) > 20.0 then
                InCapture = false
            end

            if IsEntityDead(player.ped) then
                InCapture = false
            end
            Wait(1)
        end
    end)

    while InCapture do
        if oldTime + 5000 < GetGameTimer() then
            oldTime = GetGameTimer()

            TriggerServerEvent("V:CapturePoint", id, player.camp)
            TriggerEvent("xsound:stateSound", "destroy", {soundId = "capture", })
            InCapture = false
        end

        Wait(0)
    end
    
end