local awful = require("awful")
local gears = require("gears")
local wibox = require("wibox")

local colors = require("beautiful").get().colorscheme

local pre = "<span foreground='" .. colors.gray1 .. "' background='" .. colors.teal .. "'> time </span>"
local bg = "<span background='" .. colors.gray3 .. "'>"
local e = "</span>"

local format1 = pre .. bg .. " %m/%d/::%u -> %R " .. e
local format2 = pre .. bg .. " %m/%d/%Y::%u -> %R:%S " .. e

local format = format1

local textclock_buttons = gears.table.join(
    awful.button({ }, 1, function()
        if format == format1 then
            format = format2
        else
            format = format1
        end
    end)
)

local textclock = wibox.widget {
    format = format,
    widget = wibox.widget.textclock,
    buttons = textclock_buttons
}

return textclock
