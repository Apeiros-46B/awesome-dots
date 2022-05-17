local awful = require("awful")
local beautiful = require("beautiful")
local gears = require("gears")
local wibox = require("wibox")

local colors = beautiful.colorscheme

local widgets = {}

local pre = "<span foreground='" .. colors.gray1 .. "' background='" .. colors.purple .. "'>"
local bg = "<span background='" .. colors.gray3 .. "'> "
local e = "</span>"

local buttons = gears.table.join(
    awful.button(
        {},
        1,
        function()
            awful.spawn(terminal_start_cmd .. "btop")
        end
    )
),

-- CPU
require("status.cpu")

local cpu = wibox.widget {
    widget = wibox.widget.textbox
}

awesome.connect_signal("status::cpu", function(usage)
    cpu.font = beautiful.font
    local markup = pre .. " cpu " .. e .. bg .. usage .. "% " .. e

    cpu.markup = markup
end)

-- Memory
require("status.memory")

local memory = wibox.widget {
    widget = wibox.widget.textbox
}

awesome.connect_signal("status::memory", function(usage)
    memory.font = beautiful.font
    local markup = pre .. " mem " .. e .. bg .. usage .. " mb " .. e

    memory.markup = markup
end)

cpu:buttons(buttons)
memory:buttons(buttons)

widgets.cpu = cpu
widgets.memory = memory

return widgets
