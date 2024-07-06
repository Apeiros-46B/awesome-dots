local wibox = require('wibox')
local naughty = require('naughty')

local theme = require('beautiful').get()
local dpi = require('beautiful.xresources').apply_dpi

local notifs = {}

naughty.connect_signal('request::display', function(notif, _)
	-- local app_name = notif.app_name

	-- if app_name then
	-- 	local prev_notif = notifs[app_name]

	-- 	if prev_notif then
	-- 		prev_notif:destroy(naughty.notification_closed_reason.expired)
	-- 	end

	-- 	notifs[app_name] = notif
	-- end

	if #naughty.active > 13 then
		return
	end

	local widget = {
		widget   = wibox.container.constraint,
		width    = dpi(480),
		strategy = 'max',

		{
			layout  = wibox.container.margin,
			margins = theme.notification_margin,

		},
	}

	local inner = {
		layout     = wibox.layout.fixed.horizontal,
		fill_space = true,
		spacing    = theme.notification_margin,

		naughty.widget.icon,
		{
			layout  = wibox.layout.fixed.vertical,

			naughty.widget.title,
			naughty.widget.message,
		},
	}

	if #notif.actions > 0 then
		local actions = {
			widget = naughty.list.actions,
			notification = notif,
			base_layout = wibox.widget {
				spacing = theme.notification_margin,
				layout  = wibox.layout.fixed.horizontal
			},

			widget_template = {
				layout = wibox.container.background,
				bg     = theme.colors.bg3,

				{
					layout  = wibox.container.margin,
					margins = theme.gaps.m,

					{
						id     = 'text_role',
						widget = wibox.widget.textbox,
						font   = theme.font_bold,
					},
				},
			},
		}

		widget[1][1] = {
			layout  = wibox.layout.fixed.vertical,
			spacing = theme.notification_margin,

			inner,
			actions,
		}
	else
		widget[1][1] = inner
	end

	-- TODO: fix weird extra margin on the right for notifications
	-- TODO: make notif icon position somewhat presentable
	-- TODO: align actions buttons with text? or keep them as they are?
	naughty.layout.box {
		notification = notif,
		widget_template = {
			layout = wibox.container.background,
			bg = theme.colors.bg2,
			widget,
		},
	}
end)
