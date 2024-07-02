local awful = require('awful')
local wibox = require('wibox')
local beautiful = require('beautiful')

tag.connect_signal('request::default_layouts', function()
	awful.layout.append_default_layouts {
		awful.layout.suit.tile,
		awful.layout.suit.floating,
	}
end)

screen.connect_signal('request::desktop_decoration', function(s)
	awful.tag({ '1', '2', '3', '4', '5', '6', '7', '8' }, s, awful.layout.layouts[1])

	-- TODO: separate widget into separate file
	s.wibar = awful.wibar {
		position = 'bottom',
		screen   = s,
		widget   = {
			layout = wibox.layout.align.horizontal,
			-- left
			{
				layout = wibox.layout.fixed.horizontal,

				awful.widget.taglist {
					screen = s,
					filter = awful.widget.taglist.filter.all,
				},
			},
			nil,
			{
				layout = wibox.layout.fixed.horizontal,
				wibox.widget.textclock(),
			},
		},
	}
end)

screen.connect_signal('request::wallpaper', function(s)
	awful.wallpaper {
		screen = s,
		widget = {
			{
				image     = beautiful.wallpaper,
				upscale   = true,
				downscale = true,
				widget    = wibox.widget.imagebox,
			},
			valign = 'center',
			halign = 'center',
			tiled  = false,
			widget = wibox.container.tile,
		},
	}
end)
