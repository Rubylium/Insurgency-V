Limit = 0
local vehsZone = {
    {
        pos = vector3(2925.28, 4641.83, 48.54),
        vehs = {
            {model = "bodhi2", point = 300,},
            {model = "dune3", point = 400,},
            {model = "nightshark", point = 1000,},
            {model = "technical", point = 600,},
            {model = "buzzard2", point = 2000,},
            {model = "bf400", point = 0,},
        },
        color = 49,
    },
    {
        pos = vector3(195.66, 2708.7, 42.3),
        vehs = {
            {model = "insurgent3", point = 500,},
            {model = "barracks3", point = 200,},
            {model = "crusader", point = 150,},
            {model = "halftrack", point = 500,},
            {model = "buzzard2", point = 2000,},
            {model = "barrage", point = 200,},
            {model = "blazer4", point = 0,},
        },
        color = 153,
    },
}

local InsideMenu = false
function InitVehsZone()
    while player.coords == nil do Wait(100) end


    Citizen.CreateThread(function()
        while true do
            local veh, dst = GetClosestVehicle()
            if dst < 4.0 then
                DisableControlAction(1, 23, true)
                if not IsPedInAnyVehicle(player.ped, false) then
                    if IsDisabledControlJustReleased(1, 23) then
                        print("Pressed to enter veh")
                        local place = GetVehicleModelNumberOfSeats(GetEntityModel(veh))
                        for i = -1,place do
                            if IsVehicleSeatFree(veh, i) then
                                print("Seat ~b~"..i.."~s~ free, entering now.")
                                TaskWarpPedIntoVehicle(player.ped, veh, i)
                                Wait(500)
                                break
                            end
                        end
                    end
                else
                    if IsDisabledControlJustPressed(1, 23) then
                        print("Pressed to leave veh")
                        TaskLeaveVehicle(GetPlayerPed(-1), GetVehiclePedIsIn(GetPlayerPed(-1), false), 16)
                        Wait(500)
                    end

                    if IsDisabledControlJustReleased(1, 175) then
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
                            OpenVehMenu(v.vehs, v.color)
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

    function OpenVehMenu(vehs, color)
        InsideMenu = true
        RageUI.Visible(RMenu:Get('core', 'vehs'), true)
        Citizen.CreateThread(function()
            while InsideMenu do
                Wait(1)
                RageUI.IsVisible(RMenu:Get('core', 'vehs'), false, false, false, function()
                    if player.camp == "army" then
                        RageUI.Separator("Army: ~b~"..points.army)
                    else
                        RageUI.Separator("Resistance: ~b~"..points.army)
                    end
                    for k,v in pairs(vehs) do
                        if player.camp == "army" then
                            RageUI.ButtonWithStyle("Spawn an "..v.model, "~b~"..v.point.." team points needed.", {}, v.point <= points.army, function(_, _, s)
                                if s then
                                    if Limit < 2 then
                                        Limit = Limit + 1
                                        SpawnVeh(v.model, color)
                                    else
                                        ShowPopupWarning("You already have too many vehicle out.")
                                    end
                                end
                            end)
                        else
                            RageUI.ButtonWithStyle("Spawn an "..v.model, "~b~"..v.point.." team points needed.", {}, v.point <= points.resitance, function(_, _, s)
                                if s then
                                    if Limit < 2 then
                                        Limit = Limit + 1
                                        SpawnVeh(v.model, color)
                                    else
                                        ShowPopupWarning("You already have too many vehicle out.")
                                    end
                                end
                            end)
                        end
                    end


                end, function()
                end)
            end
        end)
    end
end