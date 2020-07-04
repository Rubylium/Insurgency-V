


local ResistanceWeapons = {
    "weapon_assaultrifle",
    "weapon_pistol",
}

function JoinResistance()
    player.camp = "ResistanceWeapons"
    for k,v in pairs(ArmyWeapons) do
        GiveWeaponToPed(player.ped, GetHashKey(v), 255, 0, 1)
    end
end