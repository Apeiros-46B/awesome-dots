-- {{{ Libraries
local awful = require("awful")
local gears = require("gears")
local wibox = require("wibox")

local beautiful = require("beautiful")
local colors    = beautiful.colorscheme
local dpi       = beautiful.xresources.apply_dpi
-- }}}

-- {{{ Return function
return function(core, notify)
    local playerctl = core.playerctl

    -- {{{ Buttons
    local buttons     = {
        shuffle       = awful.button({}, 1, core.toggle_shuffle),

        previous      = gears.table.join(
            awful.button({}, 1, core.prev                      ),
            awful.button({}, 2, function() core.rew(15)     end),
            awful.button({}, 3, function() core.rew(5)      end)
        ),

        play_pause    = awful.button({}, 1, core.play_pause    ),

        next          = gears.table.join(
            awful.button({}, 1, core.next                      ),
            awful.button({}, 2, function() core.fwd(15)     end),
            awful.button({}, 3, function() core.fwd(5)      end)
        ),

        loop          = awful.button({}, 1, core.cycle_loop    ),

        toggle_extras = gears.table.join(
            awful.button({}, 1, function() awesome.emit_signal("playerctl::toggle_extras") end),
            awful.button({}, 3, function() awesome.emit_signal("playerctl::toggle_scroll") end)
        ),

        cycle_players = gears.table.join(
            awful.button({}, 4, core.next_player),
            awful.button({}, 5, core.prev_player)
        )
    }
    -- }}}

    -- {{{ Create the widget
    local widget = wibox.widget {
        -- {{{ Buttons
        {
            {
                {
                    -- {{{ Shuffle
                    {
                        {
                            id = "shuffle",
                            image = beautiful.playerctl_shuffle_off,
                            forced_width = dpi(16),
                            forced_height = dpi(16),
                            widget = wibox.widget.imagebox
                        },
                        id = "shufflemargin",
                        forced_width = dpi(26),
                        forced_height = dpi(27),
                        buttons = buttons.shuffle,
                        visible = false,
                        widget = wibox.container.place
                    },
                    -- }}}
                    -- {{{ Previous
                    {
                        {
                            id = "previous",
                            image = beautiful.playerctl_previous,
                            forced_width = dpi(16),
                            forced_height = dpi(16),
                            widget = wibox.widget.imagebox
                        },
                        id = "previousmargin",
                        forced_width = dpi(26),
                        forced_height = dpi(27),
                        buttons = buttons.previous,
                        widget = wibox.container.place
                    },
                    -- }}}
                    -- {{{ Play-pause
                    {
                        {
                            id = "playpause",
                            image = beautiful.playerctl_play,
                            forced_width = dpi(14),
                            forced_height = dpi(14),
                            widget = wibox.widget.imagebox
                        },
                        id = "playpausemargin",
                        forced_width = dpi(26),
                        forced_height = dpi(27),
                        buttons = buttons.play_pause,
                        widget = wibox.container.place
                    },
                    -- }}}
                    -- {{{ Next
                    {
                        {
                            id = "next",
                            image = beautiful.playerctl_next,
                            forced_width = dpi(16),
                            forced_height = dpi(16),
                            widget = wibox.widget.imagebox
                        },
                        id = "nextmargin",
                        forced_width = dpi(26),
                        forced_height = dpi(27),
                        buttons = buttons.next,
                        widget = wibox.container.place
                    },
                    -- }}}
                    -- {{{ Loop
                    {
                        {
                            id = "loop",
                            image = beautiful.playerctl_loop_off,
                            forced_width = dpi(16),
                            forced_height = dpi(16),
                            widget = wibox.widget.imagebox
                        },
                        id = "loopmargin",
                        forced_width = dpi(16),
                        forced_height = dpi(27),
                        buttons = buttons.loop,
                        visible = false,
                        widget = wibox.container.place
                    },
                    -- }}}
                    id = "buttonslayout",
                    layout = wibox.layout.fixed.horizontal
                },
                id = "buttonsmargin",
                -- Compensate for weird spacing issue on buttons
                left = dpi(6),
                right = dpi(1),
                widget = wibox.container.margin
            },
            id = "buttonsbg",
            bg = colors.green,
            widget = wibox.container.background
        },
        -- }}}
        -- {{{ Textbox with song info
        {
            {
                wibox.widget.textbox(" "),
                {
                    {
                        markup = "Nothing playing",
                        player = nil,
                        extras_visible = false,
                        id = "info",
                        ellipsize = "end",
                        widget = wibox.widget.textbox
                    },
                    scrolling = true,
                    id = "scroller",
                    extra_space = dpi(8),
                    max_size = dpi(280),
                    speed = 30,
                    fps = 75,
                    --    ^^ Change this to your refresh rate or other desired FPS
                    step_function = wibox.container.scroll.step_functions.linear_increase,
                    layout = wibox.container.scroll.horizontal
                },
                {
                    markup = " ",
                    id = "playerinfo",
                    widget = wibox.widget.textbox,
                },
                id = "infolayout",
                layout = wibox.layout.fixed.horizontal
            },
            id = "infobg",
            bg = colors.gray3,
            buttons = buttons.toggle_extras,
            widget = wibox.container.background
        },
        -- }}}
        id = "layout",
        layout = wibox.layout.fixed.horizontal
    }
    -- }}}

    -- {{{ Widget modification functions
    -- {{{ Update the shuffle button
    local function update_shuffle_button(shuffle)
        -- Get the widget & set the image
        widget:get_children_by_id("shuffle")[1].image = (
            shuffle
                and beautiful.playerctl_shuffle
                or beautiful.playerctl_shuffle_off
        )
    end
    -- }}}

    -- {{{ Update the play/pause button
    local function update_play_pause_button(playing)
        -- Get the widget
        local play_pause = widget:get_children_by_id("playpause")[1]

        if playing then
            -- Change the button image
            play_pause.image = beautiful.playerctl_pause

            -- Change the size of the button so the icon size stays consistent
            play_pause.forced_width = dpi(16)
            play_pause.forced_height = dpi(16)
        else
            -- Change the button image
            play_pause.image = beautiful.playerctl_play

            -- Change the size of the button so the icon size stays consistent
            play_pause.forced_width = dpi(14)
            play_pause.forced_height = dpi(14)
        end
    end
    -- }}}

    -- {{{ Update the loop button
    local function update_loop_button(loop_status)
        -- Get the widget
        local play_pause = widget:get_children_by_id("loop")[1]

        -- Check the loop status and update the image accordingly
        if loop_status == "none"         then
            play_pause.image = beautiful.playerctl_loop_off
        elseif loop_status == "track"    then
            play_pause.image = beautiful.playerctl_loop_one
        elseif loop_status == "playlist" then
            play_pause.image = beautiful.playerctl_loop
        end
    end
    -- }}}
    -- }}}

    -- {{{ Signals
    -- {{{ Change the text when the song changes
    -- Check if a string is non-nil and not empty
    local function exists(string)
        return string ~= "" and string ~= nil
    end

    -- Connect to the signal
    playerctl:connect_signal("metadata", function(_, title, artist, _, _, _, player)
        -- Check if stuff exists
        local title_exists  = exists(title )
        local artist_exists = exists(artist)
        local player_exists = exists(player)

        -- Get the widgets
        local info = widget:get_children_by_id("info")[1]
        local playerinfo = widget:get_children_by_id("playerinfo")[1]
        local scroller = widget:get_children_by_id("scroller")[1]

        -- If there is no player (edge case) then say "Nothing playing"
        if not player_exists then
            info:set_markup_silently("Nothing playing")
        else
            -- Create the text
            local text = " "

            if title_exists and artist_exists then
                -- Add "artist - title" under normal conditions
                text   = text .. artist .. " - " .. title
            elseif title_exists then
                -- Add just the title in the case that there is no artist (e.g. playback of videos in Discord)
                text   = text .. title
            else
                text   = "Nothing playing"
            end

            -- Set the player to a widget property
            info.player = player

            -- Set the widgets' text
            info:set_markup_silently(text)
            playerinfo:set_markup_silently(info.extras_visible and (" [" .. player .. "] ") or " ")
        end

        -- Update the scroll container
        scroller:emit_signal("widget::layout_changed")
        scroller:emit_signal("widget::redraw_needed")
    end)
    -- }}}

    -- {{{ Update buttons
    -- Update the shuffle button's icon
    playerctl:connect_signal("shuffle", function(_, shuffle, _) update_shuffle_button(shuffle) end)

    -- Update the play/pause button's icon
    playerctl:connect_signal("playback_status", function(_, playing, _) update_play_pause_button(playing) end)

    -- Update the loop button's icon
    playerctl:connect_signal("loop_status", function(_, loop_status, _) update_loop_button(loop_status) end)
    -- }}}

    -- {{{ Reset widgets when no players or exit
    playerctl:connect_signal("exit", function(_, _)
        -- Get the info widget & reset the text
        widget:get_children_by_id("info")[1]:set_markup_silently("Nothing playing")

        -- Update the scroll container
        local scroller = widget:get_children_by_id("scroller")[1]
        scroller:emit_signal("widget::layout_changed")
        scroller:emit_signal("widget::redraw_needed")

        -- Reset shuffle, play/pause, and loop buttons to default
        update_shuffle_button    (false )
        update_play_pause_button (false )
        update_loop_button       ("none")
    end)

    playerctl:connect_signal("no_players", function(_)
        -- Get the info widget
        local info     = widget:get_children_by_id("info")    [1]
        local scroller = widget:get_children_by_id("scroller")[1]

        -- Reset the text
        info:set_markup_silently("Nothing playing")

        -- Update the scroll container
        scroller:emit_signal("widget::layout_changed")
        scroller:emit_signal("widget::redraw_needed")

        -- Reset the player
        info.player = nil
        info.player_visible = false

        -- Reset shuffle, play/pause, and loop buttons to default
        update_shuffle_button    (false )
        update_play_pause_button (false )
        update_loop_button       ("none")
    end)
    -- }}}

    -- {{{ Show and hide extras
    awesome.connect_signal("playerctl::toggle_extras", function()
        -- Get the widget and extras_visible property
        local info = widget:get_children_by_id("info")[1]
        local playerinfo = widget:get_children_by_id("playerinfo")[1]
        local extras_visible = info.extras_visible

        -- {{{ Toggle player name visibility
        -- Get the player and text
        local player = info.player
        local text = info.text

        -- If there isn't a player, don't do anything
        if player ~= nil and text ~= "Nothing playing" then
            -- Show/hide the player value on the text
            if extras_visible then
                playerinfo:set_markup_silently(" ")
            else
                playerinfo:set_markup_silently(" [" .. player .. "] ")
            end
        end
        -- }}}

        -- {{{ Toggle shuffle and loop buttons
        -- Get the widgets
        local shuffle = widget:get_children_by_id("shufflemargin")[1]
        local loop = widget:get_children_by_id("loopmargin")[1]
        local margin = widget:get_children_by_id("buttonsmargin")[1]

        -- Change visibility of buttons
        shuffle.visible = not extras_visible
        loop   .visible = not extras_visible

        -- Fix margins
        if extras_visible then
            margin.left = dpi(6)
            margin.right = dpi(2)
        else
            margin.left = 0
            margin.right = dpi(8)
        end
        -- }}}

        -- Invert extras_visible property
        info.extras_visible = not extras_visible
    end)
    -- }}}

    -- {{{ Toggle scroller
    awesome.connect_signal("playerctl::toggle_scroll", function()
        -- Get the widget
        local scroller = widget:get_children_by_id("scroller")[1]

        if scroller.scrolling then
            -- Effectively disable size constraint
            scroller:set_max_size(dpi(1920))
            --                        ^^^^ Change this to your screen width

            -- Set fps as low as possible
            -- **Setting this to 0 will cause a division by 0!**
            scroller:set_fps(1)

            -- Reset and pause scrolling
            scroller:reset_scrolling()
            scroller:pause()

            -- Update layout
            scroller:emit_signal("widget::layout_changed")

            -- Notify
            notify({ title = "Playerctl widget", message = "Scroll disabled", app_name = "playerctl_widget", replaces = true })
        else
            -- Return attributes back to normal
            scroller:set_max_size(dpi(280))
            scroller:set_fps(75)
            --               ^^ Change this to your refresh rate or other desired FPS

            -- Reset and continue scrolling
            scroller:reset_scrolling()
            scroller:continue()

            -- Update layout
            scroller:emit_signal("widget::layout_changed")

            -- Notify
            notify({ title = "Playerctl widget", message = "Scroll enabled", app_name = "playerctl_widget", replaces = true })
        end

        -- Update boolean
        scroller.scrolling = not scroller.scrolling
    end)
    -- }}}
    -- }}}

    -- {{{ Return the widget
    return widget
    -- }}}
end
-- }}}
