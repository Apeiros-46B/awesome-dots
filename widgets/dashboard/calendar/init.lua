local wibox = require('wibox')

local theme = require('beautiful').get()

-- TODO: update current date
local current_date = os.date('*t')

local calendar = wibox.widget {
	widget = wibox.container.margin,
	margins = theme.gaps.xl,
	{
		-- TODO: style this widget
		widget = wibox.widget.calendar.month,
		date = current_date,
		font = 'monospace 14',
	},
	-- TODO: add per-day events view
}

require('gears').timer {
	-- a day
	timeout = 24 * 60 * 60,
	autostart = true,
	call_now = true,
	callback = function()
		current_date = os.date('*t')
	end,
}

return calendar
