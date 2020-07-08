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
    teamkill = teamkill + 1
    PlaySoundFrontend(-1, "CHECKPOINT_MISSED", "HUD_MINI_GAME_SOUNDSET", 1)
    ShowPopupWarning("~r~TEAMKILL!\n~s~Teamkill is not allowed and will result as a perma ban if abused.")
    if teamkill > 2 then
        SetEntityHealth(GetPlayerPed(-1), 0)
    end
end)
