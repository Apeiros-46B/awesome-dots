-- {{{ Libraries
local awful = require("awful")
local gears = require("gears")
local beautiful = require("beautiful")
-- }}}

-- {{{ Tag layouts
tag.connect_signal("request::default_layouts", function()
    awful.layout.append_default_layouts({
        awful.layout.suit.tile,
        awful.layout.suit.fair,
        awful.layout.suit.spiral,
        awful.layout.suit.spiral.dwindle,
        awful.layout.suit.floating,
    })
end)
-- }}}

-- {{{ Wallpaper
-- {{{ Function for setting the wallpaper
local function set_wallpaper(s)
    local file = beautiful.wallpaper

    if beautiful.random_wallpaper then
        file = gears.filesystem.get_random_file_from_dir(
            beautiful.wallpaper_path,
            {
                "jpg",
                "png"
            },
            true
        )
    end

    gears.wallpaper.maximized(file, s, true)
end
-- }}}

-- Re-set wallpaper when a screen's geometry changes (e.g. different resolution)
screen.connect_signal("property::geometry", set_wallpaper)
-- }}}

-- {{{ Desktop decoration
screen.connect_signal("request::desktop_decoration", function(s)
    -- Set tags
    awful.tag({ "I", "II", "III", "IV", "V", "VI", "VII", "VIII" }, s, awful.layout.layouts[1])

    -- Set wallpaper
    set_wallpaper(s)

    -- Wibar
    require("module.wibar")(s)
end)
-- }}}
