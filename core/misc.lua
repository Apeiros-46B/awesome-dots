-- {{{ Library imports
local awful = require("awful")
local gears = require("gears")
local beautiful = require("beautiful")
-- }}}

-- {{{ Focus
-- Autofocus
require("awful.autofocus")

-- Focus follows mouse
client.connect_signal("mouse::enter", function(c)
    c:emit_signal("request::activate", "mouse_enter", {raise = false})
end)
-- }}}

-- {{{ Bling
require("module.bling.playerctl.notifier")
require("module.bling.window_switcher")
-- }}}

-- {{{ Menu
require("module.menu")
-- }}}

-- {{{ Prevent memory leaks
gears.timer {
    timeout = 30,
    call_now = true,
    autostart = true,
    callback = function()
        collectgarbage("step", 1024)
        collectgarbage("setpause", 110)
        collectgarbage("setstepmul", 1000)
    end,
}
-- }}}
