local theme = require('beautiful').get()

local M = {}

M.widget = require('wibox').widget(require('widgets.osd.bar')(theme.colors.aqua))

function M.register_osd_signal(show_callback)
	awesome.connect_signal('pactl::volume', function(volume, muted)
		M.widget.value = volume

		if muted then
			M.widget.color = theme.colors.fg2
		else
			M.widget.color = theme.colors.aqua
		end

		show_callback(M.widget)
	end)
end

return M
