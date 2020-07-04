

local weapons = {
    {weap = "weapon_pistol", multi = 1.3},
    {weap = "weapon_pistol_mk2", multi = 1.3},
    {weap = "weapon_combatpdw", multi = 1.2},
    {weap = "weapon_assaultrifle", multi = 1.5},
    {weap = "weapon_carbinerifle", multi = 1.3},
    {weap = "weapon_rpg", multi = 50.0},
}


function InitWeaponsDamage()
    for k,v in pairs(weapons) do
        SetWeaponDamageModifier(GetHashKey(v?weap), v.multi)
    end
end