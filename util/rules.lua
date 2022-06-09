local awful = require("awful")
local beautiful = require("beautiful")

local keys = require("util.keys")

awful.rules.rules = {
    -- All clients will match this rule.
    { rule = { },
        properties = {
            border_width = beautiful.border_width,
            border_color = beautiful.border_normal,
            focus = awful.client.focus.filter,
            raise = true,
            keys = keys.clientkeys,
            buttons = keys.clientbuttons,
            screen = awful.screen.preferred,
            placement = awful.placement.no_overlap + awful.placement.no_offscreen,
        }
    },

    -- Floating clients.
    { rule_any = {
        instance = {
            "DTA",              -- Firefox addon DownThemAll.
            "copyq",            -- Includes session name in class.
            "pinentry",
        },
        class = {
            "Arandr",
            "Blueman-manager",
            "Gpick",
            "Kruler",
            "MessageWin",       -- kalarm.
            "Nsxiv",            -- image viewer
            "Qalculate-gtk",    -- qalculate-gtk
            "Sxiv",             -- image viewer
            "Tor Browser",      -- Needs a fixed window size to avoid fingerprinting by screen size.
            "veromix",
            "Wpa_gui",
            "xtightvncviewer",
        },

        -- Note that the name property shown in xprop might be set slightly after creation of the client
        -- and the name shown there might not match defined rules here.
        name = {
            "Event Tester",     -- xev.
        },
        role = {
            "AlarmWindow",      -- Thunderbird's calendar.
            "ConfigManager",    -- Thunderbird's about:config.
            "pop-up",           -- e.g. Google Chrome's (detached) Developer Tools.
        }
    }, properties = { floating = true, ontop = true, placement = awful.placement.centered } },

    -- Sticky clients
    { rule_any = {
        class = {
            "Qalculate-gtk",
        },
    }, properties = { sticky = true, placement = awful.placement.centered } },

    -- Titlebars
    { rule_any = { type = { "normal", "dialog" } }, properties = { titlebars_enabled = true } },
}
