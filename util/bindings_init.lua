local awful = require("awful")
local gears = require("gears")

local keys = require("util.keys")

-- Mouse bindings
root.buttons(gears.table.join(
    awful.button({ }, 3, function () mainmenu:toggle() end),
    awful.button({ }, 4, awful.tag.viewprev),
    awful.button({ }, 5, awful.tag.viewnext)
))

-- Key bindings
root.keys(keys.globalkeys)
