-- TODO: sink switching
local awful = require('awful')

local util = require('util')

local M = {}

local volume = -1
local muted = false

local function signal()
	awesome.emit_signal('pactl::volume', volume, muted)
end

-- local sinks_set = {}
-- local sinks = {}
-- local sink = ''

-- local function get_default_sink()
-- 	awful.spawn.easy_async('pactl get-default-sink', function(name)
-- 		sink = name
-- 	end)
-- end

-- local function with_sinks(callback)
-- 	local prev_sink = sink
-- 	sinks = {}

-- 	awful.spawn.with_line_callback('pactl list short sinks', {
-- 		stdout = function(line)
-- 			local sink_name = line:match('^%d+\9([^\9]+)')
-- 			sinks[#sinks+1] = sink
-- 			sinks_set[sink_name] = #sinks
-- 		end,
-- 		exit = function(_, _)
-- 			if sinks_set[prev_sink] then
-- 				sink = prev_sink
-- 			else
-- 				get_default_sink()
-- 			end
-- 			callback()
-- 		end,
-- 	})
-- end

function M.init()
	local first = true
	awful.spawn.with_line_callback('wpctl get-volume @DEFAULT_SINK@', {
		stdout = function(line)
			if not first then
				return
			end

			volume = tonumber(line:match('(%d%.%d+)')) * 100
			muted = line:match('MUTED') and true or false

			first = false
		end,
	})
end

-- TODO: after externally switching sink, the volume is different
function M.set_volume(delta)
	volume = util.clamp(volume + delta, 0, 100)
	awful.spawn(('wpctl set-volume @DEFAULT_SINK@ %d%%'):format(volume), false)
	signal()
end

function M.inc_volume()
	M.set_volume(5)
end

function M.dec_volume()
	M.set_volume(-5)
end

function M.mute()
	muted = not muted
	awful.spawn('wpctl set-mute @DEFAULT_SINK@ toggle', false)
	signal()
end

-- function M.select_sink_relative(delta)
-- 	with_sinks(function()

-- 	end)
-- end

return M
