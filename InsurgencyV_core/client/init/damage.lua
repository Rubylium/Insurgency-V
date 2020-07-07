

local weapons = {
    {weap = "weapon_pistol", multi = 0.1},
    {weap = "weapon_pistol_mk2", multi = 5.0},
    {weap = "weapon_combatpdw", multi = 13.4},
    {weap = "weapon_assaultrifle", multi = 15.0},
    {weap = "weapon_carbinerifle", multi = 15.0},
    {weap = "weapon_rpg", multi = 50.0},
    {weap = "weapon_stickybomb", multi = 20.0},
}


function InitWeaponsDamage()
    for k,v in pairs(weapons) do
        SetWeaponDamageModifier(GetHashKey(v.weap), v.multi)
    end
end