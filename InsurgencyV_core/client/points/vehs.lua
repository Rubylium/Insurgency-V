
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
            local veh, dst = GetClosestVehicle()
            if dst < 4.0 then
                if not IsPedInAnyVehicle(player.ped, false) then
                    if IsControlJustPressed(1, 23) then
                        print("Pressed to enter veh")
                        local place = GetVehicleModelNumberOfSeats(GetEntityModel(veh))
                        for i = -1,place do
                            if IsVehicleSeatFree(veh, i) then
                                print("Seat ~b~"..i.."~s~ free, entering now.")
                                TaskWarpPedIntoVehicle(player.ped, veh, i)
                                break
                            end
                        end
                    end
                else
                    if IsControlJustPressed(1, 23) then
                        print("Pressed to leave veh")
                        TaskLeaveVehicle(player.ped, veh, 16)
                    end

                    if IsControlJustPressed(1, 175) then
                        print("Pressed to change seat")
                        local place = GetVehicleModelNumberOfSeats(GetEntityModel(veh))
                        local seat
                        for i = -1,place do
                            if GetPedInVehicleSeat(veh, i) == player.ped then
                                seat = i
                            end
                        end

                        if seat ~= nil then 
                            local tryingSeat = seat + 1
                            local try = 0
                            while try <= place do
                                try = try + 1
                                if IsVehicleSeatFree(veh, tryingSeat) then
                                    TaskWarpPedIntoVehicle(player.ped, veh, tryingSeat)
                                    break
                                else
                                    tryingSeat = tryingSeat + 1
                                    if tryingSeat > place then
                                        tryingSeat = -1
                                    end
                                end
                            end
                        end
                    end
                end
                Wait(1)
            else
                Wait(50)
            end
        end
    end)


    Citizen.CreateThread(function()
        while true do
            local IsCloseTo = false
            if not InsideMenu then
                for k,v in pairs(vehsZone) do
                    if #(player.coords - v.pos) < 10.0 then
                        IsCloseTo = true
                        ShowHelpNotification("Press ~INPUT_PICKUP~ to open vehicle spawn menu")
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


    RMenu.Add('core', 'vehs', RageUI.CreateMenu("Insurgency V", "~b~Choose your vehicle ..."))
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