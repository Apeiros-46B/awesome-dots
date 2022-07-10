local awful = require("awful")
local beautiful = require("beautiful")
local gears = require("gears")
local wibox = require("wibox")

local dpi = beautiful.xresources.apply_dpi

-- {{{ Return function
return function(c)
    -- {{{ Table of buttons
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
    -- }}}

    -- {{{ Create & return the widget
    return wibox.widget {
        -- {{{ Buttons (Left side)
        {
            {
                {
                    {
                        id = 'sticky_button',
                        forced_width = dpi(10),
                        forced_height = dpi(10),
                        widget = awful.titlebar.widget.stickybutton(c),
                    },
                    id = 'sticky_button_container',
                    forced_width = dpi(16),
                    forced_height = dpi(22),
                    widget = wibox.container.place
                },
                id = 'sticky_button_margin',
                left = dpi(3),
                widget = wibox.container.margin
            },
            {
                {
                    id = 'floating_button',
                    forced_width = dpi(10),
                    forced_height = dpi(10),
                    widget = awful.titlebar.widget.floatingbutton(c),
                },
                id = 'floating_button_container',
                forced_width = dpi(16),
                forced_height = dpi(22),
                widget = wibox.container.place
            },
            layout = wibox.layout.fixed.horizontal
        }, -- }}}
        -- {{{ Title and icon
        {
            -- {
            --     {
            --         id = 'icon',
            --         forced_width = dpi(16),
            --         forced_height = dpi(16),
            --         widget = awful.titlebar.widget.iconwidget(c)
            --     },
            --     id = 'icon_container',
            --     forced_width = dpi(22),
            --     forced_height = dpi(22),
            --     buttons = buttons,
            --     widget = wibox.container.place
            -- },
            {
                id = 'title',
                buttons = buttons,
                widget = awful.titlebar.widget.titlewidget(c)
            },
            id = 'icon_and_title_layout',
            layout = wibox.layout.fixed.horizontal
        },
        -- }}}
        -- {{{ Buttons (Right side)
        {
            {
                {
                    id = 'min_button',
                    forced_width = dpi(10),
                    forced_height = dpi(10),
                    widget = awful.titlebar.widget.minimizebutton(c),
                },
                id = 'min_button_container',
                forced_width = dpi(16),
                forced_height = dpi(22),
                widget = wibox.container.place
            },
            {
                {
                    id = 'max_button',
                    forced_width = dpi(10),
                    forced_height = dpi(10),
                    widget = awful.titlebar.widget.maximizedbutton(c),
                },
                id = 'max_button_container',
                forced_width = dpi(16),
                forced_height = dpi(22),
                widget = wibox.container.place
            },
            {
                {
                    {
                        id = 'close_button',
                        forced_width = dpi(10),
                        forced_height = dpi(10),
                        widget = awful.titlebar.widget.closebutton(c),
                    },
                    id = 'close_button_container',
                    forced_width = dpi(16),
                    forced_height = dpi(22),
                    widget = wibox.container.place
                },
                id = 'close_button_margin',
                right = dpi(3),
                widget = wibox.container.margin
            },
            id = 'buttons',
            layout = wibox.layout.fixed.horizontal
        }, -- }}}
        id = 'layout',
        expand = 'none',
        buttons = buttons,
        layout = wibox.layout.align.horizontal
    }
    -- }}}
end
-- }}}
