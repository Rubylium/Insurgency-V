


local ResistanceWeapons = {
    "weapon_assaultrifle",
    "weapon_pistol",
    "weapon_rpg"
}

function JoinResistance()
    DisplayRadar(true)
    RenderScriptCams(0, 0, 0, 0, 0)
    player.camp = "resistance"
    for k,v in pairs(ResistanceWeapons) do
        if v ~= "weapon_rpg" then
            GiveWeaponToPed(player.ped, GetHashKey(v), 255, 0, 1)
        else
            GiveWeaponToPed(player.ped, GetHashKey(v), 1, 0, 1)
        end
    end
end