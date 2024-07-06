local awful = require('awful')
local wibox = require('wibox')

local theme = require('beautiful').get()

return function(s)
	local taglist = require('widgets.wibar.taglist')(s)
	local battery = require('widgets.wibar.battery')
	local clock = require('widgets.wibar.clock')

	s.wibar = awful.wibar {
		position = 'left',
		width    = theme.bar_thickness,
		screen   = s,
		widget   = {
			layout = wibox.layout.align.vertical,
			expand = 'none',

			taglist, -- top
			battery, -- center
			clock,   -- bottom
		},
	}
end
