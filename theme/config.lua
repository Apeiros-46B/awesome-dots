local dpi = require('beautiful.xresources').apply_dpi

local M = {}

M.colors = {
	bg1 = '#2b3339',
	bg2 = '#323c41',
	bg3 = '#3a454a',
	bg4 = '#445055',

	fg1 = '#d3c6aa',
	fg2 = '#859289',

	red    = '#e67e80',
	orange = '#e69875',
	yellow = '#dbbc7f',
	green  = '#a7c080',
	aqua   = '#83c092',
	blue   = '#7fbbb3',
	purple = '#d699b6',
}
M.sizes = {
	gaps = {
		xs = 2,
		s = 4,
		m = 8,
		l = 12,
		xl = 16,
		xxl = 32,
	},
}
for k, v in pairs(M.sizes.gaps) do
	M.sizes.gaps[k] = dpi(v)
end

M.settings = {
	mod = 'Mod4',
	term = 'st',
	editor = 'nvim',
	gui_editor = "emacsclient -a '' -c",
	wallpaper = os.getenv('HOME') .. '/.config/awesome/theme/wallpapers/foggy_valley.png',

	-- TODO: make this take a data directory instead
	-- then we can have another file for todos
	calendar_path = os.getenv('HOME') .. '/.awesome_calendar',
}
M.keys = {
	sup = M.settings.mod,
	alt = 'Mod1',
	ctl = 'Control',
	sft = 'Shift',

	tab = 'Tab',
	spc = 'space',
	esc = 'Escape',
	ret = 'Return',
}

return M
