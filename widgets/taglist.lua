local awful = require('awful')
local wibox = require('wibox')

local dpi = require('beautiful.xresources').apply_dpi

return function(s)
	return awful.widget.taglist {
		screen = s,
		filter = awful.widget.taglist.filter.all,
		layout = {
			spacing = dpi(4),
			layout = wibox.layout.fixed.vertical,
		},
		widget_template = {
			id     = 'background_role',
			layout = wibox.container.background,
			{
				nil,
				top  = dpi(16),
				bottom = dpi(16),
				layout = wibox.container.margin
			},
		},
	}
end
