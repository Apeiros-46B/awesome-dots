-- {{{ Libraries
local beautiful = require('beautiful')
local theme_assets = beautiful.theme_assets
local xresources = beautiful.xresources
local dpi = xresources.apply_dpi

local naughty = require('naughty')

local gears = require('gears')

local shape = gears.shape
local shape_load = gears.surface.load_from_shape
local recolor = gears.color.recolor_image
-- }}}

-- {{{ Util
local themes_path = os.getenv('HOME') .. '/.config/awesome/themes/'

local theme = {}
-- }}}

-- {{{ Colors
local colors = {
    -- Gray
    gray1  = '#2b3339',
    gray2  = '#323c41',
    gray3  = '#3a454a',
    gray4  = '#445055',
    gray5  = '#607279',
    gray6  = '#7a8487',
    gray7  = '#859289',

    -- Foreground
    white  = '#d3c6aa',

    -- Other colors
    red    = '#e67e80',
    orange = '#e69875',
    yellow = '#ddbc7f',
    green  = '#a7c080',
    teal   = '#83c092',
    blue   = '#7fbbb3',
    purple = '#d699b6',
}

theme.colorscheme = colors
-- }}}

-- {{{ Font(s)
theme.font          = 'JetBrainsMono Nerd Font Bold 10'
-- }}}

-- {{{ Background
theme.bg_normal          = colors.gray1
theme.bg_focus           = colors.blue
theme.bg_urgent          = colors.red
theme.bg_minimize        = colors.gray3
theme.bg_systray         = colors.gray3
-- }}}

-- {{{ Foreground
theme.fg_normal          = colors.white
theme.fg_focus           = colors.gray1
theme.fg_urgent          = colors.gray1
theme.fg_minimize        = colors.gray5
theme.fg_minimize_2      = colors.gray4
theme.fg_minimize_3      = colors.gray3
-- }}}

-- {{{ Gaps/Borders
theme.useless_gap   = dpi(4)
theme.border_width  = dpi(0)
theme.border_normal = colors.gray3
theme.border_focus  = colors.blue
theme.border_marked = colors.red
-- }}}

-- {{{ Hotkeys popup
theme.hotkeys_modifiers_fg = colors.gray5
theme.hotkeys_border_width = dpi(2)
theme.hotkeys_border_color = colors.blue
-- }}}

-- {{{ Window switcher
theme.window_switcher_widget_bg = colors.gray2                       -- The bg color of the widget
theme.window_switcher_widget_border_width = 2                        -- The border width of the widget
theme.window_switcher_widget_border_radius = 0                       -- The border radius of the widget
theme.window_switcher_widget_border_color = colors.gray3             -- The border color of the widget
theme.window_switcher_clients_spacing = 8                            -- The space between each client item
theme.window_switcher_client_icon_horizontal_spacing = 6             -- The space between client icon and text
theme.window_switcher_client_width = 400                             -- The width of one client widget
theme.window_switcher_client_height = 36                             -- The height of one client widget
theme.window_switcher_client_margins = 12                            -- The margin between the content and the border of the widget
theme.window_switcher_thumbnail_margins = 6                          -- The margin between one client thumbnail and the rest of the widget
theme.thumbnail_scale = false                                        -- If set to true, the thumbnails fit policy will be set to 'fit' instead of 'auto'
theme.window_switcher_name_margins = 6                               -- The margin of one clients title to the rest of the widget
theme.window_switcher_name_valign = 'center'                         -- How to vertically align one clients title
theme.window_switcher_name_forced_width = 350                        -- The width of one title
theme.window_switcher_name_font = 'JetBrainsMono Nerd Font Bold 10'  -- The font of all titles
theme.window_switcher_name_normal_color = colors.white               -- The color of one title if the client is unfocused
theme.window_switcher_name_focus_color = colors.blue                 -- The color of one title if the client is focused
theme.window_switcher_icon_valign = 'center'                         -- How to vertically align the one icon
theme.window_switcher_icon_width = 30                                -- The width of one icon
-- }}}

-- {{{ Playerctl
-- theme.playerctl_player = { 'spotify', '%any' }
theme.playerctl_player = { 'mpv', 'spotify', '%any' }
theme.playerctl_update_on_activity = false
-- }}}

-- {{{ Notifications
-- Settings for legacy notifications
naughty.config.padding = dpi(16)
naughty.config.spacing = dpi(8)
naughty.config.defaults.icon_size = dpi(48)
naughty.config.defaults.margin = dpi(12)
naughty.config.defaults.border_width = dpi(2)

-- Constraints
theme.notification_max_width = dpi(640)

-- Icon scale
theme.notification_icon_size = dpi(48)
theme.notification_icon_resize_strategy = 'scale'

-- Padding and spacing
theme.notification_padding = dpi(16)
theme.notification_margin = dpi(12)
theme.notification_spacing = dpi(16)
theme.notification_action_spacing = 0
theme.notification_text_spacing = 0

-- Border
theme.notification_border_color = colors.gray3
theme.notification_border_width = 0

-- Background
theme.notification_bg = colors.gray2

-- Fonts (text weight)
theme.notification_font         = theme.font
theme.notification_font_title   = theme.font
theme.notification_font_message = theme.font:gsub('Bold', 'Normal')
-- }}}

-- {{{ Menu
theme.menu_submenu_icon = themes_path..'default/icons/misc/submenu.png'
theme.menu_height = dpi(15)
theme.menu_width  = dpi(125)
theme.menu_border_width = 0
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
-- theme.tasklist_sticky = ''
-- theme.tasklist_ontop = 'ﱢ '
-- theme.tasklist_above = 'ﲗ '
-- theme.tasklist_below = 'ﲔ '
-- theme.tasklist_floating = 'ﰉ '
-- theme.tasklist_maximized = ' '
-- theme.tasklist_maximized_horizontal = ' '
-- theme.tasklist_maximized_vertical = ''
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

tasklist_base_icons.floating     = themes_path..'default/icons/tasklist/floating.svg'
tasklist_base_icons.max          = themes_path..'default/icons/tasklist/max.svg'
tasklist_base_icons.max_horiz    = themes_path..'default/icons/tasklist/max_horiz.svg'
tasklist_base_icons.max_vert     = themes_path..'default/icons/tasklist/max_vert.svg'
tasklist_base_icons.ontop        = themes_path..'default/icons/tasklist/ontop.svg'
tasklist_base_icons.min          = themes_path..'default/icons/tasklist/min.svg'
tasklist_base_icons.sticky       = themes_path..'default/icons/tasklist/sticky.svg'

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

-- {{{ Taglist icons
theme.geolist_style = {
    empty = {
        shape = function(cr, w, h)
            -- 360 degree arc (hollow circ)
            return shape.arc(cr, w, h, dpi(2), 0, math.pi * 2)
        end,
        fg = colors.gray5,
        bg = colors.gray3,
    },

    occupied = {
        shape = shape.circle,
        fg = colors.white,
        bg = colors.gray3,
    },

    selected = {
        shape = shape.losange,
        fg = colors.gray1,
        bg = colors.blue,
    },

    urgent = {
        shape = shape.isosceles_triangle,
        fg = colors.gray1,
        bg = colors.red,
    },

    volatile = {
        shape = shape.rectangle,
        fg = colors.gray1,
        bg = colors.yellow,
    },
}
-- }}}

-- {{{ Titlebars
-- Should focused titlebars be colored?
local focus_highlight = false

-- BG and FG colors
theme.titlebar_fg_focus  = (focus_highlight and colors.gray1 or colors.white)
theme.titlebar_bg_normal = colors.gray3
theme.titlebar_bg_focus  = (focus_highlight and colors.blue  or colors.gray3)

-- Buttons
-- {{{ Left buttons
theme.titlebar_sticky_button_normal_inactive = shape_load(dpi(10), dpi(10), shape.losange, colors.purple)
theme.titlebar_sticky_button_focus_inactive  = shape_load(dpi(10), dpi(10), shape.losange, (focus_highlight and colors.gray1 or colors.purple))
theme.titlebar_sticky_button_normal_active = shape_load(dpi(10), dpi(10), shape.rectangle, colors.purple)
theme.titlebar_sticky_button_focus_active  = shape_load(dpi(10), dpi(10), shape.rectangle, (focus_highlight and colors.gray1 or colors.purple))

theme.titlebar_floating_button_normal_inactive = shape_load(dpi(10), dpi(10), shape.isosceles_triangle, colors.blue)
theme.titlebar_floating_button_focus_inactive  = shape_load(dpi(10), dpi(10), shape.isosceles_triangle, (focus_highlight and colors.gray1 or colors.blue))

theme.titlebar_floating_button_normal_active = shape_load(
    dpi(10), dpi(10),
    shape.transform(shape.isosceles_triangle)
    :rotate_at(dpi(5), dpi(5), math.pi),
    colors.blue
)
theme.titlebar_floating_button_focus_active  = shape_load(
    dpi(10), dpi(10),
    shape.transform(shape.isosceles_triangle)
    :rotate_at(dpi(5), dpi(5), math.pi),
    (
        focus_highlight and colors.gray1 or colors.blue
    )
)
-- }}}

-- {{{ Right buttons
theme.titlebar_close_button_normal = shape_load(dpi(10), dpi(10), shape.circle, colors.red)
theme.titlebar_close_button_focus  = shape_load(dpi(10), dpi(10), shape.circle, (focus_highlight and colors.gray1 or colors.red))

theme.titlebar_minimize_button_normal = shape_load(
    dpi(10), dpi(10),
    shape.transform(shape.isosceles_triangle)
    :rotate_at(dpi(5), dpi(5), math.pi),
    colors.yellow
)
theme.titlebar_minimize_button_focus  = shape_load(
    dpi(10), dpi(10),
    shape.transform(shape.isosceles_triangle)
    :rotate_at(dpi(5), dpi(5), math.pi),
    (
        focus_highlight and colors.gray1 or colors.yellow
    )
)

theme.titlebar_maximized_button_normal_inactive = shape_load(dpi(10), dpi(10), shape.losange, colors.green)
theme.titlebar_maximized_button_focus_inactive  = shape_load(dpi(10), dpi(10), shape.losange, (focus_highlight and colors.gray1 or colors.green))
theme.titlebar_maximized_button_normal_active   = shape_load(dpi(10), dpi(10), shape.losange, colors.green)
theme.titlebar_maximized_button_focus_active    = shape_load(dpi(10), dpi(10), shape.losange, (focus_highlight and colors.gray1 or colors.teal))
-- }}}

-- {{{ Unused
theme.titlebar_ontop_button_normal_inactive = shape_load(dpi(10), dpi(10), shape.isosceles_triangle, colors.orange)
theme.titlebar_ontop_button_focus_inactive  = shape_load(dpi(10), dpi(10), shape.isosceles_triangle, (focus_highlight and colors.gray1 or colors.orange))

theme.titlebar_ontop_button_normal_active = shape_load(
    dpi(10), dpi(10),
    shape.transform(shape.isosceles_triangle)
    :rotate_at(dpi(5), dpi(5), math.pi),
    colors.orange
)
theme.titlebar_ontop_button_focus_active  = shape_load(
    dpi(10), dpi(10),
    shape.transform(shape.isosceles_triangle)
    :rotate_at(dpi(5), dpi(5), math.pi),
    (
        focus_highlight and colors.gray1 or colors.orange
    )
)
-- }}}
-- }}}

-- {{{ Layout icons
theme.layout_fairv = themes_path..'default/icons/layouts/fairv.png'
theme.layout_floating  = themes_path..'default/icons/layouts/floating.png'
theme.layout_tile = themes_path..'default/icons/layouts/tile.png'
theme.layout_spiral  = themes_path..'default/icons/layouts/spiral.png'
theme.layout_dwindle = themes_path..'default/icons/layouts/dwindle.png'
-- }}}

-- {{{ Wibar icons
-- Playerctl
theme.playerctl_shuffle_off = recolor(themes_path..'default/icons/media/mdi-shuffle-off.svg', colors.gray1)
theme.playerctl_shuffle     = recolor(themes_path..'default/icons/media/mdi-shuffle.svg',     colors.gray1)

theme.playerctl_previous    = recolor(themes_path..'default/icons/media/fa-previous.svg',     colors.gray1)
theme.playerctl_play        = recolor(themes_path..'default/icons/media/fa-play.svg',         colors.gray1)
theme.playerctl_pause       = recolor(themes_path..'default/icons/media/fa-pause.svg',        colors.gray1)
theme.playerctl_next        = recolor(themes_path..'default/icons/media/fa-next.svg',         colors.gray1)

theme.playerctl_loop_off    = recolor(themes_path..'default/icons/media/mdi-loop-off.svg',    colors.gray1)
theme.playerctl_loop_one    = recolor(themes_path..'default/icons/media/mdi-loop-one.svg',    colors.gray1)
theme.playerctl_loop        = recolor(themes_path..'default/icons/media/mdi-loop.svg',        colors.gray1)

-- Textclock
theme.textclock_icon = recolor(themes_path..'default/icons/datetime/fa-clock.svg', colors.gray1)

-- Battery
local battery_icons = {
    charging = {},
    discharging = {},
}

for i = 1, 10, 1 do
    battery_icons.charging[i] = recolor(themes_path..'default/icons/sysinfo/battery/mdi-battery-charging-'..i..'0.svg', colors.gray1)
    battery_icons.discharging[i] = recolor(themes_path..'default/icons/sysinfo/battery/mdi-battery-'..i..'0.svg', colors.gray1)
end

theme.battery_icons = battery_icons

-- CPU
theme.sysinfo_cpu_icon = recolor(themes_path..'default/icons/sysinfo/fa-cpu.svg', colors.gray1)

-- Memory
theme.sysinfo_mem_icon = recolor(themes_path..'default/icons/sysinfo/fa-mem.svg', colors.gray1)
-- }}

-- {{{ Misc icons
-- Awesome icons
theme.awesome_icon = theme_assets.awesome_icon(64, theme.bg_focus, theme.fg_focus)
theme.awesome_icon_alt = themes_path..'default/icons/misc/awesome-icon-largegap.png'
-- }}}
-- }}}

-- {{{ Wallpaper
-- Whether or not to select a random wallpaper
theme.random_wallpaper = false

-- {{{ Manual selection of wallpapers
-- theme.wallpaper        = themes_path .. 'default/walls/car.png'
-- theme.wallpaper        = themes_path .. 'default/walls/stairs.jpg'
-- theme.wallpaper        = themes_path .. 'default/walls/fog_forest.jpg'
-- theme.wallpaper        = themes_path .. 'default/walls/flowers.png'
-- theme.wallpaper        = themes_path .. 'default/walls/waves.png'
theme.wallpaper        = themes_path .. 'default/walls/rocky_beach.png'
-- }}}

-- Wallpaper path for randomized wallpapers
theme.wallpaper_path   = themes_path .. 'default/walls/'

-- Position and scale
theme.wallpaper_position = 'fit' -- Can be one of 'centered' 'fit' 'maximized' or 'tiled'
theme.wallpaper_scale    = 1
-- }}}

-- {{{ Other
-- Icon theme
theme.icon_theme = nil
-- }}}

-- {{{ Return
return theme

-- vim: filetype=lua:expandtab:shiftwidth=4:tabstop=8:softtabstop=4:textwidth=80
-- }}}
