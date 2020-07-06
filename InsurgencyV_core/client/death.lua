
exports.spawnmanager:setAutoSpawn(false)
function InitDeathHandler()
    local isDead = false
    local deathCam = nil
    local offset = {0.0, -4.0, 4.0}

    Citizen.CreateThread(function()
        while player.health == nil do Wait(1) end
        local count = 0

        while true do
            
            exports.spawnmanager:setAutoSpawn(false)

            if IsEntityDead(GetPlayerPed(-1)) then
                if not isDead then
                    isDead = true
                    local clonePed = ClonePed(player.ped, GetEntityHeading(player.ped), 1, 0)
                    SetEntityHealth(clonePed, 0)
                    SetEntityVisible(player.ped, 0, 0)
                    deathCam = CreateCam("DEFAULT_SCRIPTED_CAMERA", 1)
                    RenderScriptCams(1, 0, 0, 0, 0)
                    offset = {2.0, 2.0, 2.0}
                    local coords = GetOffsetFromEntityInWorldCoords(player.ped, offset[1], offset[2], offset[3])
                    SetCamCoord(deathCam, coords)
                    PointCamAtCoord(deathCam, GetEntityCoords(GetPlayerPed(-1)))
                    SetCamFov(deathCam, 50.0)
                    ShakeCam(deathCam, "HAND_SHAKE", 0.2)
                    StartAudioScene("MP_LOBBY_SCENE")
                end
                count = count + 1
            end


            if isDead then
                SetEntityVisible(player.ped, 0, 0)
                if count > 1000 then
                    count = 0
                    Respawn()
                else
                    RageUI.Text({message = "You are dead, you have to wait befor respawn..."})
                    offset[2] = offset[2] + 0.01
                    offset[3] = offset[3] + 0.03
                    local coords = GetOffsetFromEntityInWorldCoords(player.ped, offset[1], offset[2], offset[3])
                    SetCamCoord(deathCam, coords)
                    PointCamAtCoord(deathCam, GetEntityCoords(GetPlayerPed(-1)))
                end
                Wait(1)
            else
                Wait(50)
            end
        end
    end)


    function Respawn()
        if player.camp == "army" then
            DoScreenFadeOut(2500)
            while not IsScreenFadedOut() do Wait(1) end
            SetEntityCoords(player.ped, -2337.62, 3263.19, 31.83, 0.0, 0.0, 0.0, 0)
            SetEntityHeading(player.ped, 240.6)
            NetworkResurrectLocalPlayer(-2337.62, 3263.19, 31.83, 240.6, 0, 0)
            JoinArmy(false)
            DoScreenFadeIn(2500)
            isDead = false
            SetEntityVisible(player.ped, 1, 1)
            RenderScriptCams(0, 0, 0, 0, 0)
        else
            DoScreenFadeOut(2500)
            while not IsScreenFadedOut() do Wait(1) end
            SetEntityCoords(player.ped, 2930.63, 4623.93, 47.72, 0.0, 0.0, 0.0, 0)
            SetEntityHeading(player.ped, 35.92)
            NetworkResurrectLocalPlayer(2930.63, 4623.93, 47.72, 35.92, 0, 0)
            JoinResistance(false)
            DoScreenFadeIn(2500)
            isDead = false
            SetEntityVisible(player.ped, 1, 1)
            RenderScriptCams(0, 0, 0, 0, 0)
        end
        Limit = 0
        StopAudioScenes()
    end
end