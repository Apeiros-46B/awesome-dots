local awful = require("awful")
local wibox = require("wibox")

local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi

local colors = beautiful.colorscheme

local padding = require("module.widgets.bar.padding")

local list_update = function(widget, buttons, _, _, objects)
    widget:reset()
    local iterated_over_clients = false

    for _, object in ipairs(objects) do
        local task_widget = wibox.widget {
            {
                {
                    id = 'icon',
                    resize = true,
                    forced_width = dpi(21),
                    forced_height = dpi(21),
                    widget = wibox.widget.imagebox
                },
                id = 'container',
                forced_height = dpi(27),
                forced_width = dpi(27),
                widget = wibox.container.place,
            },
            id = 'background',
            bg = colors.blue,
            widget = wibox.container.background
        }

        local task_tooltip = awful.tooltip {
            objects = { task_widget },
            mode = "outside",
            align = "top",
            preferred_alignments = { "middle", "front", "back" },
            delay_show = 0.4
        }

        local task_state_icons = {}

        local function create_buttons(buttons, object)
            if buttons then
                local btns = {}
                for _, b in ipairs(buttons) do
                    local btn = awful.button {
                        modifiers = b.modifiers,
                        button = b.button,
                        on_press = function()
                            b:emit_signal('press', object)
                        end,
                        on_release = function()
                            b:emit_signal('release', object)
                        end
                    }
                    btns[#btns + 1] = btn
                end
                return btns
            end
        end

        task_widget:buttons(create_buttons(buttons, object))

        local bg = colors.gray3
        local fg = colors.white

        if object == client.focus then
            bg = colors.blue
            fg = colors.gray1
        elseif object.sticky then
            bg = colors.purple
            fg = colors.gray1
        end

        task_widget:set_bg(bg)
        task_widget:set_fg(fg)

        task_widget:get_children_by_id('icon')[1]:set_image(object.icon)
        task_tooltip.text = object.name

        widget:add(task_widget)
        widget:set_spacing(dpi(0))

        local old_wibox, old_cursor
        local old_minimized

        task_widget:connect_signal(
            "mouse::enter",
            function()
                local w = mouse.current_wibox
                if w then
                    old_cursor, old_wibox = w.cursor, w
                    w.cursor = "hand1"
                end
            end
        )

        task_widget:connect_signal(
            "mouse::leave",
            function()
                if old_wibox then
                    old_wibox.cursor = old_cursor
                    old_wibox = nil
                end
            end
        )

        task_widget:connect_signal(
            "button::press",
            function(self, lx, ly, button, mods, find_widgets_result)
                if button == 3 then
                    if object.minimized then
                        old_minimized = true

                        object:emit_signal(
                            "request::activate", "key.unminimize", { raise = true }
                        )
                    end
                end
            end
        )

        task_widget:connect_signal(
            "button::release",
            function(self, lx, ly, button, mods, find_widgets_result)
                if button == 3 then
                    if old_minimized then
                        object.minimized = true
                    end
                end
            end
        )

        iterated_over_clients = true
    end

    if iterated_over_clients then widget:add(padding) end

    return widget
end

local tasklist = function(s)
    return awful.widget.tasklist(
        s,
        awful.widget.tasklist.filter.currenttags,
        awful.util.table.join(
            awful.button(
                {},
                1,
                function(c)
                    if c == client.focus then
                        c.minimized = true
                    else
                        c.minimized = false
                        if not c:isvisible() and c.first_tag then
                            c.first_tag:view_only()
                        end
                        c:emit_signal('request::activate')
                        c:raise()
                    end
                end
            ),
            awful.button(
                {},
                2,
                function(c)
                    c:kill()
                end
            ),
            awful.button({ }, 4, function() awful.client.focus.byidx(-1) end),
            awful.button({ }, 5, function() awful.client.focus.byidx(1) end)
        ),
        {},
        list_update,
        wibox.layout.fixed.horizontal()
    )
end

return tasklist
