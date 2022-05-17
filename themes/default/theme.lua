-- {{{ Libraries
local theme_assets = require("beautiful.theme_assets")
local xresources = require("beautiful.xresources")
local dpi = xresources.apply_dpi
local gears = require("gears")
local naughty = require("naughty")
-- }}}

-- {{{ Util
local recolor = gears.color.recolor_image
local themes_path = os.getenv("HOME") .. "/.config/awesome/themes/"

local theme = {}
-- }}}

-- {{{ Colors
local colors = {
    -- Gray
    gray1 = "#2b3339",
    gray2 = "#303c42",
    gray3 = "#384348",
    gray4 = "#445055",
    gray5 = "#607279",
    gray6 = "#7a8487",
    gray7 = "#859289",

    -- Foreground
    white = "#d3c6aa",

    -- Other colors
    red = "#e67e80",
    green = "#a7c080",
    yellow = "#ddbc7f",
    blue = "#7fbbb3",
    purple = "#d699b6",
    teal = "#83c092"
}

theme.colorscheme = colors
-- }}}

-- {{{ Font(s)
theme.font          = "JetBrainsMono Nerd Font Bold 10"
-- }}}

-- {{{ Background
theme.bg_normal     = colors.gray1
theme.bg_focus      = colors.blue
theme.bg_urgent     = colors.red
theme.bg_minimize   = colors.gray3
theme.bg_systray    = colors.gray3
-- }}}

-- {{{ Foreground
theme.fg_normal     = colors.white
theme.fg_focus      = colors.gray1
theme.fg_urgent     = colors.gray1
theme.fg_minimize   = colors.gray5
theme.fg_minimize_2 = colors.gray4
theme.fg_minimize_3 = colors.gray3
-- }}}

-- {{{ Gaps/Borders
theme.useless_gap   = dpi(4)
theme.border_width  = dpi(2)
theme.border_normal = colors.gray3
theme.border_focus  = colors.blue
theme.border_marked = colors.red
-- }}}

-- {{{ Hotkeys popup
theme.hotkeys_modifiers_fg = colors.gray5
theme.hotkeys_border_width = dpi(2)
theme.hotkeys_border_color = colors.blue
-- }}}

-- {{{ Bling window switcher
theme.window_switcher_widget_bg = colors.gray2                    -- The bg color of the widget
theme.window_switcher_widget_border_width = 2                     -- The border width of the widget
theme.window_switcher_widget_border_radius = 0                    -- The border radius of the widget
theme.window_switcher_widget_border_color = colors.gray3          -- The border color of the widget
theme.window_switcher_clients_spacing = 16                        -- The space between each client item
theme.window_switcher_client_icon_horizontal_spacing = 4          -- The space between client icon and text
theme.window_switcher_client_width = 600                          -- The width of one client widget
theme.window_switcher_client_height = 48                          -- The height of one client widget
theme.window_switcher_client_margins = 12                         -- The margin between the content and the border of the widget
theme.window_switcher_thumbnail_margins = 12                      -- The margin between one client thumbnail and the rest of the widget
theme.thumbnail_scale = false                                     -- If set to true, the thumbnails fit policy will be set to "fit" instead of "auto"
theme.window_switcher_name_margins = 10                           -- The margin of one clients title to the rest of the widget
theme.window_switcher_name_valign = "center"                      -- How to vertically align one clients title
theme.window_switcher_name_forced_width = 550                     -- The width of one title
theme.window_switcher_name_font = "JetBrainsMono Nerd Font Bold"  -- The font of all titles
theme.window_switcher_name_normal_color = colors.white            -- The color of one title if the client is unfocused
theme.window_switcher_name_focus_color = colors.blue              -- The color of one title if the client is focused
theme.window_switcher_icon_valign = "center"                      -- How to vertically align the one icon
theme.window_switcher_icon_width = 40                             -- The width of one icon
-- }}}

-- {{{ Notifications
naughty.config.padding = dpi(18)
naughty.config.spacing = dpi(8)
naughty.config.defaults.icon_size = dpi(48)
naughty.config.defaults.margin = dpi(12)
naughty.config.defaults.border_width = dpi(2)
theme.notification_border_color = colors.gray3
theme.notification_bg = colors.gray2
-- }}}

-- {{{ Menu
theme.menu_submenu_icon = themes_path.."default/icons/misc/submenu.png"
theme.menu_height = dpi(15)
theme.menu_width  = dpi(125)
-- }}}

-- {{{ Tasklist
theme.tasklist_bg_focus         = colors.blue
theme.tasklist_bg_omnipresent   = colors.purple
theme.tasklist_bg_urgent        = colors.red
theme.tasklist_bg_normal        = colors.gray3

theme.tasklist_fg_focus         = colors.gray1
theme.tasklist_fg_omnipresent   = colors.gray1
theme.tasklist_fg_urgent        = colors.gray1
theme.tasklist_fg_minimized     = colors.gray5
theme.tasklist_fg_normal        = colors.white

-- no longer needed, custom taglist exists :euphoria:
-- theme.tasklist_sticky = ""
-- theme.tasklist_ontop = "ﱢ "
-- theme.tasklist_above = "ﲗ "
-- theme.tasklist_below = "ﲔ "
-- theme.tasklist_floating = "ﰉ "
-- theme.tasklist_maximized = " "
-- theme.tasklist_maximized_horizontal = " "
-- theme.tasklist_maximized_vertical = ""
-- }}}

-- {{{ Taglist
theme.taglist_font = theme.font

theme.taglist_fg_empty = colors.gray5

theme.taglist_bg_focus = colors.blue
theme.taglist_bg_urgent = colors.red
theme.taglist_bg_volatile = colors.yellow
theme.taglist_bg_normal = colors.gray3
theme.taglist_bg_occupied = colors.gray3
theme.taglist_bg_empty = colors.gray3
-- }}}

-- {{{ Custom tasklist
local tasklist_base_icons = {}

tasklist_base_icons.floating     = themes_path.."default/icons/tasklist/floating.svg"
tasklist_base_icons.max          = themes_path.."default/icons/tasklist/max.svg"
tasklist_base_icons.max_horiz    = themes_path.."default/icons/tasklist/max_horiz.svg"
tasklist_base_icons.max_vert     = themes_path.."default/icons/tasklist/max_vert.svg"
tasklist_base_icons.ontop        = themes_path.."default/icons/tasklist/ontop.svg"
tasklist_base_icons.min          = themes_path.."default/icons/tasklist/min.svg"
tasklist_base_icons.sticky       = themes_path.."default/icons/tasklist/sticky.svg"

local tasklist_style = {}

tasklist_style.floating = {
    icon = recolor(tasklist_base_icons.floating, colors.white),
    icon_dark = recolor(tasklist_base_icons.floating, colors.gray1),
    bg = colors.gray3
}

tasklist_style.max = {
    icon = recolor(tasklist_base_icons.max, colors.white),
    icon_dark = recolor(tasklist_base_icons.max, colors.gray1),
    bg = colors.gray3
}

tasklist_style.max_horiz = {
    icon = recolor(tasklist_base_icons.max_horiz, colors.white),
    icon_dark = recolor(tasklist_base_icons.max_horiz, colors.gray1),
    bg = colors.gray3
}

tasklist_style.max_vert = {
    icon = recolor(tasklist_base_icons.max_vert, colors.white),
    icon_dark = recolor(tasklist_base_icons.max_vert, colors.gray1),
    bg = colors.gray3
}

tasklist_style.ontop = {
    icon = recolor(tasklist_base_icons.ontop, colors.white),
    icon_dark = recolor(tasklist_base_icons.ontop, colors.gray1),
    bg = colors.gray3
}

tasklist_style.min = {
    -- minimized has slightly different FG color on light variant
    icon = recolor(tasklist_base_icons.min, colors.gray5),
    icon_dark = recolor(tasklist_base_icons.min, colors.gray1),
    bg = colors.gray3
}

tasklist_style.sticky = {
    icon = recolor(tasklist_base_icons.sticky, colors.gray1),
    -- sticky already implies dark, no need for another dark variant
    bg = colors.purple
}

-- focused and urgent do not have icons, only a bg color
tasklist_style.focused = colors.blue
tasklist_style.urgent = colors.red

theme.tasklist_style = tasklist_style
-- }}}

-- {{{ Custom taglist (geolist)
local geolist_base_icons = {}

geolist_base_icons.rhomb = {
    filled = themes_path.."default/icons/geolist/rhomb_filled.svg",
    hollow = themes_path.."default/icons/geolist/rhomb_hollow.svg",
}

geolist_base_icons.circle = {
    filled = themes_path.."default/icons/geolist/circle_filled.svg",
    hollow = themes_path.."default/icons/geolist/circle_hollow.svg",
}

geolist_base_icons.square = themes_path.."default/icons/geolist/square.svg"
geolist_base_icons.triangle = themes_path.."default/icons/geolist/triangle.svg"

local geolist_style = {}

geolist_style.empty = {
    icon = recolor(geolist_base_icons.circle.hollow, colors.gray5),
    bg = colors.gray3
}

geolist_style.occupied = {
    icon = recolor(geolist_base_icons.circle.filled, colors.white),
    bg = colors.gray3
}

geolist_style.omnipresent_unfocused = {
    icon = recolor(geolist_base_icons.circle.hollow, colors.gray5),
    bg = colors.gray3
}

geolist_style.omnipresent_focused = {
    icon = recolor(geolist_base_icons.rhomb.hollow, colors.white),
    bg = colors.gray3
}

geolist_style.selected = {
    icon = recolor(geolist_base_icons.rhomb.filled, colors.gray1),
    bg = colors.blue
}

geolist_style.urgent = {
    icon = recolor(geolist_base_icons.triangle, colors.gray1),
    bg = colors.red
}

geolist_style.volatile = {
    icon = recolor(geolist_base_icons.square, colors.gray1),
    bg = colors.yellow
}

theme.geolist_style = geolist_style
-- }}}

-- {{{ Layout icons
theme.layout_fairv = themes_path.."default/icons/layouts/fairv.png"
theme.layout_floating  = themes_path.."default/icons/layouts/floating.png"
theme.layout_tile = themes_path.."default/icons/layouts/tile.png"
theme.layout_spiral  = themes_path.."default/icons/layouts/spiral.png"
theme.layout_dwindle = themes_path.."default/icons/layouts/dwindle.png"
-- }}}

-- {{{ Misc icons
-- Textclock
theme.textclock_icon = recolor(themes_path.."default/icons/misc/textclock-hourglass.svg", colors.gray1)

-- System info
theme.sysinfo_cpu_icon = recolor(themes_path.."default/icons/misc/sysinfo-cpu.svg", colors.gray1)
theme.sysinfo_memory_icon = recolor(themes_path.."default/icons/misc/sysinfo-memory.svg", colors.gray1)

-- Awesome icons
theme.awesome_icon = theme_assets.awesome_icon(64, theme.bg_focus, theme.fg_focus)
theme.awesome_icon_alt = themes_path.."default/icons/misc/awesome-icon-largegap.png"
-- }}}

-- {{{ Other
-- Icon theme
theme.icon_theme = nil

-- Wallpaper
theme.wallpaper = themes_path.."default/walls/light_floral_everforest.png"
-- }}}

-- {{{ Return
return theme

-- vim: filetype=lua:expandtab:shiftwidth=4:tabstop=8:softtabstop=4:textwidth=80
-- }}}
