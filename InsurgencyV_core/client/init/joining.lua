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
    SetNuiFocus(true, true)


    function DoCinematic()
        InCinematic = true
        Citizen.CreateThread(function()
            TriggerEvent("xsound:stateSound", "play", {
                soundId = "cinematic", 
                url = "https://www.youtube.com/watch?v=Jme5hYgXbNY&list=PL953Es57AbWdc4oqOC5HWLWGD7Xvk1qYd&index=1", 
                volume = 0.3, 
                loop = true
            })
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
                    StopGameplayCamShaking(false)
                    return 
                end
                DoScreenFadeOut(2500)
                while not IsScreenFadedOut() do Wait(1) end
            end
            StopGameplayCamShaking(false)
        end)
    end
    DoCinematic()

    -- Display menu
    local InCinematicMenu = true

    RMenu.Add('core', 'cinematic', RageUI.CreateMenu("Insurgency V", "~b~Choose your side ..."))
    RMenu:Get('core', 'cinematic').Closed = function()
        InCinematicMenu = false
    end;
    RMenu:Get("core", "cinematic").Closable = false

    RMenu.Add('core', 'army_choose', RageUI.CreateSubMenu(RMenu:Get('core', 'cinematic'), "Army", "~b~Choose your ped ..."))
    RMenu:Get('core', 'army_choose').Closed = function()
        TriggerEvent("xsound:stateSound", "destroy", {soundId = "cinematic",})
        DoCinematic()
    end;


    RageUI.Visible(RMenu:Get('core', 'cinematic'), true)
    RageUI.SetStyleAudio("RageUI")


    Citizen.CreateThread(function()
        while InCinematicMenu do
            Wait(1)
            RageUI.IsVisible(RMenu:Get('core', 'cinematic'), false, false, false, function()
                RageUI.ButtonWithStyle("Join the army", nil, {}, true, function(_, _, s)
                    if s then
                        TriggerEvent("xsound:stateSound", "destroy", {soundId = "cinematic",})
                        DoScreenFadeOut(100)
                        while not IsScreenFadedOut() do Wait(1) end
                        TriggerEvent("xsound:stateSound", "play", {
                            soundId = "cinematic", 
                            url = "https://www.youtube.com/watch?v=TnogrK1Sn-A&", 
                            volume = 0.5, 
                            loop = true
                        })

                        LoadModel("s_m_y_blackops_02")
                        SetPlayerModel(GetPlayerIndex(), GetHashKey("s_m_y_blackops_02"))
                        player.ped = GetPlayerPed(-1)
                        SetPedRandomProps(player.ped)

                        DoScreenFadeIn(1500)
                        InCinematic = false
                        SetEntityCoords(player.ped, -2337.62, 3263.19, 32.83, 0.0, 0.0, 0.0, 0)
                        SetEntityHeading(player.ped, 240.6)

                        SetCamCoord(cam, -2328.69, 3257.94, 32.83)
                        SetCamFov(cam, 15.0)
                        PointCamAtEntity(cam, player.ped, 0, 0, 0, 0)
                    end
                end, RMenu:Get('core', 'army_choose'))
                RageUI.ButtonWithStyle("Join the resistance", nil, {}, true, function(_, _, s)
                    if s then

                    end
                end)
            end, function()
            end)

            RageUI.IsVisible(RMenu:Get('core', 'army_choose'), false, false, false, function()
                for k,v in pairs(armypeds) do
                    RageUI.ButtonWithStyle(v.label, nil, {}, true, function(_, _, s)
                        if s then
                            LoadModel(v.model)
                            SetPlayerModel(GetPlayerIndex(), GetHashKey(v.model))
                            player.ped = GetPlayerPed(-1)
                            SetPedRandomProps(player.ped)
                        end
                    end)
                end
            end, function()
            end)
        end
    end)
end