local entityEnumerator = {
	__gc = function(enum)
		if enum.destructor and enum.handle then
			enum.destructor(enum.handle)
		end

		enum.destructor = nil
		enum.handle = nil
	end
}

local function EnumerateEntities(initFunc, moveFunc, disposeFunc)
	return coroutine.wrap(function()
		local iter, id = initFunc()
		if not id or id == 0 then
			disposeFunc(iter)
			return
		end

		local enum = {handle = iter, destructor = disposeFunc}
		setmetatable(enum, entityEnumerator)
		local next = true

		repeat
			coroutine.yield(id)
			next, id = moveFunc(iter)
		until not next

		enum.destructor, enum.handle = nil, nil
		disposeFunc(iter)
	end)
end

function EnumerateEntitiesWithinDistance(entities, isPlayerEntities, coords, maxDistance)
	local nearbyEntities = {}

	if coords then
		coords = vector3(coords.x, coords.y, coords.z)
	else
		local playerPed = PlayerPedId()
		coords = GetEntityCoords(playerPed)
	end

	for k,entity in pairs(entities) do
		local distance = #(coords - GetEntityCoords(entity))

		if distance <= maxDistance then
			table.insert(nearbyEntities, isPlayerEntities and k or entity)
		end
	end

	return nearbyEntities
end

function EnumerateObjects()
	return EnumerateEntities(FindFirstObject, FindNextObject, EndFindObject)
end

function EnumeratePeds()
	return EnumerateEntities(FindFirstPed, FindNextPed, EndFindPed)
end

function EnumerateVehicles()
	return EnumerateEntities(FindFirstVehicle, FindNextVehicle, EndFindVehicle)
end

function EnumeratePickups()
	return EnumerateEntities(FindFirstPickup, FindNextPickup, EndFindPickup)
end

local blips = {}
local EntCache = {}
Citizen.CreateThread(function()
	while player == nil do Wait(100) end
	while true do
		local particles = {}
		local NearHeli = false
		RequestNamedPtfxAsset("scr_trevor3")
		while not HasNamedPtfxAssetLoaded("scr_trevor3") do
			Wait(1)
		end

		RequestNamedPtfxAsset("scr_agencyheistb")
		while not HasNamedPtfxAssetLoaded("scr_agencyheistb") do
			Wait(1)
		end

		
		for v in EnumerateVehicles() do

			if GetEntityHealth(v) < 100 then
				local co = GetEntityCoords(v)

				UseParticleFxAssetNextCall("scr_trevor3")
				local particle = StartParticleFxLoopedAtCoord("scr_trev3_trailer_plume", co.x, co.y, co.z+0.4, 1.0, 1.0, 100.0, 0.7, false, false)
				table.insert(particles, particle)

				UseParticleFxAssetNextCall("scr_agencyheistb")
				local particle = StartParticleFxLoopedAtCoord("scr_env_agency3b_smoke", co.x, co.y, co.z+0.4, 1.0, 1.0, 100.0, 0.7, false, false)
				table.insert(particles, particle)
			end

			if GetEntityModel(v) == GetHashKey("buzzard2") then
				local ped = GetPedInVehicleSeat(v, -1)
				if player.camp == "army" then
					if GetEntityModel(ped) == GetHashKey("s_m_y_marine_03") then
						local dst = GetDistanceBetweenCoords(GetEntityCoords(v), player.coords, false)
						if dst < 150 then
							NearHeli = true
						end
					end
				elseif player.camp == "resistance" then
					if GetEntityModel(ped) == GetHashKey("s_m_y_blackops_01") then
						local dst = GetDistanceBetweenCoords(GetEntityCoords(v), player.coords, false)
						if dst < 150 then
							NearHeli = true
						end
					end
				end
			end
		end

		for k,v in pairs(blips) do
			RemoveBlip(v)
		end

		if player.camp == "army" then
			for v in EnumeratePeds() do

				if v ~= GetPlayerPed(-1) then
					if GetEntityModel(v) == GetHashKey("s_m_y_marine_03") then
						local blip = AddBlipForEntity(v)
						SetBlipScale(blip, 0.65)
						SetBlipColour(blip, 67)
						if GetEntityHealth(v) < 30 then
							SetBlipSprite(blip, 353)
						end
						table.insert(blips, blip)
						SetPedRelationshipGroupHash(v, 'army')
					elseif GetEntityModel(v) == GetHashKey("s_m_y_blackops_01") and NearHeli then
						local blip = AddBlipForEntity(v)
						SetBlipScale(blip, 0.65)
						SetBlipColour(blip, 1)
						table.insert(blips, blip)
					end
				end

				local xp = 0
				if IsPedDeadOrDying(v, 1) then
					if v ~= player.ped then
						if GetPedSourceOfDeath(v) == player.ped then
							if EntCache[v] == nil then
								TriggerServerEvent("DeleteEntity", {PedToNet(v)})
								xp = xp + 100
								EntCache[v] = true
							end
						end
					end
				end
				if xp > 0 then
					XNL_AddPlayerXP(xp, "NPC KILL")
				end
			end
		elseif player.camp == "resistance" then
			for v in EnumeratePeds() do

				if v ~= GetPlayerPed(-1) then
					if GetEntityModel(v) == GetHashKey("s_m_y_blackops_01") then
						local blip = AddBlipForEntity(v)
						SetBlipScale(blip, 0.65)
						SetBlipColour(blip, 67)
						if GetEntityHealth(v) < 30 then
							SetBlipSprite(blip, 353)
						end
						table.insert(blips, blip)
						SetPedRelationshipGroupHash(v, 'resistance')
					elseif GetEntityModel(v) == GetHashKey("s_m_y_marine_03") and NearHeli then
						local blip = AddBlipForEntity(v)
						SetBlipScale(blip, 0.65)
						SetBlipColour(blip, 1)
						table.insert(blips, blip)
					end
				end

				local xp = 0
				if IsPedDeadOrDying(v, 1) then
					if v ~= player.ped then
						if GetPedSourceOfDeath(v) == player.ped then
							if EntCache[v] == nil then
								TriggerServerEvent("DeleteEntity", {PedToNet(v)})
								xp = xp + 100
								EntCache[v] = true
							end
						end
					end
				end
				if xp > 0 then
					XNL_AddPlayerXP(xp, "NPC KILL")
				end
			end
		end


		for v in EnumerateVehicles() do

		end

		Wait(500)
		for k,v in pairs(particles) do
			StopParticleFxLooped(v)
			
			table.remove(particles, k)
		end
	end
end)