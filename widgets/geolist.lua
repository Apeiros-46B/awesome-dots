local wibox = require("wibox")
local awful = require("awful")
local gears = require("gears")
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi
local colors = beautiful.colorscheme

local function contains(table, element)
    for _, value in pairs(table) do
        if value == element then
            return true
        end
    end
    return false
end

local list_update = function(widget, buttons, label, data, objects)
    widget:reset()

    for _, object in ipairs(objects) do

        -- local tag_icon = wibox.widget {
        --     nil,
        --     {
        --         nil,
        --         {
        --             id = "icon",
        --             resize = true,
        --             widget = wibox.widget.imagebox,
        --             forced_height = 11,
        --             forced_width = 11,
        --         },
        --         nil,
        --         id = "hwrapper",
        --         layout = wibox.layout.align.horizontal,
        --         expand = "outside"
        --     },
        --     nil,
        --     layout = wibox.layout.align.vertical,
        --     expand = "outside"
        -- }

        local tag_icon = wibox.widget {
            id = "icon",
            resize = true,
            forced_height = 11,
            forced_width = 11,
            widget = wibox.widget.imagebox,
        }

        -- local tag_icon_margin = wibox.widget {
        --     tag_icon,
        --     forced_width = dpi(29),
        --     margins = dpi(3),
        --     widget = wibox.container.margin
        -- }

        local tag_icon_margin = wibox.widget {
            tag_icon,
            forced_width = dpi(29),
            top = dpi(8),
            bottom = dpi(7),
            left = dpi(9),
            right = dpi(9),
            widget = wibox.container.margin
        }

        local tag_widget = wibox.widget {
            {
                id = "widget_margin",
                {
                    id = "container",
                    tag_icon_margin,
                    layout = wibox.layout.fixed.horizontal
                },
                margins = dpi(0),
                widget = wibox.container.margin
            },
            fg = colors.white,
            shape = function(cr, width, height)
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

        local tags = awful.screen.focused().selected_tags
        local geolist_style = beautiful.geolist_style
        local text, bg_color, bg_image, icon, args = label(object, tag_icon)

        local next = next

        local focused = contains(tags, object)
        local urgent = object.urgent
        local has_clients = false

        if next(object:clients()) then
            has_clients = true
        end

        if focused then
            tag_widget:set_bg(geolist_style.selected.bg)
            -- tag_icon.hwrapper.icon.image = geolist_style.selected.icon
            tag_icon.image = geolist_style.selected.icon
        elseif urgent then
            tag_widget:set_bg(geolist_style.urgent.bg)
            -- tag_icon.hwrapper.icon.image = geolist_style.urgent.icon
            tag_icon.image = geolist_style.urgent.icon
        elseif has_clients then
            tag_widget:set_bg(geolist_style.occupied.bg)
            -- tag_icon.hwrapper.icon.image = geolist_style.occupied.icon
            tag_icon.image = geolist_style.occupied.icon
        elseif not has_clients then
            tag_widget:set_bg(geolist_style.empty.bg)
            -- tag_icon.hwrapper.icon.image = geolist_style.empty.icon
            tag_icon.image = geolist_style.empty.icon
        end

        widget:add(tag_widget)
        widget:set_spacing(dpi(0))
    end
end

local tag_list = function(s)
    local taglist_main =  awful.widget.taglist(
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
                    awful.tag.viewtoggle(t)
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

    return wibox.widget {
        taglist_main,
        left = dpi(8),
        widget = wibox.container.margin,
    }
end

return tag_list
