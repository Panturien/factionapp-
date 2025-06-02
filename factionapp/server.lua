ESX = exports['es_extended']:getSharedObject()
local FrakData = {}
local MOTD = {}
local blockedStrings = {
    'bastard',
    'fotze',
    'pic',
    'pimmel',
    'muschi',
    'schwanz',
    'titten',
    'mustermann',
    'nix',
    'negro',
    'nuttensohn',
    'modder',
    'eulen',
    'cheats',
    'nuttensohn',
    'nutte',
    'oruspu',
    'ghetto',
    'lass',
    'miglo',
    'hamza',
    'bubu',
    'stuf',
    'ananni',
    'sikim',
    'lümmel',
    'nazi',
    'gaskammer',
    'Siegheil',
    'nigger',
    'hurensohn',
    'hitler',
    'pimp',
    'benz',
    '<',
    '>',
}

Citizen.CreateThread(function()
    MySQL.Async.fetchAll('SELECT name, motd FROM jobs', {}, function(result)
        for i=1, #result, 1 do
            if type(json.decode(result[i].motd)) == "table" then
                MOTD[result[i].name] = json.decode(result[i].motd)
            else
                MOTD[result[i].name] = {
                    message = "Kein MOTD verfasst"
                }
            end
        end

        -- print(json.encode(MOTD))
    end)
end)

Citizen.CreateThread(function()
    local xPlayers = ESX.GetPlayers()
    for k, v in pairs(xPlayers) do

        local xPlayer = ESX.GetPlayerFromId(v)
        
		if FrakData[xPlayer.job.name] == nil then
			FrakData[xPlayer.job.name] = {}
		end
		
        FrakData[xPlayer.job.name][xPlayer.source] = {
            name = xPlayer.name,
            label = xPlayer.job.grade_label,
            grade = xPlayer.job.grade,
            number = exports["lb-phone"]:GetEquippedPhoneNumber(xPlayer.source),
            source = xPlayer.source
        }
    end
end)

ESX.RegisterServerCallback("factionapp:getActivePlayer", function(source, cb)
    local xPlayer = ESX.GetPlayerFromId(source)
    if xPlayer == nil then return end
    cb(FrakData[xPlayer.job.name], MOTD[xPlayer.job.name])
end)

local spamProtection = {}

RegisterNetEvent('factionapp:SendPing', function(target)
    if target == nil then return end
    if source == target then return end
    if spamProtection[source] == nil then spamProtection[source] = 0 end
    if os.time() - spamProtection[source] < 5 and spamProtection[source] ~= nil then 
        TriggerClientEvent("notifyneu", source, "Handy", 'Bitte warte einen Moment!', 5000)
        return
    end
    spamProtection[source] = os.time()
    local xPlayer = ESX.GetPlayerFromId(source)
    local name = xPlayer.rpName
    local number = exports["lb-phone"]:GetEquippedPhoneNumber(target)
    local myNumber = exports["lb-phone"]:GetEquippedPhoneNumber(source)
    -- Messages
    -- TriggerClientEvent("notifyneu", source, "Handy", 'Du hast eine Nachricht versendet. Öffne die Nachrichtenapp.', 5000)
    exports["lb-phone"]:SendNotification(source, {
        app = "Messages", -- the app to send the notification to (optional)
        title = "Nachrichten", -- the title of the notification
        content = "Du hast eine Nachricht versendet", -- the description of the notification
        icon = "https://r2.fivemanage.com/ex4mvo1Zbd7Pz1u5F5qKp/images/orga.png", -- the icon of the notification (optional)
    }, function(res) -- res can be false, true or the notification id
        
    end)
    exports["lb-phone"]:SendMessage(myNumber, number, "Hallo hier ist ".. name .. ", aus deiner Fraktion.", nil, nil, nil)
end)

RegisterNetEvent("factionapp:changemotd")
AddEventHandler("factionapp:changemotd", function(message)
    local xPlayer = ESX.GetPlayerFromId(source)

    for i=1, #blockedStrings, 1 do
        message = string.gsub(message, blockedStrings[i], 'Kein MOTD verfasst')
    end

    MySQL.Async.execute('UPDATE jobs SET motd = @motd WHERE name = @job', {
        ['@motd'] = message,

        ['@job'] = xPlayer.job.name,
    }, function()
    end)

    MOTD[xPlayer.job.name] = {
        message = message
    }

    TriggerClientEvent('notifyneu', source, 'Handy', 'MOTD wurde aktualisiert: ' .. message)
end)

RegisterNetEvent("factionapp:handleplayerjob")
AddEventHandler("factionapp:handleplayerjob", function(type, target)
    if source == target then
        TriggerClientEvent('notifyneu', source 'Handy', 'Du kannst deinen Job nicht selber verwalten') 
        return 
    end

    local xPlayer = ESX.GetPlayerFromId(source)

    if xPlayer.job.grade_name ~= "boss" then 
        TriggerClientEvent('notifyneu', source 'Handy', 'Du hast hierfür nicht die benötigten Rechte') 
        return 
    end

    local xTarget = ESX.GetPlayerFromId(tonumber(target))
    if xTarget == nil or xPlayer == nil then return end
    if xPlayer.job.grade <= xTarget.job.grade then return end
    if type == "promote" then
        xTarget.setJob(xPlayer.job.name, tonumber(xTarget.job.grade) + 1)
    elseif type == "demote" then
        xTarget.setJob(xPlayer.job.name, tonumber(xTarget.job.grade) - 1)
    elseif type == "fire" then
        xTarget.setJob("unemployed", 0)
    end

    print("done // "..type)
    if xTarget.job.name == "unemployed" then
        FrakData[xPlayer.job.name][xTarget.source] = nil
        return
    end

    FrakData[xPlayer.job.name][xTarget.source] = {
        name = xTarget.name,
        label = xTarget.job.grade_label,
        grade = xTarget.getJob().grade,
        number = exports["lb-phone"]:GetEquippedPhoneNumber(xTarget.source),
        source = xTarget.source
    }
end)

RegisterNetEvent("factionapp:callplayerjob")
AddEventHandler("factionapp:callplayerjob", function(target)
    if source == target then return end
    local xPlayer = ESX.GetPlayerFromId(source)
    local xTarget = ESX.GetPlayerFromId(target)
    if xTarget == nil or xPlayer == nil then return end
    if xPlayer.job.name ~= xTarget.job.name then return end

    local targetXphonenumber = exports["lb-phone"]:GetEquippedPhoneNumber(xTarget.source)
    local sourceXphonenumber = exports["lb-phone"]:GetEquippedPhoneNumber(xPlayer.source)

    local callId = exports["lb-phone"]:CreateCall({
        phoneNumber = sourceXphonenumber,
        source = xPlayer.source
    }, targetXphonenumber, {
        requirePhone = true,
        hideNumber = false
    })
end)

-- AddEventHandler('esx:playerLoaded', function(playerid, xPlayer)
--     if not xPlayer then return end
--     if xPlayer.job.name == "unemployed" then return end
--     if FrakData[xPlayer.job.name] == nil then
--         FrakData[xPlayer.job.name] = {}
--     end

--     FrakData[xPlayer.job.name][xPlayer.source] = {
--         name = xPlayer.name,
--         label = xPlayer.job.grade_label,
--         grade = xPlayer.job.grade,
--         number = exports["lb-phone"]:GetEquippedPhoneNumber(xPlayer.source),
--         source = xPlayer.source
--     }
-- end)

AddEventHandler('esx:playerLoaded', function(playerId, xPlayer)
    Wait(2500)

    if not xPlayer then return end
    if xPlayer.job.name == "unemployed" then return end
    if FrakData[xPlayer.job.name] == nil then
        FrakData[xPlayer.job.name] = {}
    end

    FrakData[xPlayer.job.name][playerId] = {
        name = xPlayer.name,
        label = xPlayer.job.grade_label,
        grade = xPlayer.job.grade,
        number = exports["lb-phone"]:GetEquippedPhoneNumber(playerId),
        source = playerId
    }
end)

AddEventHandler('esx:setJob', function(playerId, job, lastJob)
    local xPlayer = ESX.GetPlayerFromId(playerId)
    -- if FrakData[job.name] == nil then return end
    if job.name == "unemployed" then
        FrakData[xPlayer.lastJob.name][playerId] = nil
        return
    end

    if FrakData[job.name] == nil then
        FrakData[job.name] = {}
    end

    FrakData[job.name][playerId] = {
        name = xPlayer.rpName,
        label = xPlayer.job.grade_label,
        grade = xPlayer.job.grade,
        number = exports["lb-phone"]:GetEquippedPhoneNumber(playerId),
        source = playerId
    }
end)

AddEventHandler('esx:playerDropped', function(playerId)
    for k, v in pairs(FrakData) do
        if v[playerId] then
            v[playerId] = nil
        end
    end
end)