resitance = 0
army = 0
players = math.random(1,10)

points = {
    army = 0,
    resitance = 0,
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


RegisterNetEvent("V:Sync")
AddEventHandler("V:Sync", function(r, a, point, num, endGameDueToMaxZoneCaptured, class)
    resitance = r
    army = a
    points = point
    players = num
    classe = class

    if points.army >= 3000 then
        WinGame("army", points.army, points.resitance)
    elseif point.resitance >= 3000 then
        WinGame("resistance", points.army, points.resitance)
    end

    if endGameDueToMaxZoneCaptured then
        WinGame("Max Zone", points.army, points.resitance)
    end
end)


local winActive = false
function WinGame(team, army, resitance)
    if winActive then return end
    winActive = true
    TriggerEvent("xsound:stateSound", "play", {
        soundId = "cinematic", 
        url = "https://www.youtube.com/watch?v=rHtvlftBDHM", 
        volume = 0.10, 
        loop = false
    })
    Wait(45*1000)
    DisplayRadar(false)
    local displayText = true
    Citizen.CreateThread(function()
        
        if IsPedInAnyVehicle(player.ped, false) then
            TaskVehicleDriveWander(player.ped, GetVehiclePedIsIn(player.ped, false), 150.0, 1074528293)
        else
            TaskWanderInArea(player.ped, player.coords, 500.0, 9999999999.0, 1.0)
        end
        local cam = CreateCam("DEFAULT_SCRIPTED_CAMERA", 1)
        RenderScriptCams(1, 0, 0, 0, 0)
        
        local offset = {2.0, 2.0, 2.0}
        offset[1] = offset[1] + 0.01
        offset[2] = offset[2] + 0.01
        offset[3] = offset[3] + 0.01
        local coords = GetOffsetFromEntityInWorldCoords(player.ped, offset[1], offset[2], offset[3])
        SetCamCoord(cam, coords)
        PointCamAtCoord(cam, GetEntityCoords(GetPlayerPed(-1)))
        SetCamFov(cam, 50.0)
        ShakeCam(cam, "HAND_SHAKE", 0.2)

        while displayText do
            Wait(1)

            offset[1] = offset[1] - 0.02
            offset[2] = offset[2] + 0.01
            offset[3] = offset[3] + 0.01
            local coords = GetOffsetFromEntityInWorldCoords(player.ped, offset[1], offset[2], offset[3])
            SetCamCoord(cam, coords)
            PointCamAtCoord(cam, GetEntityCoords(GetPlayerPed(-1)))

            SetTextColour(255, 255, 255, 255)
            SetTextFont(4)
            SetTextScale(2.0, 2.0)
            SetTextWrap(0.0, 1.0)
            SetTextCentre(true)
            SetTextDropshadow(2, 2, 0, 0, 0)
            SetTextEdge(1, 0, 0, 0, 205)
            SetTextEntry("STRING")
            AddTextComponentString("Army: "..army.." points.\nResistance: "..resitance.." points.")
            DrawText(0.500, 0.500)
        end
    end)
    Wait(20*1000)
    ClearPedTasks(player.ped)
    RenderScriptCams(0, 0, 0, 0, 0)
    displayText = false
    InCinematicMenu = true
    DoCinematic()
    RageUI.Visible(RMenu:Get('core', 'cinematic'), true)
    OpenCinematicMenu()
    TriggerServerEvent("V:EndGame")
    winActive = false
end