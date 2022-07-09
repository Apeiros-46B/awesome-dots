-- {{{ Libraries
local awful = require("awful")
local wibox = require("wibox")
local playerctl = require("bling").signal.playerctl.lib()

local beautiful = require("beautiful")
local colors = beautiful.colorscheme
local dpi = beautiful.xresources.apply_dpi
-- }}}

-- {{{ Misc
-- Helper function
local function exists(string)
    return string ~= "" and string ~= nil
end
-- }}}

-- {{{ Create the widget
local widget = wibox.widget {
    -- {{{ Layout
    -- {{{ Buttons
    {
        {
            {
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
                    buttons = awful.button({}, 1, function() playerctl:previous()   end),
                    widget = wibox.container.place
                },
                -- }}}
                -- {{{ Play-pause
                {
                    {
                        id = "playpause",
                        image = beautiful.playerctl_play,
                        forced_width = dpi(16),
                        forced_height = dpi(16),
                        widget = wibox.widget.imagebox
                    },
                    id = "playpausemargin",
                    forced_width = dpi(26),
                    forced_height = dpi(27),
                    buttons = awful.button({}, 1, function() playerctl:play_pause() end),
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
                    buttons = awful.button({}, 1, function() playerctl:next()       end),
                    widget = wibox.container.place
                },
                -- }}}
                id = "buttonslayout",
                layout = wibox.layout.align.horizontal
            },
            id = "buttonsmargin",
            -- Compensate for weird spacing issue on buttons
            left = dpi(6),
            right = dpi(3),
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
            text = " Nothing playing ",
            player = nil,
            player_visible = false,
            widget = wibox.widget.textbox
        },
        id = "infobg",
        bg = colors.gray3,
        buttons = awful.button({}, 1, function() awesome.emit_signal("playerctl::toggle_player_visibility") end),
        widget = wibox.container.background
    },
    -- }}}
    id = "layout",
    layout = wibox.layout.fixed.horizontal
    -- }}}
}
-- }}}

-- {{{ Signals
-- Change the play-pause button whenever the playing status changes
awesome.connect_signal("bling::playerctl::status", function(playing)
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
end)

-- Show or hide player whenever the info textbox is clicked
awesome.connect_signal("playerctl::toggle_player_visibility", function()
    -- Get the widget
    local info = widget:get_children_by_id("info")[1]
    local text = info.text
    local player = info.player
    local player_visible = info.player_visible

    -- If there isn't a player, return
    if player == nil or text == " Nothing playing " then return end

    -- Show/hide the player value on the text
    if player_visible then
        -- % sign escapes the square bracket
        info.text = text:gsub("%[" .. player .. "%] ", "")
    else
        info.text = text .. "[" .. player .. "] "
    end

    info.player_visible = not player_visible
end)

-- Change the text when the song changes
playerctl:connect_signal("metadata", function(_, title, artist, _, _, _, player)
    -- Check if stuff exists
    local title_exists  = exists(title )
    local artist_exists = exists(artist)
    local player_exists = exists(player)

    -- If there is no player (edge case) then say "Nothing playing"
    if not player_exists then
        widget:get_children_by_id("info")[1].text = " Nothing playing "
        return
    end

    local text = " "

    if title_exists and artist_exists then
        -- Add "artist - title" under normal conditions
        text   = text .. artist .. " - " .. title
    elseif title_exists then
        -- Add just the title in the case that there is no artist (e.g. playback of videos in Discord webpage)
        text   = text .. title
    else
        -- Set to "Nothing playing" when there is no title (YouTube reports no title when playback stops)
        text   = "Nothing playing"
    end

    -- Get the widget
    local info = widget:get_children_by_id("info")[1]

    -- Set the player to a widget property
    info.player = player

    -- Set the widget text
    info.text = " " .. text .. " "
end)
-- }}}

-- {{{ Return the widget
return widget
-- }}}
