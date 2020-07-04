


local ResistanceWeapons = {
    "weapon_assaultrifle",
    "weapon_pistol",
}

function JoinResistance()
    player.camp = "resistance"
    for k,v in pairs(ResistanceWeapons) do
        GiveWeaponToPed(player.ped, GetHashKey(v), 255, 0, 1)
    end
end