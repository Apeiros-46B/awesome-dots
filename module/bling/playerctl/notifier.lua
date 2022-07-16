-- Imports
local playerctl = require("bling").signal.playerctl.lib()
local notify = require("module.notify")

-- Helper function
local function exists(string)
    return string ~= "" and string ~= nil
end

-- Music notifier
playerctl:connect_signal("metadata", function(_, title, artist, album_path, album, new, player)
    -- Check if stuff exists
    local title_exists  = exists(title )
    local artist_exists = exists(artist)
    local album_exists  = exists(album )
    local player_exists = exists(player)

    -- If the playback isn't new then return
    if not new           then return end
    -- If there is no player (edge case) then return
    if not player_exists then return end
    -- If there is no title then return
    -- if not title_exists  then return end

    -- Prefix for title
    local notif_title = " "

    if title_exists and artist_exists then
        -- Add "artist - title" under normal conditions
        notif_title   = notif_title .. artist .. " - " .. title
    elseif title_exists then
        -- Add just the title in the case that there is no artist (e.g. playback of videos in Discord webpage)
        notif_title   = notif_title .. title
    end

    -- Add player text
    local notif_text  = "[" .. player .. "]"

    if album_exists then
        -- Add album text before player text if album exists
        notif_text    = "(on " .. album .. ") " .. notif_text
    end

    notify({ title = notif_title, message = notif_text, image = album_path, app_name = "bling_playerctl_notifier", replaces = true })
end)
