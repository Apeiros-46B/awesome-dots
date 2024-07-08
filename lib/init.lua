local M = {}

M.pactl = require('lib.pactl')
M.upower = require('lib.upower')
M.calendar = require('lib.calendar')

function M.init()
	M.pactl.init()
	M.upower.init()
	M.calendar.init()
end

return M
