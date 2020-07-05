
local vehsZone = {
    {
        pos = vector3(2925.28, 4641.83, 48.54),
        vehs = {
            "bodhi2",
            "dune3",
            "nightshark",
            "technical",
            "buzzard2",
        },
    },
    {
        pos = vector3(-2333.72, 3257.47, 32.83),
        vehs = {
            "insurgent3",
            "apc",
            "barracks3",
            "crusader",
            "halftrack",
            "buzzard2",
        },
    },
}

local InsideMenu = false
function InitVehsZone()
    while player.coords == nil do Wait(100) end
    Citizen.CreateThread(function()
        while true do
            local IsCloseTo = false
            if not InsideMenu then
                for k,v in pairs(vehsZone) do
                    if #(player.coords - v.pos) < 10.0 then
                        IsCloseTo = true
                        ShowHelpNotification("Appuyer sur ~INPUT_PICKUP~ pour ouvrir le menu de véhicule")
                        if IsControlJustReleased(0, 38) then
                            OpenVehMenu(v.vehs)
                        end
                    end
                end
            end 

            if IsCloseTo then
                Wait(1)
            else
                Wait(300)
            end
        end
    end)


    RMenu.Add('core', 'vehs', RageUI.CreateMenu("Insurgency V", "~b~Choose your side ..."))
    RMenu:Get('core', 'vehs').Closed = function()
        InsideMenu = false
    end;

    function OpenVehMenu(vehs)
        InsideMenu = true
        RageUI.Visible(RMenu:Get('core', 'vehs'), true)
        Citizen.CreateThread(function()
            while InsideMenu do
                Wait(1)
                RageUI.IsVisible(RMenu:Get('core', 'vehs'), false, false, false, function()
                    for k,v in pairs(vehs) do
                        RageUI.ButtonWithStyle("Spawn an "..v, nil, {}, true, function(_, _, s)
                            if s then
                                SpawnVeh(v)
                            end
                        end)
                    end


                end, function()
                end)
            end
        end)
    end
end