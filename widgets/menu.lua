local awful = require("awful")
local hotkeys_popup = require("awful.hotkeys_popup")

require("awful.hotkeys_popup.keys")

local beautiful = require("beautiful")

local awesome = {
    { "hotkeys", function() hotkeys_popup.show_help(nil, awful.screen.focused()) end },
    { "manual", Terminal_start_cmd .. "man awesome" },
    { "edit config", Editor_cmd .. " " .. awesome.conffile },
    { "restart", awesome.restart },
    { "quit", function() awesome.quit() end },
}

local apps = {
    { "browser", "brave" },
    { "spotify", "spotify" },
    { "txt editor", Terminal_start_cmd .. "nvim" },
}

local utils = {
    { "screenshot", "flameshot gui" },
    { "terminal", Terminal },
    { "btop", Terminal_start_cmd .. "btop" },
    { "file manager", "pcmanfm" },
}

Menu = awful.menu({
    items = {
        { "awesome", awesome, beautiful.awesome_icon },
        { "apps", apps },
        { "utils", utils }
    }
})
