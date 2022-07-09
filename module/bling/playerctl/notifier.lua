-- Imports
local playerctl = require("bling").signal.playerctl.lib()
local notify = require("module.notify")

-- Helper function
local function exists(string)
    return string ~= "" and string ~= nil
end

-- Music notifier
playerctl:connect_signal("metadata", function(_, title, artist, album_path, album, new, player)
    local title_exists  = exists(title )
    local artist_exists = exists(artist)
    local album_exists  = exists(album )
    local player_exists = exists(player)

    if not new           then return end
    if not player_exists then return end

    -- local notif_title  = " " .. title .. " [" .. player .. "]"
    -- local notif_text_1 = artist_exists and "by " .. artist         or "No artist"
    -- local notif_text_2 = album_exists  and " (on " .. album .. ")" or ""
    -- local notif_text   = notif_text_1 .. notif_text_2

    -- Prefix
    local notif_title = " "

    if title_exists and artist_exists then

        notif_title   = notif_title .. artist .. " - " .. title

    elseif title_exists then

        notif_title   = notif_title .. title

    else
        -- YouTube reports no artist when playback stops
        notif_title   = notif_title .. "Playback stopped"

    end

    local notif_text  = (album_exists and "(on " .. album .. ") " or "") .. "[" .. player .. "]"

    notify({ title = notif_title, message = notif_text, image = album_path, app_name = "bling_playerctl_notifier", replaces = true })
end)
