local recolor = require("gears").color.recolor_image
local beautiful = require("beautiful")
local colors = beautiful.colorscheme
local geolist_icons = beautiful.geolist
local placeholder_icon = beautiful.awesome_icon_alt

local get = function(state)
    local returned = {
        icon = placeholder_icon,
        bg = beautiful.taglist_bg_normal
    }

    if state == "empty" then -- no clients on this tag

        returned.icon = recolor(geolist_icons.circle.hollow, colors.gray5)

    elseif state == "occupied" then -- one or more clients on this tag

        returned.icon = recolor(geolist_icons.circle.filled, colors.white)

    elseif state == "selected" then -- this tag is currently selected

        returned.icon = recolor(geolist_icons.rhombus.filled, colors.gray1)
        returned.bg = beautiful.taglist_bg_focus

    elseif state == "unfocused_current" then -- a window on the current tag is also present on this tag, but it is not focused

        returned.icon = recolor(geolist_icons.rhombus.filled, colors.gray3)

    elseif state == "focused_current" then -- a window on the current tag is also present on this tag, and it is focused

        returned.icon = recolor(geolist_icons.rhombus_filled, colors.white)

    elseif state == "urgent" then -- this tag has an urgent window

        returned.icon = recolor(geolist_icons.triangle, colors.gray1)
        returned.bg = beautiful.taglist_bg_urgent

    elseif state == "volatile" then -- this tag is volatile (i.e. will be deleted when all of its windows are untagged)

        returned.icon = recolor(geolist_icons.square, colors.gray1)
        returned.bg = beautiful.taglist_bg_volatile

    end

    return returned
end

return get
