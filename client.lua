require('awful.autofocus')

local awful = require('awful')
local ruled = require('ruled')

ruled.client.connect_signal('request::rules', function()
	ruled.client.append_rule {
		id = 'titlebars',
		rule_any = { type = { 'normal', 'dialog' } },
		properties = { titlebars_enabled = true },
	}
end)

client.connect_signal("request::titlebars", require('widgets.titlebar'))

-- focus-follows-mouse
client.connect_signal('mouse::enter', function(c)
	c:activate {
		context = 'mouse_enter',
		raise = false,
	}
end)

client.connect_signal('manage', function(c)
	c:move_to_screen(awful.screen.focused())

	-- put windows at the end instead of replacing main
	if not awesome.startup then awful.client.setslave(c) end

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
