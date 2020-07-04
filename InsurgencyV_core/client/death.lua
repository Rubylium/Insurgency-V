
exports.spawnmanager:setAutoSpawn(false)
function InitDeathHandler()

    Citizen.CreateThread(function()
        while player.health == nil do Wait(1) end
        local count = 0

        while true do
            local isDead = false
            exports.spawnmanager:setAutoSpawn(false)

            if IsEntityDead(GetPlayerPed(-1)) then
                isDead = true
                count = count + 1
            end


            if isDead then
                print(count)
                if count > 1000 then
                    --ShowHelpNotification("Press ~INPUT_PICKUP~ to respawn")
                    RageUI.Text({message = "Press ~b~[E]~s~ to respawn"})
                    if IsControlJustReleased(1, 38) then
                        count = 0
                        Respawn()
                    end
                else
                    --ShowHelpNotification("You are dead, you have to wait befor respawn...")
                    RageUI.Text({message = "You are dead, you have to wait befor respawn..."})
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
            JoinArmy()
            DoScreenFadeIn(2500)
        else
            DoScreenFadeOut(2500)
            while not IsScreenFadedOut() do Wait(1) end
            SetEntityCoords(player.ped, 2930.63, 4623.93, 47.72, 0.0, 0.0, 0.0, 0)
            SetEntityHeading(player.ped, 35.92)
            NetworkResurrectLocalPlayer(2930.63, 4623.93, 47.72, 35.92, 0, 0)
            JoinResistance()
            DoScreenFadeIn(2500)
        end
    end
end