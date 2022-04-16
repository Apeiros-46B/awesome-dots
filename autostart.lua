local awful = require("awful")

awful.spawn("picom --config " .. os.getenv("HOME") .. "/.config/awesome/external/picom/picom.conf", false)
awful.spawn("xset r rate 350 60", false)
