local wibox = require('wibox')

local theme = require('beautiful').get()

local M = {}

local styles = {}
styles.month   = {
	padding      = 5,
	bg_color     = "#555555",
	border_width = 2,
}
styles.normal  = {}
styles.focus   = {
	fg_color = "#000000",
	bg_color = "#ff9800",
	markup   = function(t) return '<b>' .. t .. '</b>' end,
}
styles.header  = {
	fg_color = "#de5e1e",
	markup   = function(t) return '<b>' .. t .. '</b>' end,
}
styles.weekday = {
	fg_color = "#7788af",
	markup   = function(t) return '<b>' .. t .. '</b>' end,
}
local function decorate_cell(widget, flag, date)
	if flag == "monthheader" then
		flag = "header"
	end
	local props = {}
	if props.markup and widget.get_text and widget.set_markup then
		widget:set_markup(props.markup(widget:get_text()))
	end
	-- Change bg color for weekends
	local d = {year=date.year, month=(date.month or 1), day=(date.day or 1)}
	local weekday = tonumber(os.date("%w", os.time(d)))
	local default_bg = (weekday==0 or weekday==6) and "#232323" or "#383838"
	local ret = wibox.widget {
		{
			widget,
			margins = (props.padding or 2) + (props.border_width or 0),
			widget  = wibox.container.margin
		},
		border_width = 0,
		fg           = props.fg_color or "#d3c6aa",
		bg           = props.bg_color or "#323c41",
		widget       = wibox.container.background
	}
	return ret	
end

M.widget = wibox.widget {
	widget = wibox.container.margin,
	margins = theme.gaps.xl,
	{
		-- TODO: style this widget
		widget = wibox.widget.calendar.month,
		date = os.date('*t'),
		font = 'monospace 14',
		fn_embed = decorate_cell,
	},
	-- TODO: add per-day events view
}

function M.pre_show()
	M.widget.children[1].date = os.date('*t')
end

return M
