local M = {}

M.brightnessctl = require('lib.brightnessctl')
M.calendar = require('lib.calendar')
M.pactl = require('lib.pactl')
M.upower = require('lib.upower')

function M.init()
	M.brightnessctl.init()
	M.calendar.init()
	M.pactl.init()
	M.upower.init()
end

return M
