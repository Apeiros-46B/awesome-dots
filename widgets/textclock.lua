local awful = require("awful")
local gears = require("gears")
local wibox = require("wibox")

local colors = require("beautiful").colorscheme

local pre = "<span foreground='" .. colors.gray1 .. "' background='" .. colors.teal .. "'> time </span>"
local bg = "<span background='" .. colors.gray3 .. "'>"
local e = "</span>"

local format1 = pre .. bg .. " %m/%d:%u -> %R " .. e
local format2 = pre .. bg .. " %m/%d/%Y:%u -> %R:%S " .. e

local textclock = wibox.widget {
    id = "clock",
    format = format1,
    widget = wibox.widget.textclock,
}

local set_format = function(format)
    textclock.format = format
    awful.screen.focused().wibox.clock = textclock
end

local get_format = function()
    return textclock.format
end

local textclock_buttons = gears.table.join(
    awful.button({ }, 1, function()
        if get_format == format1 then
            set_format(format2)
        else
            set_format(format1)
        end
    end)
)

textclock:buttons(textclock_buttons)

return textclock
