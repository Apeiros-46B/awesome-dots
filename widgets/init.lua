local dashboard = require('widgets.dashboard')
local osd = require('widgets.osd')
local wibar = require('widgets.wibar')

local M = {
	dashboard = dashboard,
	osd = osd,
	wibar = wibar,
}

function M.init(s)
	M.dashboard.init(s)
	M.osd.init(s)
	M.wibar.init(s)
end

return M
