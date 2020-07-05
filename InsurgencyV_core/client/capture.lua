

RegisterNetEvent("V:ZoneCaptured")
AddEventHandler("V:ZoneCaptured", function(label, team)
    SetAudioFlag("LoadMPData", true)
    PlaySoundFrontend(-1, "ASSASSINATIONS_HOTEL_TIMER_COUNTDOWN", "ASSASSINATION_MULTI", 1)
    ShowPopupWarning("Zone captured!", "The ~b~"..team.."~s~ has captured ~b~"..label.."~s~ zone.")
end)