Limit = 0
local vehsZone = {
    {
        pos = vector3(2925.28, 4641.83, 48.54),
        vehs = {
            {model = "bodhi2", point = 300,},
            {model = "dune3", point = 400,},
            {model = "nightshark", point = 1000,},
            {model = "technical", point = 600,},
            {model = "buzzard", point = 1000,},
            {model = "bf400", point = 0,},
            {model = "lav25ifv", point = 0,}, -- Transport + munition explosive
            {model = "m1128s", point = 0,}, -- Semi tank
            {model = "m142as", point = 0,}, -- Anti aérien
            {model = "mrap", point = 0,}, -- Blindé tourelle
            {model = "unarmed1", point = 0,},
            {model = "uparmorw", point = 0,},
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
            {model = "buzzard", point = 1000,},
            {model = "barrage", point = 200,},
            {model = "blazer4", point = 0,},
            {model = "abrams", point = 500,}, -- tank
            {model = "brad", point = 0,}, -- Petit véhicule munition explosive
            {model = "bspec", point = 0,}, -- jeep de transport
            {model = "hasrad", point = 1500,}, -- Anti aérien
            {model = "hmvs", point = 0,}, -- Transport jeep tourelle

            {model = "unarmed2", point = 0,},
            {model = "uparmor", point = 0,},
            
        },
        color = 153,
    },
}

local InsideMenu = false
function InitVehsZone()
    Citizen.CreateThread(function()
        while player == nil do Wait(1) end
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
                        if not NetworkGetEntityIsNetworked(GetVehiclePedIsIn(GetPlayerPed(-1), false)) then
                            Wait(1500)
                            print(NetworkGetEntityIsNetworked(GetVehiclePedIsIn(GetPlayerPed(-1), false)))
                            if not NetworkGetEntityIsNetworked(GetVehiclePedIsIn(GetPlayerPed(-1), false)) then
                                DeleteEntity(GetVehiclePedIsIn(GetPlayerPed(-1), false))
                            end
                        end

                       SetPlayerVehicleDamageModifier(GetPlayerIndex(), 10.0)
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
                if inGame then
                    if not InsideMenu then
                        for k,v in pairs(vehsZone) do
                            if #(player.coords - v.pos) < 20.0 then
                                IsCloseTo = true
                                ShowHelpNotification("Press ~INPUT_PICKUP~ to open vehicle spawn menu")
                                if IsControlJustReleased(0, 38) then
                                    OpenVehMenu(v.vehs, v.color)
                                end
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

        RMenu.Add('core', 'class_choose', RageUI.CreateSubMenu(RMenu:Get('core', 'vehs'), "Army", "~b~Choose your class ..."))
        RMenu:Get('core', 'class_choose').Closed = function()

        end;

        function OpenVehMenu(vehs, color)
            InsideMenu = true
            RageUI.Visible(RMenu:Get('core', 'vehs'), true)
            Citizen.CreateThread(function()
                while InsideMenu do
                    Wait(1)

                    RageUI.IsVisible(RMenu:Get('core', 'class_choose'), false, false, false, function()
                        if player.camp == "resistance" then
                            for k,v in pairs(ResistanceClass) do
                                RageUI.ButtonWithStyle(k, nil, {RightLabel = "~b~"..classe.resistance[k].."/"..v.limite}, classe.resistance[k] < v.limite, function(_, h, s)
                                    if s then
                                        RemoveAllPedWeapons(GetPlayerPed(-1), 1)
                                        for _,i in pairs(v.weapons) do
                                            GiveWeaponToPed(GetPlayerPed(-1), GetHashKey(i.name), i.ammo, 0, 1)
                                        end
                                        player.class = k
                                        TriggerServerEvent("V:JoinClass", player.camp, player.class)
                                    end
                                    if h then
                                        if tempClass ~= k then
                                            RemoveAllPedWeapons(GetPlayerPed(-1), 1)
                                            for _,i in pairs(v.weapons) do
                                                GiveWeaponToPed(GetPlayerPed(-1), GetHashKey(i.name), i.ammo, 0, 1)
                                            end
                                            tempClass = k
                                        end
                                    end
                                end)
                           end
                        else
                            for k,v in pairs(ArmyClass) do
                                RageUI.ButtonWithStyle(k, nil, {RightLabel = "~b~"..classe.army[k].."/"..v.limite}, classe.army[k] < v.limite, function(_, h, s)
                                    if s then
                                        RemoveAllPedWeapons(GetPlayerPed(-1), 1)
                                        for _,i in pairs(v.weapons) do
                                            GiveWeaponToPed(GetPlayerPed(-1), GetHashKey(i.name), i.ammo, 0, 1)
                                        end
                                        player.class = k
                                        TriggerServerEvent("V:JoinClass", player.camp, player.class)
                                    end
                                    if h then
                                        if tempClass ~= k then
                                            RemoveAllPedWeapons(GetPlayerPed(-1), 1)
                                            for _,i in pairs(v.weapons) do
                                                GiveWeaponToPed(GetPlayerPed(-1), GetHashKey(i.name), i.ammo, 0, 1)
                                            end
                                            tempClass = k
                                        end
                                    end
                                end)
                            end
                        end
                    end, function()
                    end)

                    RageUI.IsVisible(RMenu:Get('core', 'vehs'), false, false, false, function()
                        if player.camp == "army" then
                            RageUI.Separator("Army: ~b~"..points.army)
                        else
                            RageUI.Separator("Resistance: ~b~"..points.army)
                        end
                        RageUI.ButtonWithStyle("Change your class", nil, {}, true, function(_, _, s)

                        end, RMenu:Get('core', 'class_choose'))
                        for k,v in pairs(vehs) do
                            if player.camp == "army" then
                                RageUI.ButtonWithStyle("Spawn an "..v.model, "~b~"..v.point.." team points needed.", {}, v.point <= points.army, function(_, _, s)
                                    if s then
                                        --if Limit < 2 then
                                        if not IsPedInAnyVehicle(GetPlayerPed(-1), false) then
                                            Limit = Limit + 1
                                            SpawnVeh(v.model, color)
                                            RageUI.CloseAll()
                                        end
                                        --else
                                        --    ShowPopupWarning("You already have too many vehicle out.")
                                        --end
                                    end
                                end)
                            else
                                RageUI.ButtonWithStyle("Spawn an "..v.model, "~b~"..v.point.." team points needed.", {}, v.point <= points.resitance, function(_, _, s)
                                    if s then
                                        --if Limit < 2 then
                                        if not IsPedInAnyVehicle(GetPlayerPed(-1), false) then
                                            Limit = Limit + 1
                                            SpawnVeh(v.model, color)
                                            RageUI.CloseAll()
                                        end
                                        --else
                                        --    ShowPopupWarning("You already have too many vehicle out.")
                                        --end
                                    end
                                end)
                            end
                        end


                    end, function()
                    end)
                end
            end)
        end
    end)
end