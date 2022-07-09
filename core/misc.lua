local awful = require("awful")
local gears = require("gears")

local beautiful = require("beautiful")

-- Autofocus
require("awful.autofocus")

-- Theme
local theme_path = string.format("%s/.config/awesome/themes/%s/theme.lua", os.getenv("HOME"), "default")
beautiful.init(theme_path)

-- Layouts
awful.layout.layouts = {
    awful.layout.suit.tile,
    awful.layout.suit.fair,
    awful.layout.suit.spiral,
    awful.layout.suit.spiral.dwindle,
    awful.layout.suit.floating,
}

-- Bling
require("module.bling.playerctl.notifier")
require("module.bling.window_switcher")

-- Variables
-- Default terminal emulator and editor
Terminal = "kitty -c " .. os.getenv("HOME") .. "/.config/awesome/external/kitty/kitty.conf"
Terminal_start_cmd = Terminal .. " -e "
Editor = os.getenv("EDITOR") or "nvim"
Editor_cmd = Terminal_start_cmd .. Editor

-- Default modkey
Modkey = "Mod4"

-- Menu
require("module.menu")

-- Prevent memory leaks
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
