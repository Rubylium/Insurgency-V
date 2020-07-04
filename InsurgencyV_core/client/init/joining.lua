Citizen.CreateThread(function()
    while not NetworkIsSessionActive() do Wait(1) end


    InitWatermark()
    InitPlayerClass()
    initCinematic()
end)

local cam = nil
local InCinematic = false
local cams = {
    {pos = vector3(729.41, 2528.05, 86.65), lookAt = vector3(1084.22, 2711.88, 44.7)},
    {pos = vector3(-2357.99, 3242.93, 93.6), lookAt = vector3(-1889.62, 2982.23, 48.01)},
}


function initCinematic()
    DisplayRadar(false)
    DoScreenFadeOut(100)
    while not IsScreenFadedOut() do Wait(1) end
    InCinematic = true
    SetNuiFocus(true, true)
    TriggerEvent("xsound:stateSound", "play", {
        soundId = "cinematic", 
        url = "https://www.youtube.com/watch?v=Jme5hYgXbNY&list=PL953Es57AbWdc4oqOC5HWLWGD7Xvk1qYd&index=1", 
        volume = 0.3, 
        loop = true
    })

    Citizen.CreateThread(function()
        DoScreenFadeIn(2500)
        while InCinematic do
            DoScreenFadeIn(2500)
            if cam == nil then
                cam = CreateCam("DEFAULT_SCRIPTED_CAMERA", 1)
                RenderScriptCams(1, 0, 0, 0, 0)
            end
            local r = cams[math.random(1,#cams)]
            SetCamCoord(cam, r.pos)
            PointCamAtCoord(cam, r.lookAt)
            SetCamFov(cam, 50.0)
            SetFocusArea(r.pos, 0.0, 0.0, 0.0)
            SetCamShakeAmplitude(cam, 2.0)
            ShakeGameplayCam("ROAD_VIBRATION_SHAKE", 0.75)
            Wait(15000)
            if not InCinematic then 
                RenderScriptCams(0, 0, 0, 0, 0)
                StopGameplayCamShaking(false)
                return 
            end
            DoScreenFadeOut(2500)
            while not IsScreenFadedOut() do Wait(1) end
        end
    end)

    -- Display menu
    local InCinematicMenu = true

    RMenu.Add('core', 'cinematic', RageUI.CreateMenu("RageUI", "Undefined for using SetSubtitle"))
    RMenu:Get('core', 'cinematic'):SetSubtitle("~b~RAGEUI SHOWCASE")
    RMenu:Get('core', 'cinematic').EnableMouse = true
    RMenu:Get('core', 'cinematic').Closed = function()
        InCinematicMenu = false
    end;
    RMenu:Get("core", "cinematic").Closable = false
    RageUI.Visible(RMenu:Get('core', 'cinematic'), true)
    RageUI.SetStyleAudio("RageUI")


    Citizen.CreateThread(function()
        while InCinematicMenu do
            Wait(1)
            RageUI.IsVisible(RMenu:Get('core', 'cinematic'), false, false, false, function()
                RageUI.ButtonWithStyle("Join the army", nil, {}, true, function(_, _, s)
                    if s then

                    end
                end)
                RageUI.ButtonWithStyle("Join the resistance", nil, {}, true, function(_, _, s)
                    if s then

                    end
                end)
            end, function()
            end)
        end
    end)
end