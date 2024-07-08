local awful = require('awful')
local wibox = require('wibox')

local theme = require('beautiful').get()

local M = {}

function M.init(s)
	s.dashboard = awful.popup {
		screen    = s,
		placement = awful.placement.centered,
		visible   = false,
		ontop     = true,

		widget = require('widgets.dashboard.calendar'),
		-- TODO: add todos view
	}
end

function M.show()
	awful.screen.focused().dashboard.visible = true
end

function M.hide()
	awful.screen.focused().dashboard.visible = false
end

function M.toggle()
	local d = awful.screen.focused().dashboard
	d.visible = not d.visible
end

return M
