

function LoadModel(model)
    local model = GetHashKey(model)
    RequestModel(model)
    while not HasModelLoaded(model) do Wait(0) end
end


function ShowHelpNotification(msg, thisFrame)
	AddTextEntry('HelpNotif', msg)
	DisplayHelpTextThisFrame('HelpNotif', false)
end


function SpawnVeh(model, color)
    LoadModel(model)
    local veh = CreateVehicle(GetHashKey(model), player.coords, GetEntityHeading(player.ped), 1, 0)
    SetVehicleColours(veh, color, color)
    TaskWarpPedIntoVehicle(player.ped, veh, -1)
    
end

function ShowPopupWarning(msg)
	SetNotificationTextEntry('STRING')
	AddTextComponentString(msg)
	DrawNotification(0,1)
end

function requestScaleformMovie(movie)
	local scaleform = RequestScaleformMovie(movie)

	while not HasScaleformMovieLoaded(scaleform) do
		Citizen.Wait(0)
	end

	return scaleform
end


GetVehicles = function()
	local vehicles = {}

	for vehicle in EnumerateVehicles() do
		table.insert(vehicles, vehicle)
	end

	return vehicles
end

GetClosestVehicle = function()
	local vehicles        = GetVehicles()
	local closestDistance = -1
	local closestVehicle  = -1
	local coords          = player.coords

	for i=1, #vehicles, 1 do
		local vehicleCoords = GetEntityCoords(vehicles[i])
		local distance      = GetDistanceBetweenCoords(vehicleCoords, coords.x, coords.y, coords.z, true)

		if closestDistance == -1 or closestDistance > distance then
			closestVehicle  = vehicles[i]
			closestDistance = distance
		end
	end

	return closestVehicle, closestDistance
end

GetClosestPlayer = function()
	local players = GetActivePlayers()
	local coords = GetEntityCoords(pPed)
	local pCloset = nil
	local pClosetPos = nil
	local pClosetDst = nil
	for k,v in pairs(players) do
		if GetPlayerPed(v) ~= pPed then
			local oPed = GetPlayerPed(v)
			local oCoords = GetEntityCoords(oPed)
			local dst = GetDistanceBetweenCoords(oCoords, coords, true)
			if pCloset == nil then
				pCloset = v
				pClosetPos = oCoords
				pClosetDst = dst
			else
				if dst < pClosetDst then
					pCloset = v
					pClosetPos = oCoords
					pClosetDst = dst
				end
			end
		end
	end

	return pCloset, pClosetDst
end

--=============================================================================
-->  Made by Super.Cool.Ninja
-->  help @RAMEX_DELTA_GTA for maths to get the km some thing like 1.20..km and not 10042km.
-->  help @Dislaik for remind me to use \n and not two same function. yeah some time my mind is broken ):

--> this is why i love open source. sometimes.
--=============================================================================


local function DrawText3DMarker(x,y,z,text)
    local onScreen,_x,_y=World3dToScreen2d(x,y,z)
    
    if onScreen then
        SetTextScale(0.3 + 0.03, 0.3 + 0.03)
        SetTextFont(0)
        SetTextProportional(1)
        SetTextColour(255, 255, 255, 255)
        SetTextDropshadow(0, 0, 0, 0, 55)
        SetTextEdge(2, 0, 0, 0, 150)
        SetTextDropShadow()
        SetTextOutline()
        SetTextEntry("STRING")
        SetTextCentre(1)
        AddTextComponentString(text)
        DrawText(_x,_y)
    end
end

local function round(num, idp)
    if idp and idp>0 then
        local mult = 10^idp
        return math.floor(num * mult + 0.5) / mult
    end
    return math.floor(num + 0.5)
end

--> No need native to check the distance with this :
local square = math.sqrt
local function getDistance(a, b) 
    local x, y, z = a.x-b.x, a.y-b.y, a.z-b.z
    return square(x*x+y*y+z*z)
end

Citizen.CreateThread(function()
    while true do
        local waypoint = GetFirstBlipInfoId(8)
        if DoesBlipExist(waypoint) then
            local myPos = GetEntityCoords(GetPlayerPed(-1))
            local coord = Citizen.InvokeNative(0xFA7C7F0AADF25D09, waypoint, Citizen.ResultAsVector())
            local distance = getDistance(myPos, coord)
            
            if distance > 999 then
                roundOverKm = round(distance)  * math.pow(10, -3)
                DrawText3DMarker(coord.x, coord.y, myPos.z, 'V\n' .. roundOverKm.. " kilometres")
            elseif distance > 0.1 and distance <= 999 then
                DrawText3DMarker(coord.x, coord.y, myPos.z, 'V\n' .. round(distance).. " m")
            end
        end
        Citizen.Wait(0)
    end
end)