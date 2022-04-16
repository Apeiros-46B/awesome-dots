local wibox = require("wibox")
local beautiful = require("beautiful")
local colors = beautiful.colors

local widgets = {}

local pre = "<span foreground='" .. colors.gray1 .. "' background='" .. colors.purple .. "'>"
local e = "</span> "

-- CPU
require("status.cpu")

local cpu = wibox.widget {
    widget = wibox.widget.textbox
}

awesome.connect_signal("status::cpu", function(usage)
    cpu.font = beautiful.font
    local markup = pre .. " cpu " .. e .. usage .. "%"

    cpu.markup = markup
end)

-- Memory
require("status.memory")

local memory = wibox.widget {
    widget = wibox.widget.textbox
}

awesome.connect_signal("status::memory", function(usage)
    memory.font = beautiful.font
    local markup = pre .. " mem " .. e .. usage .. " mb"

    memory.markup = markup
end)

widgets.cpu = cpu
widgets.memory = memory

return widgets
