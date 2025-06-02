ESX = exports['es_extended']:getSharedObject()

CreateThread(function ()
    while GetResourceState("lb-phone") ~= "started" do
        Wait(500)
    end

    while ESX.GetPlayerData().job == nil do
		Citizen.Wait(10)
	end

    ESX.PlayerData = ESX.GetPlayerData()
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
	ESX.PlayerData = xPlayer
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
	ESX.PlayerData.job = job
end)

RegisterNUICallback("saveData", function(data, cb)
    print("Received Data: ", json.encode(data))
    cb("ok")
end)

-- This event is needed for `OnSettingsChange` to work
RegisterNetEvent("lb-phone:settingsUpdated", function(settings)
    SendNUIMessage({
        type = "settingsUpdated",
        settings = settings
    })
end)

RegisterNUICallback("promoteplayer", function(data, cb)
    print("Received Data: ", json.encode(data))
    cb("ok")
end)


RegisterNUICallback("apploaded", function(data, callback)
    ESX.TriggerServerCallback("factionapp:getActivePlayer", function(FrakData, MOTD) 
        local count, isBoss = 0, false
        for k, v in pairs(FrakData) do
            count = count + 1 
        end

        if ESX.PlayerData.job.grade_name == "boss" then isBoss = true end

        local sortedData = {}
        for _, data in pairs(FrakData) do
            table.insert(sortedData, data)
        end

        table.sort(sortedData, function(a, b)
            return a.grade > b.grade
        end)

        callback({
            data = sortedData,
            job = ESX.PlayerData.job.label,
            count = count,
            motd = MOTD,
            isBoss = isBoss
        })

    end)
end)

RegisterNUICallback("messageplayer", function(data, cb)
    local src = tonumber(data.playerId)
    TriggerServerEvent('factionapp:SendPing', src)
    cb("ok")
end)

RegisterNUICallback("callplayer", function(data, cb)
    local src = tonumber(data.playerId)
    TriggerServerEvent('factionapp:callplayerjob', src)
    cb("ok")
end)

RegisterNUICallback("createmotd", function(data, cb)
    TriggerServerEvent("factionapp:changemotd", data.message)
    cb("ok")
end)

RegisterNUICallback("handleplayer", function(data, cb)
    local src = tonumber(data.playerId)
    TriggerServerEvent("factionapp:handleplayerjob", data.type, src)
    cb("ok")
end)