local awful = require("awful")
local gears = require("gears")
local beautiful = require("beautiful")

-- Function for setting the wallpaper
local function set_wallpaper(s)
    gears.wallpaper.maximized(beautiful.wallpaper, s, true)
end

-- Re-set wallpaper when a screen's geometry changes (e.g. different resolution)
screen.connect_signal("property::geometry", set_wallpaper)

-- Run this function for each screen
awful.screen.connect_for_each_screen(function(s)
    -- Set tags
    awful.tag({ "I", "II", "III", "IV", "V", "VI", "VII", "VIII" }, s, awful.layout.layouts[1])

    -- Set wallpaper
    set_wallpaper(s)

    -- Wibar
    require("widgets.wibar")(s)
end)
