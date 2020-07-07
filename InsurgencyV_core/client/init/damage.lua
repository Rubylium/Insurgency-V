

local weapons = {
    {weap = "weapon_pistol", multi = 2.0},
    {weap = "weapon_pistol_mk2", multi = 2.0},
    {weap = "weapon_combatpdw", multi = 2.4},
    {weap = "weapon_assaultrifle", multi = 3.4},
    {weap = "weapon_carbinerifle", multi = 3.4},
    {weap = "weapon_rpg", multi = 50.0},
    {weap = "weapon_stickybomb", multi = 20.0},
}


function InitWeaponsDamage()
    for k,v in pairs(weapons) do
        SetWeaponDamageModifier(GetHashKey(v.weap), v.multi)
    end
end