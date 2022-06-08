local gears = require("gears")
local wibox = require("wibox")

local cairo = require("lgi").cairo
local math = require("math")

return function(options)
    local analog_clock = wibox.widget {
        nil,

        bgimage = function(_, cr, width, height)
            local m = math.min(width, height)
            local m2 = m / 2

            local second = os.date('%S')
            local minute = os.date('%M')
            local hour   = os.date('%H')

            local tmp_angle = 0

            if options.second.enable then
                local angle = (second / 60) * 2 * math.pi

                local w = options.second.w
                local h = options.second.h

                cr:translate(m2, m2)
                cr:rotate(angle)
                cr:translate(-m2, -m2)
                cr:set_source(gears.color(options.second.color))
                cr:rectangle(m2 - w/2, m2 - h, w, h)

                cr.antialias = cairo.Antialias.BEST
                cr:fill()

                tmp_angle = angle
            end

            if options.minute.enable then
                local minute_new = (options.second.enable and (minute + second/60) or minute)
                local angle = (minute_new / 60) * 2 * math.pi

                local w = options.minute.w
                local h = options.minute.h

                cr:translate(m2, m2)
                cr:rotate(-tmp_angle)
                cr:rotate(angle)
                cr:translate(-m2, -m2)
                cr:set_source(gears.color(options.minute.color))
                cr:rectangle(m2 - w/2, m2 - h, w, h)

                cr.antialias = cairo.Antialias.BEST
                cr:fill()

                tmp_angle = angle
            end

            if options.hour.enable then
                local hour_new = (options.minute.enable and (hour + minute/60) or hour)
                local angle = ((hour_new % 12) / 12) * 2 * math.pi

                local w = options.hour.w
                local h = options.hour.h

                cr:translate(m2, m2)
                cr:rotate(-tmp_angle)
                cr:rotate(angle)
                cr:translate(-m2, -m2)
                cr:set_source(gears.color(options.hour.color))
                cr:rectangle(m2 - w/2, m2 - h, w, h)

                cr.antialias = cairo.Antialias.BEST
                cr:fill()

                tmp_angle = angle
            end
        end,

        bg = options.background.color,
        shape = options.background.shape,

        id = 'background',
        widget = wibox.container.background
    }

    gears.timer {
        timeout = (
            options.second.enable and 1
            or (
                options.minute.enable and 60
                or (
                    options.hour.enable and 3600
                    or nil
                )
            )
        ),
        call_now = true,
        autostart = true,
        callback = function()
            analog_clock:emit_signal('widget::redraw_needed')
        end
    }

    return analog_clock
end
