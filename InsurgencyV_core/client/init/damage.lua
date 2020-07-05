

local weapons = {
    {weap = "weapon_pistol", multi = 1.7},
    {weap = "weapon_pistol_mk2", multi = 1.7},
    {weap = "weapon_combatpdw", multi = 1.8},
    {weap = "weapon_assaultrifle", multi = 2.6},
    {weap = "weapon_carbinerifle", multi = 2.3},
    {weap = "weapon_rpg", multi = 50.0},
}


function InitWeaponsDamage()
    for k,v in pairs(weapons) do
        SetWeaponDamageModifier(GetHashKey(v.weap), v.multi)
    end
end