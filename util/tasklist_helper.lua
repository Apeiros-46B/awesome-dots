local wibox = require("wibox")
local awful = require("awful")
local gears = require("gears")
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi
local colors = beautiful.colorscheme
local placeholder_icon = beautiful.awesome_icon_alt

local get = function(client)
    local returned = {
        main_icon = placeholder_icon,
        bg = beautiful.taglist_bg_normal,
        state_icons = {}
    }

    -- get the client's icon, make a widget with it and set returned.icon to the widget
    local main_icon = wibox.widget {
        {
            {
                id = "icon",
                resize = true,
                widget = wibox.widget.imagebox
            },
            forced_width = dpi(27),
            margins = dpi(4),
            widget = wibox.container.margin,
            id = "margin"
        },
        gears.shape.rectangle,
        widget = wibox.container.background
    }

    main_icon.margin.icon.image = client.icon

    if client == client.focus then
        main_icon.bg = colors.blue
    end

    -- set bg color as returned.bg based on client attributes
    -- BG AND FG SET IN THEME VARS, USE THOSE INSTEAD
    -- (beautiful.taglist_<bg|fg>_<state>)
    ---- focused = blue bg, gray1 fg
    ---- omnipresent = purple bg, gray1 fg
    ---- urgent = red bg, gray1 fg
    ---- minimized = gray3 bg, gray5 fg
    ---- normal = gray3 bg, white fg

    -- get the client's state and add wibox.widget.imagebox es
    -- with recolored icons with the same color as fg
    -- to returned.state_icons
    ---- state icons: beautiful.client_state_icons.state_name
    ---- use gears.color.recolor_image to color the icons to fg
    ---- from beautiful.fg_<state>

    return returned
end

return get
