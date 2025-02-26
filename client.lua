local QBCore = exports['qb-core']:GetCoreObject()

local cikarmasuresi = false
local menuacikmi = false

RegisterCommand("f1ackardesim", function()
    local ped = PlayerPedId()

    SendNUIMessage({ action = "show" })
    SetNuiFocus(true, true)
    menuacikmi = true
end, false)

RegisterNUICallback("spawnCar", function(data, cb)
    local ped = PlayerPedId()

    if cikarmasuresi then
        QBCore.Functions.Notify("Araç çıkarmak için bekle!", "inform", 4500)
        return
    end

    if IsPedInAnyVehicle(ped, false) then
        QBCore.Functions.Notify("Araç içindeyken çıkartamazsın!", "error", 4500)
        return
    end

    local vehicleName = data.vehicle
    if not vehicleName then return end

    RequestModel(vehicleName)
    while not HasModelLoaded(vehicleName) do
        Wait(500)
    end

    local playerCoords = GetEntityCoords(ped)
    local spawnedCar = CreateVehicle(vehicleName, playerCoords.x + 2, playerCoords.y, playerCoords.z, GetEntityHeading(ped), true, false)

    TaskWarpPedIntoVehicle(ped, spawnedCar, -1)

    SetModelAsNoLongerNeeded(vehicleName)

    cikarmasuresi = true
    Citizen.SetTimeout(Config.spawncooldown * 1000, function()
        cikarmasuresi = false
    end)

    cb("success")
end)

RegisterNUICallback("closeMenu", function()
    SetNuiFocus(false, false)
    menuacikmi = false
end)

RegisterKeyMapping("f1ackardesim", "Araç Çıkarma menüsü (F1)", "keyboard", "F1")
