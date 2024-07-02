local M = {}

M.settings = {
	mod = 'Mod4',
	term = 'st',
	editor = 'nvim',
	gui_editor = "emacsclient -a '' -c"
}
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
M.keys = {
	sup = M.settings.mod,
	alt = 'Mod1',
	ctl = 'Control',
	sft = 'Shift',

	tab = 'Tab',
	spc = 'Space',
	esc = 'Escape',
	ret = 'Return',
}

return M
