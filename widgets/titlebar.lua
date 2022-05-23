local awful = require("awful")
local beautiful = require("beautiful")
local gears = require("gears")
local wibox = require("wibox")

local dpi = beautiful.xresources.apply_dpi
local colors = beautiful.colorscheme
local button_style = beautiful.titlebar_button_style

return function(c)
    -- Create the buttons
    local buttons = gears.table.join(
        awful.button({ }, 1, function()
            c:emit_signal("request::activate", "titlebar", {raise = true})
            awful.mouse.client.move(c)
        end),
        awful.button({ }, 3, function()
            c:emit_signal("request::activate", "titlebar", {raise = true})
            awful.mouse.client.resize(c)
        end)
    )

    -- Create the widget
    local titlebar = wibox.widget {
        {
            {
                id = 'icon',
                forced_width = dpi(21),
                forced_height = dpi(21),
                widget = awful.titlebar.widget.iconwidget(c)
            },
            id = 'icon_container',
            forced_width = dpi(27),
            forced_height = dpi(27),
            buttons = buttons,
            widget = wibox.container.place
        },
        {
            id = 'title',
            buttons = buttons,
            widget = awful.titlebar.widget.titlewidget(c)
        },
        {
            {
                id = 'min_button',

                forced_width = dpi(23),
                forced_height = dpi(27),

                buttons = { awful.button({ }, 1, function() c.minimized = true end) },

                bg = button_style.min.color,

                shape = function(cr, _, _)
                    return button_style.min.shape(cr, 11, 9.6)
                end,

                widget = wibox.container.background
            },
            {
                id = 'max_button',

                forced_width = dpi(23),
                forced_height = dpi(27),

                buttons = {
                    awful.button(
                        { },
                        1,
                        function()
                            c.maximized = not c.maximized
                            c:raise()
                        end
                    ),

                    awful.button(
                        { },
                        3,
                        function()
                            c.fullscreen = not c.fullscreen
                            c:raise()
                        end
                    )
                },

                bg = button_style.max.color,

                shape = function(cr, _, _)
                    return button_style.max.shape(cr, 11, 11)
                end,

                widget = wibox.container.background
            },
            {
                {
                    id = 'close_button',

                    forced_width = dpi(23),
                    forced_height = dpi(27),

                    buttons = { awful.button({ }, 1, function() c:kill() end) },

                    bg = button_style.close.color,

                    shape = function(cr, _, _)
                        return button_style.close.shape(cr, 11, 11, 5.5)
                    end,

                    widget = wibox.container.background
                },
                id = 'close_button_margin',
                right = dpi(2),
                widget = wibox.container.margin
            },
            id = 'buttons',
            widget = wibox.layout.fixed.horizontal
        },
        id = 'layout',
        expand = 'none',
        buttons = buttons,
        widget = wibox.layout.align.horizontal
    }

    return titlebar
end
