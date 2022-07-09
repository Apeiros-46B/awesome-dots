local wibox = require("wibox")
local dpi = require("beautiful.xresources").apply_dpi

local padding = wibox.widget {
    nil,
    right = dpi(8),
    widget = wibox.container.margin,
}

return padding
