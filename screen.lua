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
	require('widgets').init(s)
end)

screen.connect_signal('request::wallpaper', function(s)
	awful.wallpaper {
		screen = s,
		widget = {
			widget = wibox.widget.imagebox,
			image  = theme.settings.wallpaper,
			resize = true,
		},
	}
end)
