armypeds = {
    {label = "Marine 3", model = "s_m_y_marine_03"},
}


ArmyClass = {
    ["Rifleman"] = {
        limite = 1000,
        weapons = {
            {name = "weapon_pistol_mk2", ammo = 255},
            {name = "weapon_flaregun", ammo = 255},
            {name = "weapon_carbinerifle", ammo = 255},
            {name = "gadget_parachute", ammo = 255},
        },
    },
    ["Engineer"] = {
        limite = 2,
        weapons = {
            {name = "weapon_hominglauncher", ammo = 2},
            {name = "weapon_pistol_mk2", ammo = 255},
            {name = "weapon_flaregun", ammo = 255},
            {name = "weapon_stickybomb", ammo = 255},
            {name = "weapon_proxmine", ammo = 255},
            {name = "weapon_combatpdw", ammo = 255},
            {name = "gadget_parachute", ammo = 255},
        },
    },
    ["Recon"] = {
        limite = 1,
        weapons = {
            {name = "weapon_pistol_mk2", ammo = 255},
            {name = "weapon_flaregun", ammo = 255},
            {name = "weapon_sniperrifle", ammo = 255},
            {name = "gadget_parachute", ammo = 255},
        },
    },
    ["Medic"] = {
        limite = 10,
        weapons = {
            {name = "weapon_assaultsmg", ammo = 255},
            {name = "weapon_appistol", ammo = 255},
            {name = "weapon_flaregun", ammo = 255},
            {name = "gadget_parachute", ammo = 255},
        },
    },
}  

function JoinArmy(music)
    
    SetCamActive(cam, false)
    DestroyCam(cam, 0)
    DestroyCam(cam, 1)
    DisplayRadar(true)
    SetPlayerParachuteTintIndex(GetPlayerIndex(), 9)

    player.camp = "army"

    if music then
        inGame = false
        TriggerEvent("xsound:stateSound", "play", {
            soundId = "starting_game", 
            url = "https://www.youtube.com/watch?v=dgwNvhHJRrg", 
            volume = 0.08, 
            loop = false
        })
        RenderScriptCams(0, 0, 0, 0, 0)
        TriggerServerEvent("V:JoinArmy")
        TriggerServerEvent("V:JoinClass", player.camp, player.class)


        Citizen.CreateThread(function()
            LoadModel("cargobob")
            local veh = CreateVehicle(GetHashKey("cargobob"), 262.3, 2634.1, 220.0, 100.0, 0, 1)
            local ped = CreatePedInsideVehicle(veh, 1, GetHashKey("s_m_y_marine_03"), -1, 0, 1)
            SetVehicleColours(veh, 0, 0)
            SetVehicleLivery(veh, 0)
            FreezeEntityPosition(veh, true)
            SetVehicleCurrentRpm(veh, 10000.0)
            SetVehicleEngineOn(veh, true, true, false)
            TaskWarpPedIntoVehicle(GetPlayerPed(-1), veh, 2)
            Wait(1000)
            DoScreenFadeIn(3500)
            while not IsScreenFadedIn() do Wait(100) end
            TaskLeaveVehicle(GetPlayerPed(-1), veh, 256)
            Wait(2*1000)
            Citizen.CreateThread(function()
                local count = 0
                while count < 1000 do
                    count = count + 1
                    DrawMarker(1, 182.16, 2708.5, 41.29, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 1.0, 500.0, 0, 255, 0, 255, 0, 1, 2, 0, nil, nil, 0)
                    Wait(1)
                end
            end)
            TaskParachuteToTarget(GetPlayerPed(-1), 182.16, 2708.5, 41.29)
            Wait(8*1000)
            inGame = true
            FreezeEntityPosition(veh, false)
            TaskVehicleDriveToCoord(ped, veh, 262.3 - 600, 2634.1 + 150 , 220.0 + 35, 150.0, 0, GetHashKey("cargobob"), 1074528293, 3, 0)
            Wait(20*1000)
            DeleteEntity(veh)
            DeleteEntity(ped)
             
        end)
    end

    if player.class ~= nil then
        RemoveAllPedWeapons(GetPlayerPed(-1), 1)
        for _,i in pairs(ArmyClass[player.class].weapons) do
            GiveWeaponToPed(player.ped, GetHashKey(i.name), i.ammo, 0, 1)
        end
    end

    inGame = true
    SetEntityInvincible(player.ped, false)
    --JoinArmyTeam()
end