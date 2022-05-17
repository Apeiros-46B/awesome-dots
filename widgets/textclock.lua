-- libs
local awful = require("awful")
local gears = require("gears")
local wibox = require("wibox")
local beautiful = require("beautiful")

-- theme
local colors = beautiful.colorscheme
local dpi = beautiful.xresources.apply_dpi

-- color styles
local pre = "<span foreground='" .. colors.gray1 .. "' background='" .. colors.teal .. "'> time </span>"
local bg = "<span background='" .. colors.gray3 .. "'>"
local e = "</span>"

-- clock formats
local format1 = pre .. bg .. " %m/%d:%u -> %R " .. e
local format2 = pre .. bg .. " %m/%d/%Y:%u -> %R:%S " .. e

local textclock = wibox.widget {
    id = "clock",
    format = format1,
    widget = wibox.widget.textclock,
}

return textclock
