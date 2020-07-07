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


Citizen.CreateThread(function()
	while true do
		local particles = {}
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
				print('Adding particle for veh '..v)
				UseParticleFxAssetNextCall("scr_trevor3")
				local particle = StartParticleFxLoopedAtCoord("scr_trev3_trailer_plume", co.x, co.y, co.z+0.4, 1.0, 1.0, 100.0, 0.7, false, false)
				UseParticleFxAssetNextCall("scr_agencyheistb")
				local particle = StartParticleFxLoopedAtCoord("scr_env_agency3b_smoke", co.x, co.y, co.z+0.4, 1.0, 1.0, 100.0, 0.7, false, false)
				table.insert(particles, particle)
			end
		end

		for v in EnumeratePeds() do
			if v ~= GetPlayerPed(-1) then
				if not IsPedAPlayer(v) then
					SetEntityHealth(v, 0)
					SetPedToRagdoll(v, 10000, 10000, 2, 0, 0, 0)
				end
			end
		end

		Wait(1500)
		for k,v in pairs(particles) do
			StopParticleFxLooped(v)
			table.remove(particles, k)
		end
	end
end)