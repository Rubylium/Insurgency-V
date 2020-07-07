

RegisterNetEvent("V:GetKillFeed")
AddEventHandler("V:GetKillFeed", function(text)
    TriggerEvent('chat:addMessage', {
        color = { 255, 0, 0},
        multiline = true,
        args = {"Insurgency V", text}
      })
      XNL_AddPlayerXP(100)
end)