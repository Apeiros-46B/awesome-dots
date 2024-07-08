local awful = require('awful')
local wibox = require('wibox')

local theme = require('beautiful').get()

return function(s)
	return awful.widget.taglist {
		screen = s,
		filter = awful.widget.taglist.filter.all,
		layout = {
			spacing = theme.gaps.xs,
			layout  = wibox.layout.fixed.vertical,
		},

		widget_template = {
			id     = 'background_role',
			widget = wibox.container.background,

			{
				widget = wibox.container.margin,
				top    = theme.taglist.bar_length,
				nil,
			},
		},
	}
end
