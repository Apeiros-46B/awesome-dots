local awful = require('awful')
local wibox = require('wibox')

local theme = require('beautiful').get()

return function(c)
	local titlebar = awful.titlebar(c, {
		size = theme.useless_gap * 2,
		position = 'left',
		bg_normal = theme.colors.bg2,
		bg_focus = theme.colors.bg4,
		bg_urgent = theme.colors.red,
	})

	-- titlebar.widget = {
	-- 	layout = wibox.container.background,
	-- 	bg = theme.colors.bg3,
	-- }
end
