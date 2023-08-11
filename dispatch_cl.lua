QBCore = exports['qb-core']:GetCoreObject()

function GetStreetAndZone()
    local playerPed = PlayerPedId()
    local coords = GetEntityCoords(playerPed)
    local currentStreetHash, intersectStreetHash = GetStreetNameAtCoord(coords.x, coords.y, coords.z)
    local currentStreetName = GetStreetNameFromHashKey(currentStreetHash)
    local area = GetLabelText(tostring(GetNameOfZone(coords.x, coords.y, coords.z)))
    local playerStreetsLocation = area
    if not zone then zone = "UNKNOWN" end
    if currentStreetName ~= nil and currentStreetName ~= "" then playerStreetsLocation = currentStreetName .. ", " ..area
    else playerStreetsLocation = area end
    return playerStreetsLocation
end

RegisterNetEvent("deniz-dispatch:createBlip", function(type, coords)
    if type == "urgent" then
        local alpha = 150
        local Blip = AddBlipForCoord(coords)
        SetBlipSprite(Blip, 153)
        SetBlipColour(Blip, 76)
        SetBlipScale(Blip, 1.0)
        SetBlipAsShortRange(Blip, true)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString('Acil Yaralı Memur')
        EndTextCommandSetBlipName(Blip)
        while alpha ~= 0 do
            Citizen.Wait(120 * 4)
            alpha = alpha - 1
            SetBlipAlpha(Blip, alpha)
            if alpha == 0 then
                RemoveBlip(Blip)
                return
            end
        end
    elseif type == "gunshot" then
        local alpha = 250
        local Blip = AddBlipForRadius(coords, 75.0)
        SetBlipColour(Blip, 1)
        SetBlipAsShortRange(Blip, true)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString('Ateş İhbarı')
        EndTextCommandSetBlipName(Blip)
        while alpha ~= 0 do
            Citizen.Wait(120 * 4)
            alpha = alpha - 1
            SetBlipAlpha(Blip, alpha)
            if alpha == 0 then
                RemoveBlip(Blip)
                return
            end
        end
    end
end)

RegisterNetEvent("deniz-dispatch:gunshot", function()
    local playerPed = PlayerPedId()
    local currentPos = GetEntityCoords(playerPed)
    local gender = IsPedMale(playerPed)
    TriggerServerEvent('deniz-dispatch:svNotify', {
        update = "newCall",
        code = '11-71',
        event = 'Ateş İhbarı',
        location = GetStreetAndZone(),
        time = 5000,
        type = 'normal',
        coords = currentPos
    })
    TriggerServerEvent("deniz-dispatch:createblip", currentPos, 'gunshot', false)
end)

RegisterNetEvent("deniz-dispatch:racing", function()
    local playerPed = PlayerPedId()
    local currentPos = GetEntityCoords(playerPed)
    local gender = IsPedMale(playerPed)
    TriggerServerEvent('deniz-dispatch:svNotify', {
        update = "newCall",
        code = '11-71',
        event = 'İllegal Yarış',
        location = GetStreetAndZone(),
        time = 5000,
        type = 'normal',
        coords = currentPos
    })
end)

RegisterNetEvent("deniz-dispatch:urgent", function()
    local playerPed = PlayerPedId()
    local currentPos = GetEntityCoords(playerPed)
    local gender = IsPedMale(playerPed)
    TriggerServerEvent('deniz-dispatch:svNotify', {
        update = "newCall",
        code = '10-13A',
        event = 'Acil Yaralı Memur ('..QBCore.Functions.GetPlayerData().charinfo.firstname..' '..QBCore.Functions.GetPlayerData().charinfo.lastname..')',
        location = GetStreetAndZone(),
        time = 8000,
        type = 'urgent',
        coords = currentPos
    })
    TriggerServerEvent("deniz-dispatch:createblip", currentPos, 'urgent', true)
end)

RegisterNetEvent("deniz-dispatch:clNotify", function(data, id)
PlaySound(-1, "Lose_1st", "GTAO_FM_Events_Soundset", 0, 0, 1)
    SendNUIMessage({
        update = "newCall",
        code = data.code,
        event = data.event,
        location = data.location,
        time = data.time,
        type = data.type
    })
    koordinatamk = data.coords
    isaretlenebilir = true
    Citizen.Wait(data.time + 100)
    isaretlenebilir = false
end)

RegisterKeyMapping('+dispatchyonel', 'Waypoint Last Dispatch', 'keyboard', 'E') 

RegisterCommand('+dispatchyonel', function()
    if isaretlenebilir then
        SetNewWaypoint(koordinatamk.x, koordinatamk.y)
        -- isaretlenebilir = false
        QBCore.Functions.Notify("Dispatch marked!")
    end
end)

-- local avcilik = CircleZone:Create(vector3(-620.315, 5329.011, 68.679), 320.0, {
-- 	name="avcilik",
-- 	debugPoly=false,
-- })

RegisterCommand('gtest', function(source, args)
    if args[1] == '1' then
        TriggerEvent('deniz-dispatch:gunshot')
    elseif args[1] == '2' then
        TriggerEvent('deniz-dispatch:urgent')
    elseif args[1] == '3' then
        TriggerEvent('deniz-dispatch:racing')
    end
end)

Citizen.CreateThread(function()
    local cooldown = 0
    local isBusy = false
	while true do
		Citizen.Wait(0)
        local playerPed = PlayerPedId()
		local coords = GetEntityCoords(playerPed)
		avcilikicinde = false
        if not avcilikicinde then
            if IsPedShooting(playerPed) and (cooldown == 0 or cooldown - GetGameTimer() < 0) and not isBusy then
                if QBCore.Functions.GetPlayerData().job.name == "police" or QBCore.Functions.GetPlayerData().job.name == "statepolice" or QBCore.Functions.GetPlayerData().job.name == "sheriff" or QBCore.Functions.GetPlayerData().job.name == "ranger" then
                    isBusy = false
                    -- cooldown = GetGameTimer() + math.random(6000, 10000)
                    -- TriggerEvent("deniz-dispatch:gunshot")
                else
            isBusy = true
            if IsPedCurrentWeaponSilenced(playerPed) then
                cooldown = GetGameTimer() + math.random(25000, 30000)
                TriggerEvent("deniz-dispatch:gunshot")
            else
                cooldown = GetGameTimer() + math.random(6000, 10000)
                TriggerEvent("deniz-dispatch:gunshot")
            end
            isBusy = false
        end
    end
end
    end
end)
