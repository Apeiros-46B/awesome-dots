local awful = require("awful")
local gears = require("gears")
local wibox = require("wibox")
local dpi = require("beautiful.xresources").apply_dpi

local get = function(s) awful.spawn.easy_async('acpi', function(stdout, _, _, _)
    -- Import sysinfo                                     -- Check if system has a battery
    local sysinfo = require("module.widgets.bar.sysinfo")(stdout:match('Battery %d') and true or false)

    -- Promptbox
    s.promptbox = awful.widget.prompt()
    s.promptbox.with_shell = true

    -- Layout indicator
    s.layoutbox = awful.widget.layoutbox(s)
    s.layoutbox:buttons(gears.table.join(
        awful.button({ }, 1, function () Menu:toggle()        end),
        awful.button({ }, 4, function () awful.layout.inc( 1) end),
        awful.button({ }, 5, function () awful.layout.inc(-1) end)
    ))

    -- System tray
    s.systray = require("module.widgets.bar.systray")

    -- Playerctl
    s.playerctl = require("module.bling.playerctl.init")

    -- Misc
    local padding = require("module.widgets.bar.padding")

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
            require("module.widgets.bar.geometric_taglist")(s),
            padding,
            require("module.widgets.bar.tasklist")(s),
            -- s.systray,
            s.promptbox,
        },
        { -- Middle widgets
            layout = wibox.layout.fixed.horizontal,
            s.playerctl.widget,
            nil
        },
        { -- Right widgets
            layout = wibox.layout.fixed.horizontal,

            require("module.widgets.bar.textclock"),
            (sysinfo.battery ~= nil and padding or nil),
            sysinfo.battery,
            padding,
            sysinfo.cpu,
            padding,
            sysinfo.memory,
        }
    }
end) end

return get
