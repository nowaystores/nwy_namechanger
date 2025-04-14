local ESX = exports["es_extended"]:getSharedObject()

-- Helper: Check if name is blacklisted
local function isNameBlacklisted(name)
    for _, word in pairs(Config.BlacklistedNames or {}) do
        if string.match(string.lower(name), word) then
            return true
        end
    end
    return false
end

-- Helper: Send Discord log
local function sendToDiscord(color, title, message)
    local embed = {{
        color = color or 16753920,
        title = "**" .. title .. "**",
        description = message
    }}

    if Config.Discord.webhookURL and Config.Discord.webhookURL ~= "" then
        PerformHttpRequest(Config.Discord.webhookURL, function() end, "POST", json.encode({
            username = "NAME CHANGER LOGS",
            embeds = embed
        }), {
            ["Content-Type"] = "application/json"
        })
    end
end

-- Helper: Send notification
local function sendNotification(target, description, notifType, position, duration)
    TriggerClientEvent("ox_lib:notify", target, {
        title = "",
        description = description or "",
        type = notifType or "info",
        position = position or "top",
        duration = duration or 5000
    })
end

RegisterNetEvent("nwy_namechange:event", function(firstName, lastName)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    if not xPlayer then return end

    local identifier = xPlayer.identifier
    local now = os.time()
    local cooldown = Config.NameChangeCooldown or (60 * 60 * 24 * 30)
    local price = Config.NameChangePrice or 5000

    -- 👑 Admin Bypass
    local bypass = false
    for _, job in ipairs(Config.NameBypassJobs or {}) do
        if xPlayer.getJob().name == job then
            bypass = true
            break
        end
    end

    -- ✋ Name blacklist check (unless bypassed)
    if not bypass and (isNameBlacklisted(firstName) or isNameBlacklisted(lastName)) then
        sendNotification(src, "This name is not allowed on the server.", "error", "top", 5000)
        return
    end

    -- ⏱️ Check cooldown
    MySQL.Async.fetchScalar("SELECT UNIX_TIMESTAMP(last_namechange) FROM users WHERE identifier = @identifier", {
        ['@identifier'] = identifier
    }, function(lastChange)
        if lastChange and now - lastChange < cooldown then
            local daysLeft = math.ceil((cooldown - (now - lastChange)) / (60 * 60 * 24))
            sendNotification(src, "You can only change your name again in " .. daysLeft .. " day(s).", "error", "top", 5000)
            return
        end

        -- 💰 Check money
        local bank = xPlayer.getAccount("bank").money
        local cash = xPlayer.getMoney()
        local total = bank + cash

        if not bypass and total < price then
            sendNotification(src, "You need $" .. price .. " to change your name.", "error", "top", 5000)
            return
        end

        -- 🧾 Payment (bank first, then cash)
        if not bypass then
            local remaining = price
            if bank >= remaining then
                xPlayer.removeAccountMoney("bank", remaining)
            else
                if bank > 0 then
                    xPlayer.removeAccountMoney("bank", bank)
                    remaining = remaining - bank
                end
                xPlayer.removeMoney(remaining)
            end
        end

        -- 📦 Update name & last change time
        MySQL.Async.transaction({
            'UPDATE users SET firstname = @firstName WHERE identifier = @identifier',
            'UPDATE users SET lastname = @lastName WHERE identifier = @identifier',
            'UPDATE users SET last_namechange = NOW() WHERE identifier = @identifier'
        }, {
            ['@firstName'] = firstName,
            ['@lastName'] = lastName,
            ['@identifier'] = identifier
        })

        -- 🔁 Prompt player to relog
        TriggerClientEvent("nwy_namechange:confirmRestart", src)

        -- 📜 Discord log
        local logMessage = string.format(
            "**Old Name:** %s\n**Identifier:** `%s`\n**New First Name:** %s\n**New Last Name:** %s\n**Paid:** $%s",
            xPlayer.name,
            identifier,
            firstName,
            lastName,
            bypass and "BYPASSED" or price
        )
        sendToDiscord(16753920, "Player Name Changed", logMessage)
    end)
end)