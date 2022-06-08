-- libs
local awful = require("awful")
local beautiful = require("beautiful")
local gears = require("gears")
local wibox = require("wibox")

-- functions
local dpi = beautiful.xresources.apply_dpi

-- theme
local theme = beautiful.get()
local colors = theme.colorscheme

-- clock formats
local format1 = " %m/%d:%u -> %R "
local format2 = " %m/%d/%Y:%u -> %R:%S "

-- analog clock
local analog_clock = require('widgets.analog_clock')({
    background = {
        shape = gears.shape.circle,
        color = colors.gray1
    },

    second = {
        v = 0,
        enable = true,
        color = colors.purple,
        w = 1,
        h = 10
    },

    minute = {
        v = 0,
        enable = true,
        color = colors.teal,
        w = 2,
        h = 9
    },

    hour = {
        v = 0,
        enable = true,
        color = colors.blue,
        w = 2,
        h = 6
    }
})

analog_clock.forced_width = dpi(21)
analog_clock.forced_height = dpi(21)

local textclock = wibox.widget {
    {
        {
            analog_clock,
            id = "prefixmargin",
            forced_width = dpi(27),
            forced_height = dpi(27),
            widget = wibox.container.place,
        },
        id = "prefixbg",
        bg = colors.teal,
        widget = wibox.container.background,
    },
    {
        {
            id = "clock",
            format = format1,
            widget = wibox.widget.textclock,
        },
        id = "clockbg",
        bg = colors.gray3,
        widget = wibox.container.background,
    },
    id = "layout",
    layout = wibox.layout.fixed.horizontal
}

textclock:buttons(gears.table.join(
    awful.button({}, 1, function () textclock:emit_signal("textclock::format_change") end)
))

textclock:connect_signal("textclock::format_change", function(_)
    local widget = textclock:get_children_by_id("clock")[1]

    if widget.format == format1 then
        widget.format  = format2
        widget.refresh = 1
    else
        widget.format  = format1
        widget.refresh = 45
    end
end)

return textclock
