local wibox = require('wibox')

local theme = require('beautiful').get()

return function(color)
	return {
		widget = wibox.widget.progressbar,
		forced_height = theme.gaps.m,
		forced_width = theme.osd_width,

		background_color = theme.colors.bg3,
		color = color,

		max_value = 100,
		value = 100,
	}
end
