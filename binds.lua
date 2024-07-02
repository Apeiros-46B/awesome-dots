local awful = require('awful')

-- {{{ helpers
local function bind(keys, func, help_desc, help_group)
	local k = keys[#keys]
	table.remove(keys, #keys)
	return awful.key(keys, k, func, { description = help_desc, group = help_group })
end

local function bind_group(keys, f, help_desc, help_group)
	local group = keys[#keys]
	table.remove(keys, #keys)
	return awful.key {
		modifiers   = keys,
		keygroup    = group,
		description = help_desc,
		group       = help_group,
		on_press    = f,
	}
end

-- TODO: check pack/unpack behaviour
local function wrap(f, ...)
	local args = {...}
	return function()
		f(unpack(args))
	end
end
local function wrap_c(name, ...)
	local args = {...}
	return function(x)
		x[name](x, unpack(args))
	end
end
local function spawner(cmd)
	return wrap(awful.spawn, cmd)
end

local function move_or_swap(keys, dx, dy, dir, help_desc, help_group)
	return bind(
		keys,
		function(c)
			if c.floating then
				c:relative_move(dx, dy, 0, 0)
			else
				-- NOTE: replace with global if need multiple monitor
				awful.client.swap.bydirection(dir)
			end
		end,
		help_desc, help_group
	)
end
-- }}}

local theme = require('beautiful').get()
local settings = theme.settings
local k = theme.keys

awful.keyboard.append_global_keybindings {
	bind({ k.sup, k.sft, 'r' }, awesome.restart, 'reload wm', 'sys'),
	bind({ k.sup, k.ret }, spawner(settings.term), 'terminal', 'app'),
	bind({ k.sup, k.spc }, spawner('rofi -show run'), 'launcher', 'app'),
	bind({ k.sup, 'e' }, spawner(settings.gui_editor), 'editor', 'app'),

	-- {{{ tag
	bind(
		{ k.sup, 'y' },
		wrap(awful.layout.inc, 1),
		'switch layout', 'tag'
	),
	bind(
		{ k.sup, 'u' },
		awful.tag.viewnext,
		'switch layout', 'tag'
	),
	bind(
		{ k.sup, 'i' },
		awful.tag.viewprev,
		'switch layout', 'tag'
	),
	bind_group(
		{ k.sup, 'numrow' },
		function(i)
			local tag = awful.screen.focused().tags[i]
			if tag then
				tag:view_only()
			end
		end,
		'switch to', 'tag'
	),
	bind_group(
		{ k.sup, k.ctl, 'numrow' },
		function(i)
			local tag = awful.screen.focused().tags[i]
			if tag then
				awful.tag.viewtoggle(tag)
			end
		end,
		'toggle', 'tag'
	),
	bind_group(
		{ k.sup, k.sft, 'numrow' },
		function(i)
			local tag = awful.screen.focused().tags[i]
			if tag then
				client.focus:move_to_tag(tag)
			end
		end,
		'send client to', 'tag'
	),
	-- }}}

	-- {{{ client
	bind(
		{ k.sup, 'h' }, wrap(awful.client.focus.bydirection, 'left'),
		'focus left', 'client'
	),
	bind(
		{ k.sup, 'j' }, wrap(awful.client.focus.bydirection, 'down'),
		'focus down', 'client'
	),
	bind(
		{ k.sup, 'k' }, wrap(awful.client.focus.bydirection, 'up'),
		'focus up', 'client'
	),
	bind(
		{ k.sup, 'l' }, wrap(awful.client.focus.bydirection, 'right'),
		'focus right', 'client'
	),

	bind(
		{ k.sup, k.sft, 'm' },
		function()
			local c = awful.client.restore()
			if c then
				c:activate { raise = true, context = 'key.unminimize' }
			end
		end,
		'unminimize', 'client'
	),
	-- }}}
}

-- {{{ client-specific
client.connect_signal('request::default_keybindings', function()
	awful.keyboard.append_client_keybindings {
		bind({ k.sup, 'c' }, wrap_c('kill'), 'close', 'client'),
		bind(
			{ k.sup, 'm' },
			function(c)
				c.minimized = true
			end,
			'minimize', 'client'
		),
		bind(
			{ k.sup, k.ctl, 'm' },
			function(c)
				c.maximized = not c.maximized
				c:raise(0)
			end,
			'toggle maximize', 'client'
		),
		bind(
			{ k.sup, 'f' },
			function(c)
				c.fullscreen = not c.fullscreen
				c:raise()
			end,
			'toggle fullscreen', 'client'
		),
		bind(
			{ k.sup, k.sft, 'f' },
			function(c)
				c.floating = not c.floating
				c.ontop = c.floating
			end,
			'toggle floating', 'client'
		),

		move_or_swap(
			{ k.sup, k.sft, 'h' },
			-20, 0, 'left',
			'move left', 'client'
		),
		move_or_swap(
			{ k.sup, k.sft, 'j' },
			0, 20, 'down',
			'move down', 'client'
		),
		move_or_swap(
			{ k.sup, k.sft, 'k' },
			0, -20, 'up',
			'move up', 'client'
		),
		move_or_swap(
			{ k.sup, k.sft, 'l' },
			20, 0, 'right',
			'move right', 'client'
		),
	}
end)

client.connect_signal('request::default_mousebindings', function()
	awful.mouse.append_client_mousebindings {
		awful.button({}, 1, wrap_c('activate', { context = 'mouse_click' })),
		awful.button({ k.sup }, 1, wrap_c('activate', {
			context = 'mouse_click',
			action  = 'mouse_move',
		})),
		awful.button({ k.sup }, 2, wrap_c('activate', {
			context = 'mouse_click',
			action  = 'toggle_minimization',
		})),
		awful.button({ k.sup }, 3, wrap_c('activate', {
			context = 'mouse_click',
			action  = 'mouse_resize',
		})),
	}
end)
-- }}}
