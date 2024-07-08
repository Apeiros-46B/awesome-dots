require('awful.autofocus')

local awful = require('awful')
local ruled = require('ruled')

ruled.client.connect_signal('request::rules', function()
	-- TODO
end)

-- focus-follows-mouse
client.connect_signal('mouse::enter', function(c)
	c:activate {
		context = 'mouse_enter',
		raise = false,
	}
end)

client.connect_signal('manage', function(c)
	if not awesome.startup then
		-- move to focused screen
		c:move_to_screen(awful.screen.focused())

		-- put windows at the end instead of replacing main
		awful.client.setslave(c)
	end

	if awesome.startup
		and not c.size_hints.user_position
		and not c.size_hints.program_position then
		awful.placement.no_offscreen(c)
	end

	-- raise floating windows above others
	if c.floating then
		c.ontop = true
		c:raise()
	end

	c:activate({ raise = false, context = 'new client' })
end)
