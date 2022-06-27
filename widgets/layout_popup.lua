local awful = require("awful")
local gears = require("gears")
local wibox = require("wibox")

local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi
local colors = beautiful.colorscheme

local ll = awful.widget.layoutlist {
    base_layout = wibox.widget {
        spacing         = 5,
        forced_num_cols = 5,
        layout          = wibox.layout.grid.vertical,
    },
    widget_template = {
        {
            {
                id            = 'icon_role',
                forced_height = dpi(27),
                forced_width  = dpi(27),
                widget        = wibox.widget.imagebox,
            },
            margins = dpi(0),
            widget  = wibox.container.margin,
        },
        id              = 'background_role',
        forced_width    = dpi(27),
        forced_height   = dpi(27),
        bg              = colors.gray3,
        widget          = wibox.container.background,
    },
}

local layout_popup = awful.popup {
    widget = wibox.widget {
        ll,
        margins = dpi(4),
        widget  = wibox.container.margin,
    },
    border_color = beautiful.border_color,
    border_width = beautiful.border_width,
    placement    = awful.placement.centered,
    ontop        = true,
    visible      = false,
    -- shape        = gears.shape.rounded_rect
}

-- Make sure you remove the default Mod4+Space and Mod4+Shift+Space
-- keybindings before adding this.
awful.keygrabber {
    start_callback = function() layout_popup.visible = true  end,
    stop_callback  = function() layout_popup.visible = false end,
    export_keybindings = true,
    release_event = 'release',
    stop_key = {'Escape', 'Super_L', 'Super_R'},
    keybindings = {
        {{ "Mod4"          } , "y" , function()
            awful.layout.inc( 1)
        end},
        {{ "Mod4", "Shift" } , "y" , function()
            awful.layout.inc(-1)
        end},
    }
}
