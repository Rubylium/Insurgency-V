


local ResistanceWeapons = {
    "weapon_assaultrifle",
    "weapon_pistol",
    "weapon_rpg"
}

function JoinResistance(music)
    DisplayRadar(true)
    RenderScriptCams(0, 0, 0, 0, 0)
    player.camp = "resistance"
    for k,v in pairs(ResistanceWeapons) do
        if v ~= "weapon_rpg" then
            GiveWeaponToPed(player.ped, GetHashKey(v), 255, 0, 1)
        else
            GiveWeaponToPed(player.ped, GetHashKey(v), 5, 0, 1)
        end
    end

    if music then
        --TriggerEvent("xsound:stateSound", "play", {
        --    soundId = "starting_game", 
        --    url = "https://www.youtube.com/watch?v=BawTAoOldBU", 
        --    volume = 0.2, 
        --    loop = false
        --})
        TriggerServerEvent("V:JoinResistance")
    end
    inGame = true
    SetEntityInvincible(player.ped, false)
end