local awful = require("awful")
local gears = require("gears")
local wibox = require("wibox")
local dpi = require("beautiful.xresources").apply_dpi

local get = function(s) awful.spawn.easy_async('acpi', function(stdout, _, _, _)
    -- Import sysinfo                          -- Check if system has a battery
    local sysinfo = require("widgets.sysinfo")(stdout:match('Battery %d') and true or false)

    -- Promptbox
    s.promptbox = awful.widget.prompt()
    s.promptbox.with_shell = true

    -- Layout indicator
    s.layoutbox = awful.widget.layoutbox(s)
    s.layoutbox:buttons(gears.table.join(
        awful.button({ }, 1, function () Menu:show()      end),
        awful.button({ }, 4, function () awful.layout.inc( 1) end),
        awful.button({ }, 5, function () awful.layout.inc(-1) end)
    ))

    -- System tray
    s.systray = require("widgets.systray")

    -- Misc
    local padding = require("widgets.padding")

    -- Create the wibox
    s.wibox = awful.wibar({ position = "bottom", screen = s, height = dpi(27) })

    -- Add widgets to the wibox
    s.wibox:setup {
        id = "layout_container",
        layout = wibox.layout.align.horizontal,
        expand = "none",
        { -- Left widgets
            layout = wibox.layout.fixed.horizontal,

            s.layoutbox,
            padding,
            require("widgets.taglist_geometric")(s),
            padding,
            require("widgets.tasklist")(s),
            -- s.systray,
            s.promptbox,
        },
        { -- Middle widgets
            layout = wibox.layout.fixed.horizontal,
        },
        { -- Right widgets
            layout = wibox.layout.fixed.horizontal,

            require("widgets.textclock"),
            (has_battery and padding or nil),
            sysinfo.battery,
            padding,
            sysinfo.cpu,
            padding,
            sysinfo.memory,
        }
    }
end) end

return get
