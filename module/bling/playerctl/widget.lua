-- {{{ Libraries
local awful = require("awful")
local gears = require("gears")
local wibox = require("wibox")
local playerctl = require("bling").signal.playerctl.lib()

local beautiful = require("beautiful")
local colors = beautiful.colorscheme
local dpi = beautiful.xresources.apply_dpi
-- }}}

-- {{{ Position functions
-- Current position
local pos = 0
-- Track length
local max = 0

-- Rewind
local function rew(seconds)
    local new_pos = pos - seconds

    -- Don't rewind before the beginning of the track
    new_pos = new_pos < 0 and 0 or new_pos

    -- Set position & return
    pos = new_pos
    return new_pos
end

-- Fast forward
local function fwd(seconds)
    local new_pos = pos + seconds

    -- Don't fast forward past the end of the track
    if new_pos > max then return pos end

    -- Set position & return
    pos = new_pos
    return new_pos
end
-- }}}

-- {{{ Misc
-- Check if a string is non-nil and not empty
local function exists(string)
    return string ~= "" and string ~= nil
end
-- }}}

-- {{{ Buttons
local buttons     = {
    shuffle       = awful.button({}, 1, function() playerctl:cycle_shuffle()                       end),

    previous      = gears.table.join(
        awful.button({}, 1, function() playerctl:previous()                                        end),
        awful.button({}, 3, function() playerctl:set_position(rew(5))                              end)
    ),

    play_pause    = awful.button({}, 1, function() playerctl:play_pause()                          end),

    next          = gears.table.join(
        awful.button({}, 1, function() playerctl:next()                                            end),
        awful.button({}, 3, function() playerctl:set_position(fwd(5))                              end)
    ),

    loop          = awful.button({}, 1, function() playerctl:cycle_loop_status()                   end),

    toggle_extras = awful.button({}, 1, function() awesome.emit_signal("playerctl::toggle_extras") end)
}
-- }}}

-- {{{ Create the widget
local widget = wibox.widget {
    -- {{{ Layout
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
            -- right = dpi(8),
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
            id = "info",
            markup = " Nothing playing ",
            player = nil,
            extras_visible = false,
            widget = wibox.widget.textbox
        },
        id = "infobg",
        bg = colors.gray3,
        buttons = buttons.toggle_extras,
        widget = wibox.container.background
    },
    -- }}}
    id = "layout",
    layout = wibox.layout.fixed.horizontal
    -- }}}
}
-- }}}

-- {{{ Widget modification functions
-- {{{ Update the shuffle button
local function update_shuffle_button(shuffle)
    -- Get the widget & set the image
    widget:get_children_by_id("shuffle")[1].image = shuffle and beautiful.playerctl_shuffle or beautiful.playerctl_shuffle_off
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
playerctl:connect_signal("metadata", function(_, title, artist, _, _, _, player)
    -- Check if stuff exists
    local title_exists  = exists(title )
    local artist_exists = exists(artist)
    local player_exists = exists(player)

    -- Get the widget
    local info = widget:get_children_by_id("info")[1]

    -- If there is no player (edge case) then say "Nothing playing"
    if not player_exists then
        info:set_markup_silently(" Nothing playing ")
    else
        -- Create the text
        local text = " "
        local player_extra = info.extras_visible and (" [" .. player .. "]") or ""

        if title_exists and artist_exists then
            -- Add "artist - title" under normal conditions
            text   = text .. artist .. " - " .. title .. player_extra
        elseif title_exists then
            -- Add just the title in the case that there is no artist (e.g. playback of videos in Discord)
            text   = text .. title .. player_extra
        else
            text   = "Nothing playing"
        end

        -- Set the player to a widget property
        info.player = player

        -- Set the widget text
        info:set_markup_silently(" " .. text .. " ")
    end
end)
-- }}}

-- {{{ Update position variables
playerctl:connect_signal("position", function(_, interval, length, _)
    pos = interval
    max = length
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
    widget:get_children_by_id("info")[1]:set_markup_silently(" Nothing playing ")

    -- Reset shuffle, play/pause, and loop buttons to default
    update_shuffle_button    (false )
    update_play_pause_button (false )
    update_loop_button       ("none")
end)

playerctl:connect_signal("no_players", function(_)
    -- Get the info widget
    local info = widget:get_children_by_id("info")[1]

    -- Reset the text
    info:set_markup_silently(" Nothing playing ")

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
    local extras_visible = info.extras_visible

    -- {{{ Toggle player name visibility
    -- Get the player and text
    local player = info.player
    local text = info.text

    -- If there isn't a player, don't do anything
    if player ~= nil and text ~= " Nothing playing " then
        -- Show/hide the player value on the text
        if extras_visible then
            -- % sign escapes the square bracket
            info:set_markup_silently(text:gsub("%[" .. player .. "%] ", ""))
        else
            info:set_markup_silently(text .. "[" .. player .. "] ")
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
        margin.right = dpi(1)
    else
        margin.left = 0
        margin.right = dpi(8)
    end
    -- }}}

    -- Invert extras_visible property
    info.extras_visible = not extras_visible
end)
-- }}}
-- }}}

-- {{{ Return the widget
return widget
-- }}}
