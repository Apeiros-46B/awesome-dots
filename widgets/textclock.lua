-- libs
local wibox = require("wibox")
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi

-- theme
local theme = beautiful.get()
local colors = theme.colorscheme

-- clock formats
local format1 = " %m/%d:%u -> %R "
local format2 = " %m/%d/%Y:%u -> %R:%S "

local textclock = wibox.widget {
    {
        {
            {
                id = "prefix",
                resize = true,
                forced_height = dpi(15),
                forced_width = dpi(15),
                image = theme.textclock_icon,
                widget = wibox.widget.imagebox,
            },
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

return textclock
