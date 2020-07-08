


local ResistanceWeapons = {
    "weapon_pistol_mk2",
    "weapon_rpg",
    "weapon_stickybomb",
    "weapon_assaultrifle",
}

ResistanceClass = {
    ["Rifleman"] = {
        limite = 1000,
        weapons = {
            {name = "weapon_pistol_mk2", ammo = 255},
            {name = "weapon_flaregun", ammo = 255},
            {name = "weapon_assaultrifle", ammo = 255},
        },
    },
    ["Engineer"] = {
        limite = 2,
        weapons = {
            {name = "weapon_rpg", ammo = 2},
            {name = "weapon_pistol_mk2", ammo = 255},
            {name = "weapon_flaregun", ammo = 255},
            {name = "weapon_stickybomb", ammo = 255},
            {name = "weapon_proxmine", ammo = 255},
            {name = "weapon_compactrifle", ammo = 255},
        },
    },
    ["Recon"] = {
        limite = 1,
        weapons = {
            {name = "weapon_pistol_mk2", ammo = 255},
            {name = "weapon_flaregun", ammo = 255},
            {name = "weapon_sniperrifle", ammo = 255},
        },
    },
    ["Medic"] = {
        limite = 10,
        weapons = {
            {name = "weapon_assaultsmg", ammo = 255},
            {name = "weapon_appistol", ammo = 255},
            {name = "weapon_flaregun", ammo = 255},
        },
    },
}  

function JoinResistance(music)
    SetCamActive(cam, false)
    DisplayRadar(true)
    RenderScriptCams(0, 0, 0, 0, 0)
    player.camp = "resistance"

    if music then
        --TriggerEvent("xsound:stateSound", "play", {
        --    soundId = "starting_game", 
        --    url = "https://www.youtube.com/watch?v=BawTAoOldBU", 
        --    volume = 0.2, 
        --    loop = false
        --})
        TriggerServerEvent("V:JoinClass", player.camp, player.class)
        TriggerServerEvent("V:JoinResistance")
    end

    if player.class ~= nil then
        RemoveAllPedWeapons(GetPlayerPed(-1), 1)
        for _,i in pairs(ResistanceClass[player.class].weapons) do
            GiveWeaponToPed(player.ped, GetHashKey(i.name), i.ammo, 0, 1)
        end
    end

    inGame = true
    SetEntityInvincible(player.ped, false)
    JoinResistanceTeam()
end