local gears = require("gears")
local wibox = require("wibox")

local cairo = require("lgi").cairo
local math = require("math")

local function create_second_pointer(second, color)
    local img = cairo.ImageSurface(cairo.Format.ARGB32, 1000, 1000)
    local cr = cairo.Context(img)
    local angle = (second / 60) * 2 * math.pi
    cr:translate(500, 500)
    cr:rotate(angle)
    cr:translate(-500, -500)
    cr:set_source(gears.color(color))
    cr:rectangle(475, 100, 50, 480)
    cr:fill()
    cr:set_antialias('ANTIALIAS_DEFAULT')
    return img
end

local function create_minute_pointer(minute, color)
    local img = cairo.ImageSurface(cairo.Format.ARGB32, 1000, 1000)
    local cr = cairo.Context(img)
    local angle = (minute / 60) * 2 * math.pi
    cr:translate(500, 500)
    cr:rotate(angle)
    cr:translate(-500, -500)
    cr:set_source(gears.color(color))
    cr:rectangle(460, 100, 80, 420)
    cr:fill()
    cr:set_antialias('ANTIALIAS_DEFAULT')
    return img
end

local function create_hour_pointer(hour, color)
    local img = cairo.ImageSurface(cairo.Format.ARGB32, 1000, 1000)
    local cr = cairo.Context(img)
    local angle = ((hour % 12) / 12) * 2 * math.pi
    cr:translate(500, 500)
    cr:rotate(angle)
    cr:translate(-500, -500)
    cr:set_source(gears.color(color))
    cr:rectangle(447, 200, 106, 320)
    cr:fill()
    cr:set_antialias('ANTIALIAS_SUBPIXEL')
    return img
end

return function(second_color, minute_color, hour_color, bg_color, timeout)
    local has_second = second_color ~= nil
    local has_minute = minute_color ~= nil
    local has_hour   = hour_color   ~= nil

    local second_pointer = (has_second and create_second_pointer(57, second_color) or nil)
    local minute_pointer = (has_minute and create_minute_pointer(37, minute_color) or nil)
    local hour_pointer   = (has_hour   and create_hour_pointer(17, hour_color)     or nil)

    local second_pointer_img = (has_second and wibox.widget.imagebox() or nil)
    local minute_pointer_img = (has_minute and wibox.widget.imagebox() or nil)
    local hour_pointer_img   = (has_hour   and wibox.widget.imagebox() or nil)

    local analog_clock = wibox.widget {
        {
            nil,
            shape = function(cr, width, height) gears.shape.circle(cr, width, height, height / 2) end,
            bg = bg_color,
            widget = wibox.container.background
        },
        second_pointer_img,
        minute_pointer_img,
        hour_pointer_img,
        layout = wibox.layout.stack
    }

    local second = (has_second and 0 or nil)
    local minute = (has_minute and 0 or nil)
    local hour   = (has_hour   and 0 or nil)

    gears.timer {
        timeout = timeout,
        call_now = true,
        autostart = true,
        callback = function()
            second = (has_second and os.date("%S") or nil)
            minute = (has_minute and os.date("%M") or nil)
            hour   = (has_hour   and os.date("%H") or nil)

            if has_second then
                second_pointer = create_second_pointer(second, second_color)
                second_pointer_img.image = second_pointer
            end

            if has_minute then
                minute_pointer = create_minute_pointer(minute, minute_color)
                minute_pointer_img.image = minute_pointer
            end

            if has_hour   then
                hour_pointer   = create_hour_pointer(hour + (minute / 60), hour_color)
                hour_pointer_img.image = hour_pointer
            end

        end
    }

    return analog_clock
end