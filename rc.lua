-- autoload luarocks modules
pcall(require, 'luarocks.loader')

-- notify on error
local naughty = require('naughty')
naughty.connect_signal('request::display_error', function(msg, startup)
	naughty.notification {
		urgency = 'critical',
		title   = 'ERROR' .. (startup and ' [during startup]:' or ':'),
		message = msg
	}
end)

require('theme')  -- theme & user settings
require('screen') -- wallpaper, bar, widgets, etc
require('notif')  -- notifications
require('binds')  -- key and mouse binds
require('rules')  -- client rules
require('misc')   -- misc
