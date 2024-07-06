local awful = require('awful')
local wibox = require('wibox')

local theme = require('beautiful').get()

tag.connect_signal('request::default_layouts', function()
	awful.layout.append_default_layouts {
		awful.layout.suit.tile,
		awful.layout.suit.floating,
	}
end)

screen.connect_signal('request::desktop_decoration', function(s)
	awful.tag({ '1', '2', '3', '4', '5', '6', '7', '8' }, s, awful.layout.layouts[1])
	require('widgets.wibar')(s)

	-- TODO: dashboard widget
end)

screen.connect_signal('request::wallpaper', function(s)
	awful.wallpaper {
		screen = s,
		widget = {
			image     = theme.wallpaper,
			resize    = true,
			horizontal_fit_policy = 'fit',
			widget    = wibox.widget.imagebox,
		},
	}
end)
