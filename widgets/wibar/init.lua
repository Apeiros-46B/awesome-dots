local awful = require('awful')
local wibox = require('wibox')

local theme = require('beautiful').get()

local M = {}

function M.init(s)
	local taglist = require('widgets.wibar.taglist')(s)
	local battery = require('widgets.wibar.battery')
	local clock = require('widgets.wibar.clock')

	s.wibar = awful.wibar {
		screen   = s,
		position = 'left',
		width    = theme.bar_thickness,
		widget   = {
			layout = wibox.layout.align.vertical,
			expand = 'none',

			taglist, -- top
			battery, -- center
			clock,   -- bottom
		},
	}
end

function M.toggle()
	for s in screen do
		s.wibar.visible = not s.wibar.visible
	end
end

return M
