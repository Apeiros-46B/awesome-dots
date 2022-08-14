-- {{{ Imports and misc
-- Libraries
local awful = require("awful")
local beautiful = require("beautiful")
local gears = require("gears")
local wibox = require("wibox")

-- Theme
local theme = beautiful.get()
local colors = theme.colorscheme

-- Functions
local dpi = beautiful.xresources.apply_dpi

-- Variables
local widgets = {}

local buttons = {
    awful.button(
        {},
        3,
        function()
            awful.spawn(Terminal_start_cmd .. "btop")
        end
    )
}
-- }}}

-- {{{ Return
return function(has_battery)
    -- {{{ Battery
    local battery
    if has_battery then
        -- Start watcher for battery status
        require("module.sysinfo.battery")

        -- {{{ Create the widget
        battery = wibox.widget {
            {
                {
                    {
                        -- Prefix icon
                        id = "prefix",
                        resize = true,
                        forced_width = dpi(19),
                        forced_height = dpi(19),
                        widget = wibox.widget.imagebox,
                    },
                    -- Centers the prefix icon
                    id = "prefixmargin",
                    forced_width = dpi(27),
                    forced_height = dpi(27),
                    widget = wibox.container.place,
                },
                -- Creates a background for the prefix icon
                id = "prefixbg",
                widget = wibox.container.background,
            },
            {
                {
                    -- Label
                    id = "label",
                    widget = wibox.widget.textbox,
                },
                -- Creates a background for the label
                id = "labelbg",
                bg = colors.gray3,
                widget = wibox.container.background,
            },
            -- Puts the prefix icon and the label side by side
            id = "layout",
            layout = wibox.layout.fixed.horizontal
        }
        -- }}}

        -- {{{ Connect to the watcher's status signal
        awesome.connect_signal("sysinfo::battery", function(remaining, charging)
            -- Set the icon of the prefix depending on battery state and charge
            battery:get_children_by_id("prefix")[1].image = (
                -- Determines whether or not the icon should be a charging icon or a normal icon
                charging and theme.battery_icons.charging
                or theme.battery_icons.discharging
            )[math.ceil(remaining / 10)] -- Determines the charge level of the icon

            -- Set background color based on remaining charge and whether or not it is charging
            battery:get_children_by_id("prefixbg")[1].bg = (
                -- If it's charging, make the prefix icon's background green
                charging and colors.green
                or (
                    -- If it isn't charging and remaining charge is less than 20%, make it red
                    remaining < 20 and colors.red
                    or (
                        -- If it isn't charging and remaining charge is between 20% and 30%, make it orange
                        remaining < 30 and colors.orange
                        or (
                            -- If it isn't charging and remaining charge is between 30% and 40%, make it yellow
                            remaining < 30 and colors.yellow
                            -- Otherwise, make it purple
                            or colors.purple
                        )
                    )
                )
            )

            -- Set label text
            battery:get_children_by_id("label")[1].text = " " .. remaining .. "% "
        end)
    -- }}}
    end
    -- }}}

    -- {{{ CPU
    -- Start watcher for cpu usage
    require("module.sysinfo.cpu")

    -- {{{ Create the widget
    local cpu = wibox.widget {
        {
            {
                {
                    -- Prefix icon
                    id = "prefix",
                    resize = true,
                    forced_width = dpi(17),
                    forced_height = dpi(17),
                    image = theme.sysinfo_cpu_icon,
                    widget = wibox.widget.imagebox,
                },
                -- Centers the prefix icon
                id = "prefixmargin",
                forced_width = dpi(27),
                forced_height = dpi(27),
                widget = wibox.container.place,
            },
            -- Creates a background for the prefix icon
            id = "prefixbg",
            widget = wibox.container.background,
        },
        {
            {
                -- Label
                id = "label",
                widget = wibox.widget.textbox,
            },
            -- Creates a background for the label
            id = "labelbg",
            bg = colors.gray3,
            widget = wibox.container.background,
        },
        -- Puts the prefix icon and the label side by side
        id = "layout",
        layout = wibox.layout.fixed.horizontal
    }
    -- }}}

    -- {{{ Connect to the watcher's status signal
    awesome.connect_signal("sysinfo::cpu", function(usage)
        -- Set background color based on usage
        cpu:get_children_by_id("prefixbg")[1].bg = (
            -- If usage is over 80, make the prefix icon's background red
            usage > 80 and colors.red
            or (
                -- If usage is between 70 and 80, make it orange
                usage > 70 and colors.orange
                or (
                    -- If usage is between 60 and 80, make it yellow
                    usage > 60 and colors.yellow
                    -- Otherwise, make it purple
                    or colors.purple
                )
            )
        )

        -- Set label text
        cpu:get_children_by_id("label")[1].text = " " .. usage .. "% "
    end)
    -- }}}
    -- }}}

    -- {{{ Memory
    -- Start watcher for memory usage
    require("module.sysinfo.memory")

    -- {{{ Create the widget
    local memory = wibox.widget {
        {
            {
                {
                    -- Prefix icon
                    id = "prefix",
                    resize = true,
                    forced_width = dpi(17),
                    forced_height = dpi(17),
                    image = theme.sysinfo_mem_icon,
                    widget = wibox.widget.imagebox,
                },
                -- Centers the prefix icon
                id = "prefixmargin",
                forced_width = dpi(27),
                forced_height = dpi(27),
                widget = wibox.container.place,
            },
            -- Creates a background for the prefix icon
            id = "prefixbg",
            widget = wibox.container.background,
        },
        {
            {
                -- Label
                id = "label",
                widget = wibox.widget.textbox,
            },
            -- Creates a background for the label
            id = "labelbg",
            bg = colors.gray3,
            widget = wibox.container.background,
        },
        -- Puts the prefix icon and the label side by side
        id = "layout",
        layout = wibox.layout.fixed.horizontal
    }

    -- }}}

    -- {{{ Connect to the watcher's status signal
    awesome.connect_signal("sysinfo::memory", function(usage, percent, symbol)
        -- Set background color based on usage
        memory:get_children_by_id("prefixbg")[1].bg = (
            -- If usage is over 80, make the prefix icon's background red
            percent > 80 and colors.red
            or (
                -- If usage is between 70 and 80, make it orange
                percent > 70 and colors.orange
                or (
                    -- If usage is between 60 and 80, make it yellow
                    percent > 60 and colors.yellow
                    -- Otherwise, make it purple
                    or colors.purple
                )
            )
        )

        -- Set label text
        memory:get_children_by_id("label")[1].text = " " .. usage .. " " .. symbol .. " "
    end)
    -- }}}
    -- }}}

    -- {{{ Finishing up
    -- Add buttons
    if battery ~= nil then battery:buttons(buttons) end
    cpu:buttons(buttons)
    memory:buttons(gears.table.join(
        awful.button(
            {},
            1,
            function()
                memory:emit_signal("sysinfo::memory::format_changed")
            end
        ),
        awful.button(
            {},
            3,
            function()
                awful.spawn(Terminal_start_cmd .. "btop")
            end
        )
    ))

    -- Add widgets to the table
    widgets.battery = battery
    widgets.cpu = cpu
    widgets.memory = memory

    -- Return the table
    return widgets
    -- }}}
end
-- }}}
