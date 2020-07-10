--AddRelationshipGroup('resistance')
--AddRelationshipGroup('army')
--
--SetRelationshipBetweenGroups(5, 'resistance', 'army')
--SetRelationshipBetweenGroups(5, 'army', 'resistance')
--
--
--function JoinArmyTeam()
--    SetPedRelationshipGroupHash(PlayerPedId(), 'army')
--end
--
--
--function JoinResistanceTeam()
--    SetPedRelationshipGroupHash(PlayerPedId(), 'resistance')
--end

local teamkill = 0
RegisterNetEvent("V:TeamKill")
AddEventHandler("V:TeamKill", function()
    SetAudioFlag("LoadMPData", true)
    teamkill = teamkill + 1
    PlaySoundFrontend(-1, "CHECKPOINT_MISSED", "HUD_MINI_GAME_SOUNDSET", 1)
    ShowPopupWarning("~r~TEAMKILL!\n~s~Teamkill is not allowed and will result as a perma ban if abused.")
    if teamkill >= 1 then
        SetEntityHealth(GetPlayerPed(-1), 0)
    end
end)


RegisterNetEvent("V:Kill")
AddEventHandler("V:Kill", function()
    SetAudioFlag("LoadMPData", true)
    PlaySoundFrontend(-1, "DELETE", "HUD_DEATHMATCH_SOUNDSET", 1)
    PlaySoundFrontend(-1, "DELETE", "HUD_DEATHMATCH_SOUNDSET", 1)
    PlaySoundFrontend(-1, "DELETE", "HUD_DEATHMATCH_SOUNDSET", 1)
    XNL_AddPlayerXP(1000, "PLAYER KILL")
end)