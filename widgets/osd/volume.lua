local wibox = require('wibox')

local theme = require('beautiful').get()

local M = {}

M.widget = wibox.widget {
	widget = wibox.widget.progressbar,
	forced_height = theme.gaps.m,
	forced_width = theme.osd_width,

	background_color = theme.colors.bg3,
	color = theme.colors.green,

	max_value = 100,
	value = 100,
}

function M.register_osd_signal(show_callback)
	awesome.connect_signal('pactl::volume', function(volume, muted)
		M.widget.value = volume

		if muted then
			M.widget.color = theme.colors.fg2
		else
			M.widget.color = theme.colors.green
		end

		show_callback()
	end)
end

return M
