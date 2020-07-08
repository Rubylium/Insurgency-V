



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
            AddTextComponentString("Insurgency V - DEV 0.0.7 - "..players.." players online.")
            DrawText(0.420, 0.970)

            if inGame then

                -- Debug idk where i should add that 
                

                SetTextColour(255, 255, 255, 190)

                SetTextFont(4)
                SetTextScale(0.4, 0.4)
                SetTextWrap(0.0, 1.0)
                SetTextCentre(false)
                SetTextDropshadow(2, 2, 0, 0, 0)
                SetTextEdge(1, 0, 0, 0, 205)
                SetTextEntry("STRING")
                AddTextComponentString("Army: "..points.army.." - Resistance: "..points.resitance)
                DrawText(0.155, 0.950)
            end
        end
    end)
end
