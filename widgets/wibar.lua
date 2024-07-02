local awful = require('awful')
local wibox = require('wibox')

local theme = require('beautiful').get()

return function(s)
	local taglist = require('widgets.taglist')(s)
	local battery = require('widgets.battery')

	s.wibar = awful.wibar {
		position = 'left',
		width    = theme.useless_gap * 2,
		screen   = s,
		widget   = {
			layout = wibox.layout.align.vertical,
			taglist, -- top
			nil,     -- center
			battery, -- bottom
		},
	}
end
