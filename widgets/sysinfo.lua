local awful = require("awful")
local beautiful = require("beautiful")
local gears = require("gears")
local wibox = require("wibox")
local dpi = beautiful.xresources.apply_dpi

local theme = beautiful.get()
local colors = theme.colorscheme

local widgets = {}

-- local pre = "<span foreground='" .. colors.gray1 .. "' background="
-- local bg = "<span background='" .. colors.gray3 .. "'> "
-- local purple = "'" .. colors.purple .. "'>"
-- local green = "'" .. colors.green .. "'>"
-- local red = "'" .. colors.red .. "'>"
-- local e = "</span>"

local buttons = gears.table.join(
    awful.button(
        {},
        1,
        function()
            awful.spawn(terminal_start_cmd .. "btop")
        end
    )
),

-- Battery
require("status.battery")

-- local battery = wibox.widget {
--     font = beautiful.font,
--     widget = wibox.widget.textbox
-- }
local battery = wibox.widget {
    {
        {
            {
                id = "prefix",
                resize = true,
                forced_height = dpi(17),
                forced_width = dpi(17),
                widget = wibox.widget.imagebox,
            },
            id = "prefixmargin",
            forced_width = dpi(27),
            forced_height = dpi(27),
            widget = wibox.container.place,
        },
        id = "prefixbg",
        widget = wibox.container.background,
    },
    {
        {
            id = "label",
            widget = wibox.widget.textbox,
        },
        id = "labelbg",
        bg = colors.gray3,
        widget = wibox.container.background,
    },
    id = "layout",
    layout = wibox.layout.fixed.horizontal
}

awesome.connect_signal("status::battery", function(remaining, charging)
    battery:get_children_by_id("prefix")[1].image = (
        charging and theme.battery_icons.charging
        or theme.battery_icons.discharging
    )[math.ceil(remaining / 10)]

    -- battery:get_children_by_id("prefix")[1].image = theme.battery_icons.charging[1]

    battery:get_children_by_id("prefixbg")[1].bg = (
        charging and colors.green
        or
        (
            remaining < 20 and colors.red
            or
            (
                remaining < 30 and colors.yellow
                or colors.purple
            )
        )
    )

    battery:get_children_by_id("label")[1].text = " " .. remaining .. "% "
end)

-- CPU
require("status.cpu")

local cpu = wibox.widget {
    {
        {
            {
                id = "prefix",
                resize = true,
                forced_height = dpi(15),
                forced_width = dpi(15),
                image = theme.sysinfo_cpu_icon,
                widget = wibox.widget.imagebox,
            },
            id = "prefixmargin",
            forced_width = dpi(27),
            forced_height = dpi(27),
            widget = wibox.container.place,
        },
        id = "prefixbg",
        widget = wibox.container.background,
    },
    {
        {
            id = "label",
            widget = wibox.widget.textbox,
        },
        id = "labelbg",
        bg = colors.gray3,
        widget = wibox.container.background,
    },
    id = "layout",
    layout = wibox.layout.fixed.horizontal
}

awesome.connect_signal("status::cpu", function(usage)
    cpu:get_children_by_id("prefixbg")[1].bg = (usage > 80 and colors.red or colors.purple)
    cpu:get_children_by_id("label")[1].text = " " .. usage .. "% "
end)

-- Memory
require("status.memory")

local memory = wibox.widget {
    {
        {
            {
                id = "prefix",
                resize = true,
                forced_height = dpi(15),
                forced_width = dpi(15),
                image = theme.sysinfo_mem_icon,
                widget = wibox.widget.imagebox,
            },
            id = "prefixmargin",
            forced_width = dpi(27),
            forced_height = dpi(27),
            widget = wibox.container.place,
        },
        id = "prefixbg",
        widget = wibox.container.background,
    },
    {
        {
            id = "label",
            widget = wibox.widget.textbox,
        },
        id = "labelbg",
        bg = colors.gray3,
        widget = wibox.container.background,
    },
    id = "layout",
    layout = wibox.layout.fixed.horizontal
}

awesome.connect_signal("status::memory", function(usage, total)
    memory:get_children_by_id("prefixbg")[1].bg = (((usage / total) * 100) > 80 and colors.red or colors.purple)
    memory:get_children_by_id("label")[1].text = " " .. usage .. " mb "
end)

-- Add buttons
battery:buttons(buttons)
cpu:buttons(buttons)
memory:buttons(buttons)

-- Add widgets to the table
widgets.battery = battery
widgets.cpu = cpu
widgets.memory = memory

-- Return the table
return widgets
