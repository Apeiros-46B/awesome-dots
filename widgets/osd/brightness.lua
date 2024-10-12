local theme = require('beautiful').get()

local M = {}

M.widget = require('wibox').widget(require('widgets.osd.bar')(theme.colors.yellow))

function M.register_osd_signal(show_callback)
	awesome.connect_signal('brightnessctl::brightness', function(brightness)
		M.widget.value = brightness
		show_callback(M.widget)
	end)
end

return M
