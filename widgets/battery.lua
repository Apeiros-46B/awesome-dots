local awful = require('awful')
local wibox = require('wibox')

-- local upower = require('lgi').require('UPowerGlib')

local theme = require('beautiful').get()
local dpi = require('beautiful.xresources').apply_dpi

local battery = wibox.widget {
	layout = wibox.container.rotate,
	direction = 'east',
	forced_height = dpi(256),
	{
		id = 'battery',
		widget = wibox.widget.progressbar,
		background_color = theme.colors.bg4,
		color = theme.colors.green,
		max_value = 100,
		value = 100,
	}
}

-- TODO: switch to upowerd instead of watching acpi
awful.widget.watch('acpi', 10, function(_, stdout)
	local remaining = tonumber(string.match(stdout, '(%d?%d?%d)%%'))
	local status = string.match(stdout, ': (%w+)')

	local bar = battery:get_children_by_id('battery')[1]
	bar.value = remaining

	if status ~= "Discharging" then
		bar.color = theme.colors.purple
	elseif remaining <= 20 then
		bar.color = theme.colors.red
	elseif remaining <= 30 then
		bar.color = theme.colors.orange
	elseif remaining <= 40 then
		bar.color = theme.colors.yellow
	else
		bar.color = theme.colors.green
	end
end)

return battery
