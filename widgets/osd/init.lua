local awful = require('awful')
local gears = require('gears')
local wibox = require('wibox')

local M = {}

local function rot(widget)
	return wibox.widget {
		widget = wibox.container.rotate,
		direction = 'east',
		widget
	}
end

function M.init(s)
	local volume = require('widgets.osd.volume')
	local brightness = require('widgets.osd.brightness')

	s.osd = awful.popup {
		screen    = s,
		placement = awful.placement.left,
		visible   = false,
		ontop     = true,

		input_passthrough = true,

		widget = rot(volume.widget),
	}

	local hide_timer = gears.timer {
		timeout = 1,
		autostart = false,
		call_now = false,
		single_shot = true,
		callback = function()
			for scr in screen do
				scr.osd.visible = false
			end
		end,
	}

	local function show_osd(widget)
		awful.screen.focused().osd.widget = rot(widget)
		awful.screen.focused().osd.visible = true
		hide_timer:again()
	end

	volume.register_osd_signal(show_osd)
	brightness.register_osd_signal(show_osd)
end

return M
