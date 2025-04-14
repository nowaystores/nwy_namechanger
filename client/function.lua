local spawnedPeds = {}

-- Spawn NPCs and Blips
CreateThread(function()
    for _, npc in ipairs(Config.NPCS or {}) do
        local model = GetHashKey(npc.model)

        RequestModel(model)
        while not HasModelLoaded(model) do Wait(0) end

        local ped = CreatePed(4, model, npc.coords, npc.heading, false, false)
        SetEntityHeading(ped, npc.heading)
        FreezeEntityPosition(ped, true)
        SetEntityInvincible(ped, true)
        SetBlockingOfNonTemporaryEvents(ped, true)

        table.insert(spawnedPeds, {
            ped = ped,
            name = npc.name or "NPC"
        })
    end

    for _, blip in ipairs(Config.mapBlip or {}) do
        local b = AddBlipForCoord(blip.coords.x, blip.coords.y, blip.coords.z)
        SetBlipSprite(b, blip.Icon)
        SetBlipColour(b, blip.Color)
        SetBlipDisplay(b, blip.Display)
        SetBlipAlpha(b, 250)
        SetBlipScale(b, 0.6)
        SetBlipAsShortRange(b, true)
        PulseBlip(b)

        BeginTextCommandSetBlipName("STRING")
        AddTextComponentSubstringPlayerName(blip.Name or "Location")
        EndTextCommandSetBlipName(b)
    end
end)

-- 3D Text Drawing Function
local function DrawText3D(x, y, z, text)
    local onScreen, _x, _y = World3dToScreen2d(x, y, z)
    if not onScreen then return end

    local camCoords = GetGameplayCamCoords()
    local dist = #(camCoords - vec3(x, y, z))
    local scale = (1 / dist) * 1.5 * (1 / GetGameplayCamFov()) * 100

    SetTextScale(0.35, 0.35)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextCentre(true)
    SetTextColour(255, 255, 255, 215)

    SetTextEntry("STRING")
    AddTextComponentString(text)
    DrawText(_x, _y)
end

-- Draw name tags above NPCs
CreateThread(function()
    while true do
        Wait(0)
        local playerCoords = GetEntityCoords(PlayerPedId())

        for _, data in ipairs(spawnedPeds) do
            if DoesEntityExist(data.ped) then
                local pedCoords = GetEntityCoords(data.ped)
                if #(playerCoords - pedCoords) < 20.0 then
                    DrawText3D(pedCoords.x, pedCoords.y, pedCoords.z + 1.0, data.name)
                end
            end
        end
    end
end)