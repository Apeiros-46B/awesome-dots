-- Wrapper around Bling's playerctl module
-- Planned support for cycling between different players manually

-- {{{ Library imports
local playerctl = require("bling").signal.playerctl.lib()
local beautiful = require("beautiful")
local gtable    = require("gears").table
local table     = table
-- }}}

-- {{{ Initialize table
local M = {}
-- }}}

-- {{{ Player cycling [WIP]
-- Player variables
M.player            = ""
M.players           = {}

M.player_priority   = beautiful.playerctl_player
M.update_activity   = beautiful.playerctl_update_on_activity

-- Set player to the one specified
function M.set_player(player)
    M.player        = player

    if not gtable.hasitem(M.players, player) then
        M.add_player (player)
    end

    playerctl:emit_signal("player_changed", playerctl, player)
end

-- Add a player to the table but don't select it
function M.add_player(player)
    table.insert(M.players, player)

    playerctl:emit_signal("player_added", playerctl, player)
end

-- Select the previous player
function M.prev_player()
    local idx = gtable.cycle_value(M.players, M.player, -1)
    if idx then M.set_player(M.players[idx]) end
end

-- Select the next player
function M.next_player()
    local idx = gtable.cycle_value(M.players, M.player,  1)
    if idx then M.set_player(M.players[idx]) end
end

-- Reset the player(s)
function M.reset_players()
    M.player        = ""
    M.players       = {}
end

-- Choose a new player if the current one exits
playerctl:connect_signal("exit", function(_, player)
    table.remove(M.players, player)

    if player == M.player then
        M.next_player()
    end
end)

-- When there are no more players, reset the player variables
playerctl:connect_signal("no_players", M.reset_players)
-- }}}

-- {{{ Store metadata
-- Metadata variables
M.artist        = ""
M.title         = ""
M.album         = ""
M.album_art     = ""
M.new           = ""

-- Update metadata every time the track changes
playerctl:connect_signal("metadata", function(_, title, artist, album_path, album, new, player)
    M.artist    = artist
    M.title     = title
    M.album     = album
    M.album_art = album_path
    M.new       = new

    if M.update_activity then
        M.set_player(player)
    else
        M.add_player(player)
    end
end)
-- }}}

-- {{{ Basics
-- Previous, play/pause, and next
function M.prev()
    playerctl:previous()
    M.pos = 0
end

function M.play_pause()
    playerctl:play_pause()
end

function M.next()
    playerctl:next()
    M.pos = 0
end
-- }}}

-- {{{ Position
-- Current position
M.pos = 0

-- Track length
M.max = 0

-- Rewind
function M.rew(seconds)
    local new_pos = M.pos - seconds

    -- Don't rewind before the beginning of the track
    new_pos = new_pos < 0 and 0 or new_pos

    -- Set position & return
    M.pos = new_pos
    playerctl:set_position(M.pos)
end

-- Fast forward
function M.fwd(seconds)
    local new_pos = M.pos + seconds

    -- Don't fast forward past the end of the track
    if new_pos > M.max then return end

    -- Set position & return
    M.pos = new_pos
    playerctl:set_position(M.pos)
end

-- Seek
function M.seek(seconds)
    playerctl:set_position(seconds)
    playerctl:emit_signal("position", seconds, M.max, M.player)
end

-- Update position
playerctl:connect_signal("position", function(_, interval, length, _)
    M.pos = interval
    M.max = length
end)
-- }}}

-- {{{ Shuffle & loop
-- Current shuffle state
M.shuffle    = false

-- Current loop state
M.loop       = 1

-- Valid loop states (string:number)
M.loops_int  = { none = 0, track = 1, playlist = 2 }

-- Valid loop states (number:string)
M.loops_str  = {"none",   "track",   "playlist"    }

-- Set shuffle state
function M.set_shuffle(shuffle)
    if shuffle == nil then
        M.toggle_shuffle()
    else
        playerctl:set_shuffle(shuffle)
    end
end

-- Toggle shuffle state
function M.toggle_shuffle()
    M.set_shuffle(not M.shuffle)
end

-- Set loop state
function M.set_loop(loop)
    if loop == nil then
        -- Cycle if no args provided
        M.cycle_loop()
    else
        playerctl:set_loop_status(loop)
    end
end

-- Cycle loop state
function M.cycle_loop()
    -- Set the value to a local var
    local i = M.loop

    -- Cycle
    i = i - 1

    -- Make sure it doesn't get out of bounds
    if i < 0 then i = i + 3 end

    -- Change the loop mode
    M.loop = i
    M.set_loop(i)
end

-- Update the shuffle state
playerctl:connect_signal("shuffle",     function(_, shuffle, _)     M.shuffle = shuffle                  end)

-- Update the loop state
playerctl:connect_signal("loop_status", function(_, loop_status, _) M.loop    = M.loops_int[loop_status] end)
-- }}}

-- {{{ Return table
-- Add the playerctl object to the table
M.playerctl = playerctl

-- Return
return M
-- }}}
