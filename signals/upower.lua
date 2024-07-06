local upower = require('lgi').UPowerGlib
local States = upower.DeviceState

local util = require('util')

local M = {}

local function signal(dev)
	awesome.emit_signal('upower::update', dev)
	-- TODO: notifications?
end

local function hr_min_sec(as)
	local am = math.floor(as / 60)
	local h = math.floor(am / 60)
	local m = am % 60
	local s = as % 60

	return h, m, s
end

function M.init()
	local dev = upower.Client():get_display_device()
	dev.on_notify = signal

	require('gears').timer.delayed_call(function()
		signal(dev)
	end)
end

function M.is_charging(dev)
	if dev.state == States.CHARGING then
		return true
	elseif dev.state == States.DISCHARGING then
		return false
	else
		return nil
	end
end

function M.is_plugged_in(dev)
	return dev.state == States.CHARGING or dev.state == States.PENDING_CHARGE
end

function M.time_to_full(dev)
	return hr_min_sec(dev.time_to_full)
end

function M.time_to_empty(dev)
	return hr_min_sec(dev.time_to_empty)
end

return M
