local wibox = require("wibox")
local gears = require("gears")

local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi
local colors = beautiful.colorscheme

return wibox.widget {
    {
        {
            {
                {
                    id = "prefix",
                    shape = function(cr, width, height)
                        local shape = gears.shape.isosceles_triangle(cr, dpi(11), dpi(11))
                        return shape
                    end,
                    bg = colors.gray1,
                    widget = wibox.container.background
                },
                id = "prefixcontainer",
                forced_width = dpi(27),
                forced_height = dpi(27),
                widget = wibox.container.place
            },
            id = "prefixbg",
            bg = colors.blue,
            widget = wibox.container.background
        },
        id = "prefixconstraint",
        forced_width = dpi(27),
        forced_height = dpi(27),
        widget = wibox.container.constraint
    },
    {
        {
            wibox.widget.systray,
            id = "traymargin",
            margins = dpi(3),
            widget = wibox.container.margin
        },
        id = "traybg",
        bg = colors.gray3,
        widget = wibox.container.background
    },
    id = "layout",
    widget = wibox.layout.fixed.horizontal
}
