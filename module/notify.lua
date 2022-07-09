local wibox = require("wibox")
local naughty = require("naughty")

local beautiful = require("beautiful")
local colors = beautiful.colorscheme
local dpi = beautiful.xresources.apply_dpi

local notifications = {}

local function has_items(t)
    local looped = false

    for _,_ in pairs(t) do
        looped = true
        break
    end

    return looped
end

naughty.connect_signal("request::display", function(n, _)
    -- naughty.layout.legacy {
    --     -- Set the notification
    --     notification = n,
    -- }
    local actions_list = wibox.widget {
        notification = n,
        base_layout = wibox.widget {
            spacing         = 4,
            layout          = wibox.layout.flex.horizontal
        },
        widget_template = {
            {
                {
                    {
                        id            = "icon",
                        forced_height = dpi(16),
                        forced_width  = dpi(16),
                        widget        = wibox.widget.imagebox
                    },
                    {
                        id     = "text",
                        widget = wibox.widget.textbox
                    },
                    spacing    = dpi(4),
                    layout     = wibox.layout.fixed.horizontal
                },
                id = "background",
                widget         = wibox.container.background,
            },
            margins = dpi(4),
            widget  = wibox.container.margin,
        },
        widget = naughty.list.actions,
    }

    naughty.layout.box {
        -- Set the notification
        notification = n,

        -- Mouse cursor
        cursor = "hand1",

        -- Styling
        border_color = beautiful.notification_border_color,
        border_width = beautiful.notification_border_width,
        widget_template = {
            {
                {
                    {
                        {
                            naughty.widget.icon,
                            {
                                naughty.widget.title,
                                naughty.widget.message,
                                spacing = beautiful.notification_text_spacing,
                                layout  = wibox.layout.fixed.vertical,
                            },
                            fill_space = true,
                            spacing    = beautiful.notification_margin,
                            layout     = wibox.layout.fixed.horizontal,
                        },
                        actions_list,
                        spacing = 0,
                        layout  = wibox.layout.fixed.vertical,
                    },
                    margins = beautiful.notification_margin,
                    widget  = wibox.container.margin,
                },
                id     = "background",
                widget = naughty.container.background,
            },
            strategy = "max",
            width    = beautiful.notification_max_width,
            widget   = wibox.container.constraint,
        }
    }

    if n.app_name then notifications[n.app_name] = n end
end)

return function(options)
    local replaces = options.replaces
    local app_name = options.app_name

    if replaces and app_name then
        local noti_to_destroy = notifications[app_name]
        if noti_to_destroy then noti_to_destroy.die(naughty.notification_closed_reason.dismissedByUser) end
    end

    naughty.notification(options)
end
