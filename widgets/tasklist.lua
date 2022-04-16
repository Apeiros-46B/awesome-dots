local gears = require("gears")
local awful = require("awful")
local wibox = require("wibox")
local dpi = require("beautiful.xresources").apply_dpi

local tasklist = {}

local tasklist_padding = 2

local tasklist_buttons = gears.table.join(
    awful.button({ }, 1, function (c)
        if c == client.focus then
            c.minimized = true
        else
            c:emit_signal(
                "request::activate",
                "tasklist",
                {raise = true}
            )
        end
    end),

    awful.button({ }, 2, function(c) c:kill() end),
    awful.button({ }, 3, function() awful.menu.client_list({ theme = { width = 250 } }) end),
    awful.button({ }, 4, function() awful.client.focus.byidx(-1) end),
    awful.button({ }, 5, function() awful.client.focus.byidx(1) end)
)

function tasklist.get(s)
    local widget = awful.widget.tasklist {
        screen = s,
        filter = awful.widget.tasklist.filter.currenttags,
        buttons = tasklist_buttons,
        style = {
            shape_border_width = 0,
            shape_border_color = '#000000',
            shape = gears.shape.rectangle,
        },
        layout = {
            -- spacing = 18,
            spacing = 0,
            spacing_widget = {
                {
                    -- forced_width = 3,
                    -- forced_height = 20,
                    forced_width = 0,
                    forced_height = 0,
                    color = '#384348',
                    shape = gears.shape.rectangle,
                    widget = wibox.widget.separator
                },
                valign = 'center',
                halign = 'center',
                widget = wibox.container.place,
            },
            layout = wibox.layout.flex.horizontal
        },
        -- Notice that there is *NO* wibox.wibox prefix, it is a template,
        -- not a widget instance.
        widget_template = {
            {
                {
                    {
                        {
                            id = 'icon_role',
                            widget = wibox.widget.imagebox,
                        },
                        margins = dpi(tasklist_padding * 2),
                        forced_width = 24,
                        -- right = dpi(tasklist_padding * 4),
                        widget = wibox.container.margin,
                    },
                    -- {
                    --    id     = 'text_role',
                    --    widget = wibox.widget.textbox,
                    -- },
                    layout = wibox.layout.fixed.horizontal,
                },
                left = dpi(tasklist_padding),
                right = dpi(tasklist_padding),
                -- right = dpi(tasklist_padding * 4),
                widget = wibox.container.margin
            },
            id = 'background_role',
            widget = wibox.container.background,
        },
    }

    return widget
end

return tasklist
