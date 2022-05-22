local gears = require("gears")
local wibox = require("wibox")

local cairo = require("lgi").cairo
local math = require("math")

local function create_minute_pointer(minute, color)
    local img = cairo.ImageSurface(cairo.Format.ARGB32, 1000, 1000)
    local cr = cairo.Context(img)
    local angle = (minute / 60) * 2 * math.pi
    cr:translate(500, 500)
    cr:rotate(angle)
    cr:translate(-500, -500)
    cr:set_source(gears.color(color))
    -- cr:rectangle(485, 100, 30, 420)
    cr:rectangle(460, 100, 80, 420) -- thicker line
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
    -- cr:rectangle(480, 200, 40, 320)
    cr:rectangle(447, 200, 106, 320) -- thicker line
    cr:fill()
    cr:set_antialias('ANTIALIAS_SUBPIXEL')
    return img
end

local function return_widget(hand_color, bg_color)
    local minute_pointer = create_minute_pointer(37, hand_color)
    local hour_pointer = create_hour_pointer(17, hand_color)

    local minute_pointer_img = wibox.widget.imagebox()
    local hour_pointer_img = wibox.widget.imagebox()

    local analog_clock = wibox.widget {
        { -- circle
            nil,
            shape = function(cr, width, height) gears.shape.circle(cr, width, height, height / 2) end,
            bg = bg_color,
            widget = wibox.container.background
        },
        minute_pointer_img,
        hour_pointer_img,
        layout = wibox.layout.stack
    }

    local minute = 0
    local hour = 0

    gears.timer {
        timeout = 30,
        call_now = true,
        autostart = true,
        callback = function()
            minute = os.date("%M")
            hour = os.date("%H")
            minute_pointer = create_minute_pointer(minute, hand_color)
            hour_pointer = create_hour_pointer(hour + (minute / 60), hand_color)
            minute_pointer_img.image = minute_pointer
            hour_pointer_img.image = hour_pointer
        end
    }

    return analog_clock
end

return return_widget
