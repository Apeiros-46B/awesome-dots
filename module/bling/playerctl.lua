-- Imports
local naughty = require("naughty")
local bling = require("bling")
local playerctl = bling.signal.playerctl.lib()

-- Music notifier
playerctl:connect_signal("metadata", function(_, title, artist, album_path, album, new, player)
    if new then
        local notif_title = " " .. title .. " [" .. player .. "]"
        local notif_text_1 = (artist ~= "" and artist ~= nil) and "by " .. artist         or "No artist"
        local notif_text_2 = (album  ~= "" and album  ~= nil) and " (on " .. album .. ")" or ""

        naughty.notify({ title = notif_title, text = notif_text_1 .. notif_text_2, image = album_path })
    end
end)
