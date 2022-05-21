local awful = require("awful")
local gears = require("gears")
local wibox = require("wibox")
local dpi = require("beautiful.xresources").apply_dpi

local get = function(s)
    -- Create a promptbox for each screen
    s.promptbox = awful.widget.prompt()
    s.promptbox.with_shell = true

    -- Create an imagebox widget which will contain a layout icon.
    -- We need one layoutbox per screen.
    s.layoutbox = awful.widget.layoutbox(s)
    s.layoutbox:buttons(gears.table.join(
        awful.button({ }, 1, function () mainmenu:show()      end),
        awful.button({ }, 4, function () awful.layout.inc( 1) end),
        awful.button({ }, 5, function () awful.layout.inc(-1) end)
    ))

    -- Misc widget imports
    local sysinfo = require("widgets.sysinfo")
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
            require("widgets.geolist")(s),
            -- require("widgets.taglist").get(s),
            s.promptbox,
        },
        { -- Middle widgets
            layout = wibox.layout.fixed.horizontal,

            -- require("widgets.improved_tasklist")(s),
            -- require("widgets.tasklist").get(s),
        },
        { -- Right widgets
            layout = wibox.layout.fixed.horizontal,

            require("widgets.textclock"),
            padding,
            sysinfo.battery,
            padding,
            sysinfo.cpu,
            padding,
            sysinfo.memory,
        }
    }
end

return get
