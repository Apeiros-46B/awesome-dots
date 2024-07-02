-- autoload luarocks modules
pcall(require, 'luarocks.loader')

local naughty = require('naughty')
local beautiful = require('beautiful')

naughty.connect_signal('request::display_error', function(message, startup)
	naughty.notification {
		urgency = 'critical',
		title   = 'ERROR' .. (startup and ' [during startup]:' or ':'),
		message = message
	}
end)

beautiful.init(os.getenv('HOME') .. '/.config/awesome/theme.lua')
SETTINGS = {
	mod = 'Mod4',
	term = 'st',
	editor = 'nvim',
}
K = {
	mod = SETTINGS.mod,
	alt = 'Mod1',
	ctrl = 'Control',
	shift = 'Shift',

	tab = 'Tab',
	spc = 'Space',
	esc = 'Escape',
	ret = 'Return',
}

require('screen')

require('binds')

require('misc')

-- TODO: rules

-- TODO: notifications
