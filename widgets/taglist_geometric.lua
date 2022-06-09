-- {{{ Imports/util
-- Libraries
local awful = require("awful")
local beautiful = require("beautiful")
local gears = require("gears")
local wibox = require("wibox")

-- Theme
local geolist_style = beautiful.geolist_style

-- Functions
local dpi = beautiful.xresources.apply_dpi

local function contains(table, element)
    for _, value in pairs(table) do
        if value == element then
            return true
        end
    end
    return false
end
-- }}}

-- {{{ Update callback
local list_update = function(widget, buttons, label, data, objects)
    -- Reset the widget
    widget:reset()

    -- Loop through tags
    for _, tag in ipairs(objects) do
        -- {{{ Create the tag widget
        local tag_widget = wibox.widget {
            {
                {
                    -- Tag's icon, image will be set later based on tag state
                    id = 'icon',
                    resize = true,
                    forced_width = dpi(11),
                    forced_height = dpi(11),
                    widget = wibox.widget.imagebox,
                },
                -- Place container to center the icon
                id = 'container',
                forced_width = dpi(27),
                forced_height = dpi(27),
                widget = wibox.container.place
            },
            -- Background container, colors will be set later based on tag state
            id = 'background',
            bg = geolist_style.empty.bg,
            widget = wibox.container.background
        }
        -- }}}

        -- {{{ Create buttons
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

        tag_widget:buttons(create_buttons(buttons, tag))
        -- }}}

        -- {{{ Variable definitions
        local tags = awful.screen.focused().selected_tags
        local focused = contains(tags, tag)
        local urgent = tag.urgent
        local has_clients = (tag:clients()[1] and true or false)

        local tag_icon = tag_widget:get_children_by_id('icon')[1]
        -- }}}

        -- {{{ Set bg color and fg image based on tag state
        if focused then
            tag_widget:set_bg(geolist_style.selected.bg)
            tag_icon.image = geolist_style.selected.icon
        elseif urgent then
            tag_widget:set_bg(geolist_style.urgent.bg)
            tag_icon.image = geolist_style.urgent.icon
        elseif has_clients then
            tag_widget:set_bg(geolist_style.occupied.bg)
            tag_icon.image = geolist_style.occupied.icon
        elseif not has_clients then
            tag_widget:set_bg(geolist_style.empty.bg)
            tag_icon.image = geolist_style.empty.icon
        end
        -- }}}

        -- {{{ Add tag widget to taglist
        widget:add(tag_widget)
        widget:set_spacing(dpi(0))
        -- }}}

        -- {{{ Change mouse cursor on hover
        local old_wibox, old_cursor

        tag_widget:connect_signal(
        "mouse::enter",
        function()
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
            if old_wibox then
                old_wibox.cursor = old_cursor
                old_wibox = nil
            end
        end
        )
        -- }}}
    end
end
-- }}}

-- {{{ Return the widget
-- Function that returns the taglist widget
local taglist = function(s)
    return awful.widget.taglist(
        -- Screen of the taglist
        s,
        -- Filter all tags
        awful.widget.taglist.filter.all,
        -- {{{ Buttons
        gears.table.join(
            -- {{{ Main buttons
            -- Left click -> view tag
            awful.button(
                {},
                1,
                function(t)
                    t:view_only()
                end
            ),
            -- Mod+Left click -> move focused client to tag
            awful.button(
                { Modkey },
                1,
                function(t)
                    if client.focus then
                        client.focus:move_to_tag(t)
                    end
                end
            ),
            -- Right click -> toggle tag visibility
            awful.button(
                {},
                3,
                function(t)
                    awful.tag.viewtoggle(t)
                end
            ),
            -- Mod+Right click -> toggle focused client on the tag
            awful.button(
                { Modkey },
                3,
                function(t)
                    if client.focus then
                        client.focus:toggle_tag(t)
                    end
                end
            ),
            -- }}}

            -- {{{ Scrolling to change tags
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
            -- }}}
        ),
        -- }}}
        -- Honestly no idea what this is :laugh4:
        {},
        -- Update callback function
        list_update,
        -- Set layout to fixed+horizontal
        wibox.layout.fixed.horizontal()
    )
end

-- Return the function
return taglist
-- }}}
