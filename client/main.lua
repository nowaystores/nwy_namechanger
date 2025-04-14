local ESX = exports["es_extended"]:getSharedObject()

-- Function to open the name change dialog
local function openNameChangeDialog()
    local userInput = lib.inputDialog("Personal Information Update", {
        {
            type = "input",
            label = "First Name",
            placeholder = "Enter your first name",
            icon = "fa fa-address-card",
            required = true,
            default = "",
            min = 2,
            max = 16
        },
        {
            type = "input",
            label = "Last Name",
            placeholder = "Enter your last name",
            icon = "fa fa-address-card",
            required = true,
            min = 2,
            max = 16
        },
        {
            type = "checkbox",
            label = "Are you certain about changing your name?",
            required = true
        }
    })

    if userInput then
        local firstName = userInput[1]
        local lastName = userInput[2]
        TriggerServerEvent("nwy_namechange:event", firstName, lastName)
    end
end

-- Create interaction zone using ox_target
CreateThread(function()
    local ox = exports.ox_target
    if ox and ox.addBoxZone then
        ox:addBoxZone({
            coords = vector3(Config.Target.x, Config.Target.y, Config.Target.z),
            size = vector3(1, 1, 1),
            rotation = 45,
            debug = Config.Target.debugs,
            options = {
                {
                    name = "name_change_zone",
                    icon = "fa-solid fa-file-signature",
                    label = "Rename Yourself",
                    onSelect = function()
                        openNameChangeDialog()
                    end
                }
            }
        })
    else
        print("[nwy_namechange] ⚠️ ox_target not found or outdated.")
    end
end)

-- Show confirmation dialog to relog or stay
RegisterNetEvent("nwy_namechange:confirmRestart", function()
    lib.registerContext({
        id = "namechange_restart_confirm",
        title = "Name Change Complete",
        options = {
            {
                title = "Restart Now",
                description = "You’ll be sent to character selection.",
                icon = "rotate-ccw",
                onSelect = function()
                    ExecuteCommand("relog")
                end
            },
            {
                title = "Stay Logged In",
                description = "Apply changes next time you join.",
                icon = "x",
                onSelect = function()
                    lib.hideContext()
                end
            }
        }
    })

    lib.showContext("namechange_restart_confirm")
end)