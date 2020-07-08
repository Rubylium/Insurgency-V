Citizen.CreateThread(function()
    while not NetworkIsSessionActive() do Wait(1) end


    -- spawn the player
    local ped = PlayerPedId()
    -- V requires setting coords as well
    SetEntityCoordsNoOffset(ped, 182.16, 2708.5, 41.29, false, false, false, true)
    NetworkResurrectLocalPlayer(182.16, 2708.5, 41.29, 100.0, true, true, false)
    -- gamelogic-style cleanup stuff
    ClearPedTasksImmediately(ped)
    --SetEntityHealth(ped, 300) -- TODO: allow configuration of this?
    RemoveAllPedWeapons(ped) -- TODO: make configurable (V behavior?)
    ClearPlayerWantedLevel(PlayerId())

    InitPlayerClass()
    InitWatermark()
    InitWeaponsDamage()
    InitVehsZone()
    InitDeathHandler()
    initCinematic()

    ClearOverrideWeather()
    ClearWeatherTypePersist()
    SetWeatherTypePersist("EXTRASUNNY")
    SetWeatherTypeNow("EXTRASUNNY")
    SetWeatherTypeNowPersist("EXTRASUNNY")
    NetworkOverrideClockTime(8, 12, 0)
    exports.spawnmanager:forceRespawn()
    NetworkSetTalkerProximity(15.0)
end)

local cam = nil
local InCinematic = false

local lockedControls = {24,25,69,70}
local cams = {
    {pos = vector3(729.41, 2528.05, 86.65), lookAt = vector3(1084.22, 2711.88, 44.7)},
    {pos = vector3(-2357.99, 3242.93, 93.6), lookAt = vector3(-1889.62, 2982.23, 48.01)},
    {pos = vector3(258.3376, 2665.6, 48.59), lookAt = vector3(188.1, 2717.0, 41.5)},
    {pos = vector3(1711.5, 3625.1, 45.2), lookAt = vector3(1794.6, 3716.0, 33.35)},
}


local loadingScreenMusic = {
    "https://www.youtube.com/watch?v=GGYw-anK2BM",
    "https://www.youtube.com/watch?v=Jme5hYgXbNY&list=PL953Es57AbWdc4oqOC5HWLWGD7Xvk1qYd&index=1",
    "https://www.youtube.com/watch?v=WjqmdZWHLtc",
}

function initCinematic()
    DisplayRadar(false)
    DoScreenFadeOut(100)
    while not IsScreenFadedOut() do Wait(1) end
    -- Display menu
    InCinematicMenu = true

    function DoCinematic()
        if not InCinematicMenu then return end
        InCinematic = true

        cam = CreateCam("DEFAULT_SCRIPTED_CAMERA", 1)
        RenderScriptCams(1, 0, 0, 0, 0)

        Citizen.CreateThread(function()
            TriggerEvent("xsound:stateSound", "play", {
                soundId = "cinematic", 
                url = loadingScreenMusic[math.random(1,#loadingScreenMusic)], 
                volume = 0.5, 
                loop = true
            })
            DoScreenFadeIn(2500)
            while InCinematic do
                SetPlayerInvincible(GetPlayerIndex(), true)
                NetworkResurrectLocalPlayer(182.16, 2708.5, 41.29, 100.0, true, true, false)

                
                DoScreenFadeIn(2500)
                local r = cams[math.random(1,#cams)]
                SetCamCoord(cam, r.pos)
                PointCamAtCoord(cam, r.lookAt)
                SetCamFov(cam, 50.0)
                SetFocusArea(r.pos, 0.0, 0.0, 0.0)
                ShakeCam(cam, "HAND_SHAKE", 0.2)
                local count_ = 0
                while count_ < 1000 do
                    count_ = count_ + 1
                    Wait(0)
                end
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

    RMenu.Add('core', 'resistance_choose', RageUI.CreateSubMenu(RMenu:Get('core', 'cinematic'), "Army", "~b~Choose your ped ..."))
    RMenu:Get('core', 'resistance_choose').Closed = function()
        TriggerEvent("xsound:stateSound", "destroy", {soundId = "cinematic",})
        DoCinematic()
    end;


    RageUI.Visible(RMenu:Get('core', 'cinematic'), true)
    RageUI.SetStyleAudio("RageUI")


    function OpenCinematicMenu()
        local tempClass = nil
        player.class = "None."
        Citizen.CreateThread(function()
            while InCinematicMenu do
                Wait(1)

                for k,v in pairs(lockedControls) do
                    DisableControlAction(0, v, true)
                end
                SetEntityInvincible(player.ped, true)

                RageUI.IsVisible(RMenu:Get('core', 'cinematic'), false, false, false, function()
                    RageUI.ButtonWithStyle("Join the army", nil, {RightLabel = "~b~"..army.."/"..players}, army <= resitance, function(_, _, s)
                        if s then
                            DoScreenFadeOut(100)
                            while not IsScreenFadedOut() do Wait(1) end

                            LoadModel("s_m_y_marine_03")
                            SetPlayerModel(GetPlayerIndex(), GetHashKey("s_m_y_marine_03"))
                            player.ped = GetPlayerPed(-1)
                            SetPedRandomProps(player.ped)

                            DoScreenFadeIn(1500)
                            InCinematic = false
                            SetEntityCoords(player.ped, 182.16, 2708.5, 41.29, 0.0, 0.0, 0.0, 0)
                            SetEntityHeading(player.ped, 278.6)
                            SetFocusArea(182.16, 2708.5, 41.29, 0.0, 0.0, 0.0)

                            SetCamCoord(cam, 194.24, 2709.49, 42.3)
                            SetCamFov(cam, 15.0)
                            PointCamAtEntity(cam, player.ped, 0, 0, 0, 0)
                            SetPlayerInvincible(GetPlayerIndex(), false)
                        end
                    end, RMenu:Get('core', 'army_choose'))
                    RageUI.ButtonWithStyle("Join the resistance", nil, {RightLabel = "~b~"..resitance.."/"..players}, resitance <= army, function(_, _, s)
                        if s then
                            DoScreenFadeOut(100)
                            while not IsScreenFadedOut() do Wait(1) end

                            LoadModel("s_m_y_blackops_01")
                            SetPlayerModel(GetPlayerIndex(), GetHashKey("s_m_y_blackops_01"))
                            player.ped = GetPlayerPed(-1)
                            SetPedRandomProps(player.ped)
                            GiveWeaponToPed(player.ped, GetHashKey("weapon_assaultrifle"), 255, 0, true)

                            DoScreenFadeIn(1500)
                            InCinematic = false
                            SetEntityCoords(player.ped, 2930.63, 4623.93, 47.72, 0.0, 0.0, 0.0, 0)
                            SetEntityHeading(player.ped, 35.92)
                            SetFocusArea(2930.63, 4623.93, 47.72, 0.0, 0.0, 0.0)

                            SetCamCoord(cam, 2925.28, 4632.62, 48.55)
                            SetCamFov(cam, 15.0)
                            PointCamAtEntity(cam, player.ped, 0, 0, 0, 0)
                            SetPlayerInvincible(GetPlayerIndex(), false)
                        end
                    end, RMenu:Get('core', 'resistance_choose'))
                end, function()
                end)

                RageUI.IsVisible(RMenu:Get('core', 'resistance_choose'), false, false, false, function()
                    RageUI.Separator("Class selected: ~b~"..player.class)
                    for k,v in pairs(ResistanceClass) do
                        RageUI.ButtonWithStyle(k, nil, {}, true, function(_, h, s)
                            if s then
                                RemoveAllPedWeapons(GetPlayerPed(-1), 1)
                                for _,i in pairs(v.weapons) do
                                    GiveWeaponToPed(GetPlayerPed(-1), GetHashKey(i.name), i.ammo, 0, 1)
                                end
                                player.class = k
                            end
                            if h then
                                if tempClass ~= k then
                                    RemoveAllPedWeapons(GetPlayerPed(-1), 1)
                                    for _,i in pairs(v.weapons) do
                                        GiveWeaponToPed(GetPlayerPed(-1), GetHashKey(i.name), i.ammo, 0, 1)
                                    end
                                    tempClass = k
                                end
                            end
                        end)
                   end

                    RageUI.ButtonWithStyle("~g~Join the game.", nil, {}, true, function(_, _, s)
                        if s then
                            TriggerEvent("xsound:stateSound", "destroy", {soundId = "cinematic",})
                            DoScreenFadeOut(100)
                            while not IsScreenFadedOut() do Wait(1) end
                            RenderScriptCams(0, 0, 0, 0, 0)
                            DoScreenFadeIn(2500)
                            ClearFocus()
                            InCinematicMenu = false
                            JoinResistance(true)
                        end
                    end)
                end, function()
                end)

                RageUI.IsVisible(RMenu:Get('core', 'army_choose'), false, false, false, function()
                    RageUI.Separator("Class selected: ~b~"..player.class)
                    for k,v in pairs(ArmyClass) do
                        RageUI.ButtonWithStyle(k, nil, {}, true, function(_, h, s)
                            if s then
                                RemoveAllPedWeapons(GetPlayerPed(-1), 1)
                                for _,i in pairs(v.weapons) do
                                    GiveWeaponToPed(GetPlayerPed(-1), GetHashKey(i.name), i.ammo, 0, 1)
                                end
                                player.class = k
                            end
                            if h then
                                if tempClass ~= k then
                                    RemoveAllPedWeapons(GetPlayerPed(-1), 1)
                                    for _,i in pairs(v.weapons) do
                                        GiveWeaponToPed(GetPlayerPed(-1), GetHashKey(i.name), i.ammo, 0, 1)
                                    end
                                    tempClass = k
                                end
                            end
                        end)
                    end

                    RageUI.ButtonWithStyle("~g~Join the game.", nil, {}, true, function(_, _, s)
                        if s then
                            TriggerEvent("xsound:stateSound", "destroy", {soundId = "cinematic",})
                            DoScreenFadeOut(100)
                            while not IsScreenFadedOut() do Wait(1) end
                            RenderScriptCams(0, 0, 0, 0, 0)
                            DoScreenFadeIn(2500)
                            ClearFocus()
                            InCinematicMenu = false
                            JoinArmy(true)
                        end
                    end)
                end, function()
                end)
            end
        end)
    end
    OpenCinematicMenu()
end