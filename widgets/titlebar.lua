local awful = require("awful")
local beautiful = require("beautiful")
local gears = require("gears")
local wibox = require("wibox")

local dpi = beautiful.xresources.apply_dpi
local colors = beautiful.colorscheme
local icons = beautiful.titlebar_icons

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
                id = 'clienticon',
                forced_width = dpi(21),
                forced_height = dpi(21),
                widget = awful.titlebar.widget.iconwidget(c)
            },
            id = 'iconcontainer',
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
                {
                    id = 'min_button',
                    image = icons.min.normal,
                    forced_width = dpi(11),
                    forced_height = dpi(11),
                    widget = wibox.widget.imagebox
                },
                id = 'min_button_container',
                forced_width = dpi(23),
                forced_height = dpi(27),
                buttons = { awful.button({ }, 1, function() c.minimized = true end) },
                widget = wibox.container.place
            },
            {
                {
                    id = 'max_button',
                    image = icons.max.normal,
                    forced_width = dpi(11),
                    forced_height = dpi(11),
                    widget = wibox.widget.imagebox
                },
                id = 'max_button_container',
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
                widget = wibox.container.place
            },
            {
                {
                    {
                        id = 'close_button',
                        image = icons.close.normal,
                        forced_width = dpi(11),
                        forced_height = dpi(11),
                        widget = wibox.widget.imagebox
                    },
                    id = 'close_button_container',
                    forced_width = dpi(23),
                    forced_height = dpi(27),
                    buttons = { awful.button({ }, 1, function() c:kill() end) },
                    widget = wibox.container.place
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
