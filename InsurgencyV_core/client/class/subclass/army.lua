armypeds = {
    {label = "Marine 3", model = "s_m_y_marine_03"},
}


local ArmyWeapons = {
    "weapon_combatpdw",
    "weapon_pistol_mk2",
    "weapon_flaregun",
    "weapon_grenade",
    "weapon_carbinerifle",
}

function JoinArmy(music)
    DisplayRadar(true)
    RenderScriptCams(0, 0, 0, 0, 0)
    player.camp = "army"
    for k,v in pairs(ArmyWeapons) do
        GiveWeaponToPed(player.ped, GetHashKey(v), 255, 0, 1)
    end

    if music then
        --TriggerEvent("xsound:stateSound", "play", {
        --    soundId = "starting_game", 
        --    url = "https://www.youtube.com/watch?v=BawTAoOldBU", 
        --    volume = 0.2, 
        --    loop = false
        --})
        TriggerServerEvent("V:JoinArmy")
    end
    inGame = true
    SetEntityInvincible(player.ped, false)
    JoinArmyTeam()
end