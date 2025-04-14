Config = {}

-- ════════════════════════════════════════
-- 💵 NAME CHANGE SETTINGS
-- ════════════════════════════════════════
Config.NameChangePrice = 1000                    -- Cost to change your name
Config.NameChangeCooldown = 60 * 60 * 24 * 30    -- Cooldown in seconds (30 days)

-- ⛔ Blocked words in names
Config.BlacklistedNames = {
    "admin", "staff", "mod", "fuck", "bitch", "shit", "nigger", "whore", "nazi", "terrorist"
}

-- 👑 Jobs that bypass blacklist/cooldown/payment checks
Config.NameBypassJobs = {
    "admin", "mod", "staff"
}

-- ════════════════════════════════════════
-- 🧍 NPC (PED) CONFIGURATION
-- ════════════════════════════════════════
Config.NPCS = {
    {
        model = "a_m_y_business_03",                            -- Ped model
        coords = vec3(-81.3209, -845.4672, 39.5370),            -- Ped spawn coords
        heading = 152.90,                                       -- Direction ped faces
        name = "NAME UPDATING OFFICER"                          -- 3D text above ped
    }
}

-- ════════════════════════════════════════
-- 🗺️ MAP BLIP SETTINGS
-- ════════════════════════════════════════
Config.mapBlip = {
    {
        Name = "Name Updating Station",                         -- Blip label on map
        Icon = 480,                                             -- Blip icon type
        Color = 6,                                              -- Blip color
        Size = 1.0,                                             -- Blip scale
        Display = 4,                                            -- Show on map & minimap
        coords = vector3(-81.3209, -845.4672, 39.5370)          -- Blip location
    }
}

-- ════════════════════════════════════════
-- 🎯 TARGET INTERACTION ZONE
-- ════════════════════════════════════════
Config.Target = {
    debugs = false,                                             -- Show dev box
    x = -81.6516,
    y = -845.9170,
    z = 40.5351                                                 -- Z slightly higher for target
}

-- ════════════════════════════════════════
-- 📢 DISCORD WEBHOOK LOGGING
-- ════════════════════════════════════════
Config.Discord = {
    webhookURL = ""                                             -- Add your webhook here
}
