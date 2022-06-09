local awful = require("awful")
local gears = require("gears")

local beautiful = require("beautiful")

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
local bling = require("bling")

bling.widget.window_switcher.enable {
    type = "normal", -- set to anything other than "thumbnail" to disable client previews

    -- keybindings (the examples provided are also the default if kept unset)
    hide_window_switcher_key = "Escape", -- The key on which to close the popup
    minimize_key = "m",                  -- The key on which to minimize the selected client
    unminimize_key = "M",                -- The key on which to unminimize all clients
    kill_client_key = "q",               -- The key on which to close the selected client
    cycle_key = "Tab",                   -- The key on which to cycle through all clients
    previous_key = "l",                  -- The key on which to select the previous client
    next_key = "h",                      -- The key on which to select the next client
    vim_previous_key = "j",              -- Alternative key on which to select the previous client
    vim_next_key = "k",                  -- Alternative key on which to select the next client
}

-- Variables
-- Default terminal emulator and editor
Terminal = "kitty -c " .. os.getenv("HOME") .. "/.config/awesome/external/kitty/kitty.conf"
Terminal_start_cmd = Terminal .. " -e "
Editor = os.getenv("EDITOR") or "nvim"
Editor_cmd = Terminal_start_cmd .. Editor

-- Default modkey
Modkey = "Mod4"

-- Menu
require("widgets.menu")

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
