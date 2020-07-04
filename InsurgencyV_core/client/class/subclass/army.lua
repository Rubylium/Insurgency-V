armypeds = {
    {label = "Blackops 1", model = "s_m_y_blackops_01"},
    {label = "Blackops 2", model = "s_m_y_blackops_02"},
    {label = "Blackops 3", model = "s_m_y_blackops_03"},
    {label = "Marine 1", model = "s_m_m_marine_01"},
    {label = "Marine 2", model = "s_m_y_marine_01"},
    {label = "Marine 3", model = "s_m_y_marine_03"},
}


local ArmyWeapons = {
    "weapon_carbinerifle",
    "weapon_combatpdw",
    "weapon_pistol_mk2",
    "weapon_flaregun",
}

function JoinArmy()
    player.camp = "army",
    for k,v in pairs(ArmyWeapons) do
        GiveWeaponToPed(player.ped, GetHashKey(v), 255, 0, 1)
    end
end