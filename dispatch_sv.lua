QBCore = exports['qb-core']:GetCoreObject()

function isAuth(job)
    for i = 1, #Config["AuthorizedJobs"] do
        if job == Config["AuthorizedJobs"][i] then
            return true
        end
    end
    return false
end

function isAuthEMS(job)
    for i = 1, #Config["EMSJob"] do
        if job == Config["EMSJob"][i] then
            return true
        end
    end
    return false
end

RegisterServerEvent("deniz-dispatch:svNotify", function(data)
    for idx, id in pairs(QBCore.Functions.GetPlayers()) do
        local xPlayer = QBCore.Functions.GetPlayer(id)
        if isAuth(xPlayer.PlayerData.job.name) then
            TriggerClientEvent('deniz-dispatch:clNotify', xPlayer.PlayerData.source, data)
        end
    end 
end)

-- dispatch events

RegisterServerEvent("deniz-dispatch:createblip", function(coords, bliptype, both)
    for idx, id in pairs(QBCore.Functions.GetPlayers()) do
        local xPlayer = QBCore.Functions.GetPlayer(id)
        if not both then
            if isAuth(xPlayer.PlayerData.job.name) then
                TriggerClientEvent("deniz-dispatch:createBlip", xPlayer.PlayerData.source, bliptype, coords)
            end
        else
            if isAuth(xPlayer.PlayerData.job.name) or isAuthEMS(xPlayer.PlayerData.job.name) then
                TriggerClientEvent("deniz-dispatch:createBlip", xPlayer.PlayerData.source, bliptype, coords)
            end
        end
    end
end)
