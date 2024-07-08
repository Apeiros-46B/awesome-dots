local dpi = require('beautiful.xresources').apply_dpi
local cfg = require('theme.config')

local theme = {}

theme.colors = cfg.colors
theme.gaps = cfg.sizes.gaps

theme.settings = cfg.settings
theme.keys = cfg.keys

-- custom
theme.bar_thickness = theme.gaps.m

theme.taglist = {
	gap = theme.gaps.xs,
	bar_length = dpi(41),
}
-- total height = bar_length * 8 + gap * 7 (try to keep consistent with clock)

theme.battery_height = dpi(200)

theme.clock = {
	empty_color = theme.colors.bg3,
	filled_color = theme.colors.fg2,
	battery_time_to_full_color = theme.colors.green,
	battery_time_to_empty_color = theme.colors.red,

	bar_length = dpi(25),
	tick_thickness = theme.gaps.xs,
	gap = theme.gaps.xs,
	large_gap = theme.gaps.m,
}
theme.clock.total_height = theme.clock.bar_length * 12 + theme.clock.gap * 20

theme.osd_width = dpi(200)

-- awesome themevars
theme.font = 'JetBrainsMono Nerd Font Mono Semibold 10'
theme.font_bold = 'JetBrainsMono Nerd Font Mono Bold 10'
theme.useless_gap  = theme.gaps.s
theme.border_width = 0

theme.bg_normal = theme.colors.bg1
theme.fg_normal = theme.colors.fg1
theme.fg_faded = theme.colors.fg2

theme.taglist_bg_focus = theme.colors.blue
theme.taglist_bg_urgent = theme.colors.red
theme.taglist_bg_occupied = theme.colors.fg2
theme.taglist_bg_empty = theme.colors.bg3

theme.notification_margin = theme.gaps.l
theme.notification_spacing = theme.gaps.xl
theme.notification_padding = theme.gaps.xl
theme.notification_border_width = 0

theme.hotkeys_modifiers_fg = theme.colors.fg2
theme.hotkeys_label_fg = theme.colors.bg1
theme.hotkeys_label_bg = theme.colors.blue
theme.hotkeys_border_width = theme.gaps.m
theme.hotkeys_border_color = theme.bg_normal

require('beautiful').init(theme)
