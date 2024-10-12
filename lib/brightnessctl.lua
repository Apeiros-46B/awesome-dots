local awful = require('awful')

local util = require('util')

local M = {}

local brightness = 50

local function signal()
	awesome.emit_signal('brightnessctl::brightness', brightness)
end

function M.init()
	awful.spawn.easy_async('brightnessctl i -m', function(stdout)
		brightness = tonumber(stdout:match('(%d+)%%')) --[[@as number]]
	end)
end

function M.set_brightness(delta)
	brightness = util.clamp(brightness + delta, 5, 100)
	awful.spawn(('brightnessctl s -q %d%%'):format(brightness), false)
	signal()
end

function M.inc_brightness()
	M.set_brightness(5)
end

function M.dec_brightness()
	M.set_brightness(-5)
end

return M
