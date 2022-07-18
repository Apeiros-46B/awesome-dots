-- {{{ Library imports
local awful = require("awful")

local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi
-- }}}

-- {{{ Manage signal
client.connect_signal("manage", function (c)
    -- Set the windows at the slave,
    -- i.e. put it at the end of others instead of setting it master.
    if not awesome.startup then awful.client.setslave(c) end

    if awesome.startup
        and not c.size_hints.user_position
        and not c.size_hints.program_position then
        -- Prevent clients from being unreachable after screen count changes.
        awful.placement.no_offscreen(c)
    end

    if c.floating then
        c.ontop = true
        c:raise()
    end
end)
-- }}}

-- {{{ Titlebar
client.connect_signal("request::titlebars", function(c)
    awful.titlebar(c, { size = dpi(22) }):set_widget(require("module.titlebar")(c))
end)
-- }}}

-- {{{ Change border colors on focus and unfocus
client.connect_signal("focus", function(c) c.border_color = beautiful.border_focus end)
client.connect_signal("unfocus", function(c) c.border_color = beautiful.border_normal end)
-- }}}
