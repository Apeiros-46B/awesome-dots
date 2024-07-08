local awful = require('awful')
local gears = require('gears')
local wibox = require('wibox')

local theme = require('beautiful').get()

local M = {}

function M.init(s)
	local volume = require('widgets.osd.volume')

	s.osd = awful.popup {
		screen    = s,
		placement = function(drawable, args)
			gears.table.crush(args, {
				margins = {
					top = theme.gaps.xl
				}
			})
			return awful.placement.top(drawable, args)
		end,
		visible   = false,
		ontop     = true,

		input_passthrough = true,

		-- TODO: switch between volume and brightness slider
		widget = volume.widget,
	}

	local hide_timer = gears.timer {
		timeout = 2,
		autostart = false,
		call_now = false,
		single_shot = true,
		callback = function()
			s.osd.visible = false
		end,
	}

	local function show_osd()
		s.osd.visible = true
		hide_timer:again()
	end

	volume.register_osd_signal(show_osd)
end

return M
