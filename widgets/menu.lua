local awful = require("awful")
local hotkeys_popup = awful.hotkeys_popup

local beautiful = require("beautiful")

local awesomemenu = {
    { "hotkeys", function() hotkeys_popup.show_help(nil, awful.screen.focused()) end },
    { "manual", terminal_start_cmd .. "man awesome" },
    { "edit config", editor_cmd .. " " .. awesome.conffile },
    { "restart", awesome.restart },
    { "quit", function() awesome.quit() end },
}

local appmenu = {
    { "browser", "brave" },
    { "spotify", "spotify" },
    { "txt editor", terminal_start_cmd .. "nvim" },
}

local utilmenu = {
    { "screenshot", "flameshot gui" },
    { "terminal", terminal },
    { "btop", terminal_start_cmd .. "btop" },
    { "file manager", "pcmanfm" },
}

mainmenu = awful.menu({
    items = {
        { "awesome", awesomemenu, beautiful.awesome_icon },
        { "apps", appmenu },
        { "utils", utilmenu }
    }
})
