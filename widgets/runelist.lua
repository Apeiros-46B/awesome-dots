local wibox = require("wibox")
local awful = require("awful")
local gears = require("gears")
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi
local colors = beautiful.colorscheme

local helper = require("util.runelist_helper")

local list_update = function(widget, buttons, label, data, objects)
    widget:reset()

    for _, object in ipairs(objects) do

        local tag_icon = wibox.widget {
            nil,
            {
                id = "icon",
                resize = true,
    widget = wibox.widget.imagebox
    },
            nil,
            layout = wibox.layout.align.horizontal
        }

        local tag_icon_margin = wibox.widget {
            tag_icon,
            forced_width = dpi(27),
            margins = dpi(1.5),
            widget = wibox.container.margin
        }

        local tag_label = wibox.widget {
            text = "",
            align = "center",
            valign = "center",
            visible = true,
            font = beautiful.taglist_font,
            forced_width = dpi(27),
            widget = wibox.widget.textbox
        }

        local tag_label_margin = wibox.widget {
            tag_label,
            forced_width = dpi(29),
            -- left = dpi(1.5),
            -- right = dpi(1.5),
            widget = wibox.container.margin
        }

        local tag_widget = wibox.widget {
            {
                id = "widget_margin",
                {
                    id = "container",
                    tag_label_margin,
                    layout = wibox.layout.fixed.horizontal
                },
                margins = dpi(0),
                widget = wibox.container.margin
            },
            fg = colors.white,
            shape = function(cr, width, height)
                -- gears.shape.rounded_rect(cr, width, height, 5)
                gears.shape.rectangle(cr, width, height)
            end,
            widget = wibox.container.background
        }

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

        tag_widget:buttons(create_buttons(buttons, object))

        local text, bg_color, bg_image, icon, args = label(object, tag_label)
        local naughty = require("naughty")
        -- tag_label:set_text(object.index)
        tag_label:set_text(helper.rune_table[object.index - 1])
        -- tag_label:set_text(tag_label:get_text())

        local update_timer = gears.timer {
            timeout   = 0.03,
            callback  = function()
                tag_label:set_text(helper.random())
            end
        }

        local focused = false

        if object.urgent then
            tag_widget:set_bg(colors.red)
            tag_widget:set_fg(colors.gray1)

            update_timer:start()
        elseif object == awful.screen.focused().selected_tag then
            tag_widget:set_bg(colors.blue)
            tag_widget:set_fg(colors.gray1)

            tag_label:set_text(helper.random())

            focused = true

            if update_timer.started then
                update_timer:stop()
            end
        else
            tag_widget:set_bg(colors.gray3)

            if update_timer.started then
                update_timer:stop()
            end
        end

        local has_clients = false

        for _, client in ipairs(object:clients()) do
            has_clients = true
            break

            -- if focused then
            --     tag_label_margin:set_right(0)
            --     local icon = wibox.widget {
            --         {
            --             id = "icon_container",
            --             {
            --                 id = "icon",
            --                 resize = true,
            --                 widget = wibox.widget.imagebox
            --             },
            --             widget = wibox.container.place
            --         },
            --         tag_icon_margin,
            --         forced_width = dpi(27),
            --         margins = dpi(6),
            --         widget = wibox.container.margin
            --     }
            --     icon.icon_container.icon:set_image(beautiful.awesome_icon_alt)
            --     tag_widget.widget_margin.container:setup({
            --         icon,
            --         layout = wibox.layout.align.horizontal
            --     })
            -- end
        end

        if not has_clients and not focused then
            tag_widget:set_fg(colors.gray5)
        end

        local old_wibox, old_cursor, old_bg

        tag_widget:connect_signal(
            "mouse::enter",
            function()
                update_timer:start()

                local w = mouse.current_wibox
                if w then
                    old_cursor, old_wibox = w.cursor, w
                    w.cursor = "hand1"
                end
            end
        )

        tag_widget:connect_signal(
            "mouse::leave",
            function()
                if not urgent then
                    update_timer:stop()
                end

                if old_wibox then
                    old_wibox.cursor = old_cursor
                    old_wibox = nil
                end
            end
        )

        -- tag_widget:connect_signal(
        --     "button::press",
        --     function()
        --         if object == awful.screen.focused().selected_tag then
        --             tag_widget.bg = '#bbbbbb' .. 'dd'
        --         else
        --             tag_widget.bg = '#3A475C' .. 'dd'
        --         end
        --     end
        -- )
        --
        -- tag_widget:connect_signal(
        --     "button::release",
        --     function()
        --         if object == awful.screen.focused().selected_tag then
        --             tag_widget.bg = '#dddddd' .. 'dd'
        --         else
        --             tag_widget.bg = '#3A475C' .. 'dd'
        --         end
        --     end
        -- )

        widget:add(tag_widget)
        widget:set_spacing(dpi(0))
    end
end

local tag_list = function(s)
    return awful.widget.taglist(
        s,
        awful.widget.taglist.filter.all,
        gears.table.join(
            awful.button(
                {},
                1,
                function(t)
                    t:view_only()
                end
            ),
            awful.button(
                { modkey },
                1,
                function(t)
                    if client.focus then
                        client.focus:move_to_tag(t)
                    end
                end
            ),
            awful.button(
                {},
                3,
                function(t)
                    if client.focus then
                        client.focus:toggle_tag(t)
                    end
                end
            ),
            awful.button(
                { modkey },
                3,
                function(t)
                    if client.focus then
                        client.focus:toggle_tag(t)
                    end
                end
            ),
            awful.button(
                {},
                4,
                function(t)
                    awful.tag.viewprev(t.screen)
                end
            ),
            awful.button(
                {},
                5,
                function(t)
                    awful.tag.viewnext(t.screen)
                end
            )
        ),
        {},
        list_update,
        wibox.layout.fixed.horizontal()
    )
end

return tag_list
