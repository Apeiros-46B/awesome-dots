local upower = require('lgi').UPowerGlib
local States = upower.DeviceState

local M = {}

local function signal(dev)
	awesome.emit_signal('upower::update', dev)
	-- TODO: notifications?
end

function M.init()
	local dev = upower.Client():get_display_device()
	dev.on_notify = signal

	local function signal_dev()
		signal(dev)
	end
	require('gears').timer.delayed_call(signal_dev)
	awesome.connect_signal('system::resume', signal_dev)
end

-- distinct from charging, battery may be full/at stop threshold (PENDING_CHARGE)
function M.is_plugged_in(dev)
	return dev.state == States.CHARGING or dev.state == States.PENDING_CHARGE
end

return M
