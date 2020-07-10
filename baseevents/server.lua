RegisterServerEvent('baseevents:onPlayerDied')
RegisterServerEvent('baseevents:onPlayerKilled')
RegisterServerEvent('baseevents:onPlayerWasted')
RegisterServerEvent('baseevents:enteringVehicle')
RegisterServerEvent('baseevents:enteringAborted')
RegisterServerEvent('baseevents:enteredVehicle')
RegisterServerEvent('baseevents:leftVehicle')



local KillCache = {}
AddEventHandler('baseevents:onPlayerKilled', function(killedBy, data)
	local victim = source

	RconLog({msgType = 'playerKilled', victim = victim, attacker = killedBy, data = data})

	local killerM = GetEntityModel(GetPlayerPed(killedBy))
	local victimM = GetEntityModel(GetPlayerPed(victim))
	print(killedBy, killerM, victimM)
	if killerM == victimM then
		TriggerClientEvent("V:TeamKill", tonumber(killedBy))
	else
		TriggerClientEvent("V:Kill", killedBy)
	end
	

	if killedBy == -1 then
		TriggerClientEvent("V:GetKillFeed", -1, GetPlayerName(victim).." died")
	else
		if KillCache[killedBy] == nil then
			KillCache[killedBy] = 1
		else
			KillCache[killedBy] = KillCache[killedBy] + 1
		end
		TriggerClientEvent("V:GetKillFeed", -1, "["..KillCache[killedBy].."] "..GetPlayerName(killedBy).." killed "..GetPlayerName(victim))
	end
end)

AddEventHandler('baseevents:onPlayerDied', function(killedBy, pos)
	local victim = source

	RconLog({msgType = 'playerDied', victim = victim, attackerType = killedBy, pos = pos})
	TriggerClientEvent("V:GetKillFeed", -1, GetPlayerName(victim).." died")
end)