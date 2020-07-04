Citizen.CreateThread(function()
    while not NetworkIsSessionActive() do Wait(1) end

    
    InitWatermark()
    initCinematic()
end)



function initCinematic()
    SetNuiFocus(true, true)
    TriggerEvent("xsound:stateSound", "cinematic", "https://www.youtube.com/watch?v=Jme5hYgXbNY&list=PL953Es57AbWdc4oqOC5HWLWGD7Xvk1qYd&index=1", 0.2, true)



    -- Display menu
end