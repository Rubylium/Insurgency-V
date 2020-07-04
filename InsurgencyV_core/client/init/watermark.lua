



function InitWatermark()
    Citizen.CreateThread(function()
        while true do
            Wait(1)
            SetTextColour(191, 191, 191, 190)

            SetTextFont(4)
            SetTextScale(0.4, 0.4)
            SetTextWrap(0.0, 1.0)
            SetTextCentre(false)
            SetTextDropshadow(2, 2, 0, 0, 0)
            SetTextEdge(1, 0, 0, 0, 205)
            SetTextEntry("STRING")
            AddTextComponentString("Insurgency V - DEV 0.0.1")
            DrawText(0.455, 0.970)
        end
    end)
end
