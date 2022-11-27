-- {{{ Library imports
local awful = require("awful")
local ruled = require("ruled")
-- }}}

-- {{{ Rules to apply to all clients
ruled.client.connect_signal("request::rules", function()
    -- {{{ All clients will match this rule.
    ruled.client.append_rule {
        id         = "global",
        rule       = {},
        properties = {
            focus     = awful.client.focus.filter,
            raise     = true,
            screen    = awful.screen.preferred,
            placement = awful.placement.no_overlap+awful.placement.no_offscreen
        }
    }
    -- }}}

    -- {{{ Floating clients.
    ruled.client.append_rule {
        rule_any = {
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
                "mpv",              -- media player
                "Nsxiv",            -- image viewer
                "preview",          -- media preview script
                "Qalculate-gtk",    -- qalculate-gtk
                "Sxiv",             -- image viewer
                "Tor Browser",      -- Needs a fixed window size to avoid fingerprinting by screen size.
                "veromix",
                "vimpopup",         -- custom vim popup
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
        },
        properties = {
            floating = true,
            ontop = true,
            placement = awful.placement.centered
        }
    }
    -- }}}

    -- {{{ Sticky clients
    ruled.client.append_rule {
        rule_any = {
            class = {
                "Qalculate-gtk",
            },
        },
        properties = {
            sticky = true,
            placement = awful.placement.centered
        }
    }
    -- }}}

    -- {{{ Titlebars
    ruled.client.append_rule {
        rule_any = {
            type = { "normal", "dialog" }
        },
        properties = {
            titlebars_enabled = true
        }
    }
    -- }}}
end)
-- }}}
