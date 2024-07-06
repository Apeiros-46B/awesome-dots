local wibox = require('wibox')

local theme = require('beautiful').get()

local upower = require('signals.upower')

local battery = wibox.widget {
	layout = wibox.container.rotate,
	direction = 'east',
	forced_height = theme.battery_height,

	{
		id = 'battery',
		widget = wibox.widget.progressbar,

		background_color = theme.colors.bg3,
		color = theme.colors.green,

		max_value = 100,
		value = 100,
	}
}

awesome.connect_signal('upower::update', function(dev)
	local amt = dev.percentage

	local bar = battery:get_children_by_id('battery')[1]
	bar.value = amt

	if upower.is_plugged_in(dev) then
		bar.color = theme.colors.purple
	elseif amt <= 20 then
		bar.color = theme.colors.red
	elseif amt <= 30 then
		bar.color = theme.colors.orange
	elseif amt <= 40 then
		bar.color = theme.colors.yellow
	else
		bar.color = theme.colors.green
	end
end)

return battery
