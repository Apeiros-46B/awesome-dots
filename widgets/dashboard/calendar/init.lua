local wibox = require('wibox')

local theme = require('beautiful').get()

local M = {}

local function decorate_cell(widget, flag, date)
	
end

M.widget = wibox.widget {
	widget = wibox.container.margin,
	margins = theme.gaps.xl,
	{
		-- TODO: style this widget
		widget = wibox.widget.calendar.month,
		date = os.date('*t'),
		font = 'monospace 14',
	},
	-- TODO: add per-day events view
}

function M.pre_show()
	M.widget.children[1].date = os.date('*t')
end

return M
