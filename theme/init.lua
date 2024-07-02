local dpi = require('beautiful.xresources').apply_dpi

local theme = {}

local cfg = require('theme.config')

theme.settings = cfg.settings
theme.colors = cfg.colors
theme.keys = cfg.keys

theme.useless_gap  = dpi(4)
theme.border_width = 0

theme.bg_normal = theme.colors.bg1
theme.taglist_bg_focus = theme.colors.blue
theme.taglist_bg_urgent = theme.colors.red
theme.taglist_bg_occupied = theme.colors.bg3
theme.taglist_bg_empty = theme.colors.bg3

theme.wallpaper = os.getenv('HOME') .. '/.config/awesome/wallpapers/foggy_valley.png'

require('beautiful').init(theme)
