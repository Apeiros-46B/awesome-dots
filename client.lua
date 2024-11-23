require('awful.autofocus')

local awful = require('awful')
local ruled = require('ruled')

ruled.client.connect_signal('request::rules', function()
	ruled.client.append_rule {
		id = 'global',
		rule = {},
		properties = {
			raise = true,
			focus = awful.client.focus.filter,
			screen = awful.screen.preferred,
			placement = awful.placement.no_overlap + awful.placement.no_offscreen,
		},
	}

	-- urxvt free size
	ruled.client.append_rule {
		rule_any = { class = { 'URxvt' } },
		properties = { size_hints_honor = false },
	}

	-- mouse floating
	ruled.client.append_rule {
		rule_any = {
			class = {
				'Dragon',
				'mpv',
				'qalculate',
			},
		},
		properties = {
			floating = true,
			ontop = true,
			placement = awful.placement.under_mouse,
		},
	}

	-- center floating
	ruled.client.append_rule {
		rule_any = {
			class = {
				'Gcr-prompter',
			}
		},
		properties = {
			floating = true,
			ontop = true,
			placement = awful.placement.centered
		},
	}

	-- sticky
	ruled.client.append_rule {
		rule_any = {
			class = {
				'Dragon',
				'qalculate',
			}
		},
		properties = {
			sticky = true,
		},
	}
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
