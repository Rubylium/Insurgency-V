



function InitWatermark()
    Citizen.CreateThread(function()
        while true do
            Wait(1)


            SetTextColour(191, 191, 191, 150)

            SetTextFont(2)
            SetTextScale(0.4, 0.4)
            SetTextWrap(0.0, 1.0)
            SetTextCentre(false)
            SetTextDropshadow(2, 2, 0, 0, 0)
            SetTextEdge(1, 0, 0, 0, 205)
            SetTextEntry("STRING")
            AddTextComponentString("Insurgency V - DEV 0.0.1")
            DrawText(0.005, 0.001)
        end
    end)
end