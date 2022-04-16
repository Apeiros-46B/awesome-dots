local recolor = require("gears").color.recolor_image
local beautiful = require("beautiful")
local colors = beautiful.colorscheme
local state_icons = beautiful.client_state_icons
local placeholder_icon = beautiful.awesome_icon_alt

local get = function(client)
    local returned = {
        icon = placeholder_icon,
        bg = beautiful.taglist_bg_normal,
        state_icons = {}
    }

    -- get the client's icon and set it as returned.icon

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
