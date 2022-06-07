local gears = require("gears")
local wibox = require("wibox")

local cairo = require("lgi").cairo
local math = require("math")

local colors = require("beautiful").colorscheme

local test_table = {
    background = {
        enable = true,
        shape = gears.shape.losange,
        color = colors.gray1
    },

    second = {
        enable = false,
        color = colors.teal
    },

    minute = {
       enable = true,
       color = colors.teal
    },

    hour = {
        enable = true,
        color = colors.teal
    }
}

return function(options)
    local hands = wibox.widget.base.make_widget()
    hands.options = options

    function hands:fit(_, width, height)
        local m = math.min(width, height)
        return m, m
    end

    function hands:draw(_, cr, width, height)
        cr.antialias = cairo.Antialias.BEST

        local second = hands.second
        local minute = hands.minute
        local hour   = hands.hour

        local m = math.min(width, height)
        local md2 = m / 2

        local angle_1 = (second / 60) * 2 * math.pi
        cr:translate(md2, md2)
        cr:rotate(angle_1)
        cr:translate(-md2, -md2)
        cr:set_source(gears.color(hands.options.second.color))
        cr:rectangle(md2 - (m / 40), m / 10, m / 20, md2 - (m / 50))
        cr:fill()

        local angle_2 = (minute / 60) * 2 * math.pi
        cr:translate(md2, md2)
        cr:rotate(angle_2)
        cr:translate(-md2, -md2)
        cr:set_source(gears.color(hands.options.minute.color))
        cr:rectangle(md2 - (m / 25), m / 10, m / 12.5, md2 - (m / 12.5))
        cr:fill()

        local angle_3 = ((hour % 12) / 12) * 2 * math.pi
        cr:translate(md2, md2)
        cr:rotate(angle_3)
        cr:translate(-md2, -md2)
        cr:set_source(gears.color(hands.options.hour.color))
        cr:rectangle(md2 - (m / 20), m / 5, m / 10, md2 - (m / 6))
        cr:fill()
    end

    hands:connect_signal("analog_clock::second", function(value)
        hands.second = value
        hands:emit_signal("widget::redraw_needed")
    end)

    hands:connect_signal("analog_clock::minute", function(value)
        hands.minute = value
        hands:emit_signal("widget::redraw_needed")
    end)

    hands:connect_signal("analog_clock::hour", function(value)
        hands.hour = value
        hands:emit_signal("widget::redraw_needed")
    end)

    local timeout = (
        options.second.enable and 1
        or (
            options.minute.enable and 60
            or (
                options.hour.enable and 3600
                or nil
            )
        )
    )

    if timeout == nil then return nil end

    gears.timer {
        timeout = timeout,
        call_now = true,
        autostart = true,
        callback = function()
            local second = os.date('%S')

            local minute_orig = os.date('%M')
            local minute = (options.second.enable and minute_orig + (second / 60) or minute_orig)

            local hour_orig   = os.date('%H')
            local hour   = (options.minute.enable and hour_orig   + (minute / 60) or hour_orig  )

            if options.second.enable then hands:emit_signal("analog_clock::second", second)   end
            if options.minute.enable then hands:emit_signal("analog_clock::minute", minute)   end
            if options.hour.enable   then hands:emit_signal("analog_clock::hour",   hour  )   end
        end
    }

    if not options.background.enable then return hands end

    local bg = wibox.widget {
        hands,

        bg = options.background.color,
        shape = options.background.shape,

        id = 'background',
        widget = wibox.container.background
    }

    return bg
end
