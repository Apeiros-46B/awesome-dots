-- {{{ Library imports
-- Core libraries
local gears = require("gears")
local wibox = require("wibox")

-- Cairo and lua's math
local cairo = require("lgi").cairo
local math = require("math")
-- }}}

-- {{{ Function for drawing a single hand
local function draw_hand(cr, m2, tmp_angle, is_hour, value, options)
    -- Get the angle the context needs to be rotated by
    local angle

    if is_hour then
        angle = ((value % 12) / 12) * 2 * math.pi
    else
        angle = ( value / 60) * 2       * math.pi
    end

    -- Get the width and height of the hand
    local w = options.w
    local h = options.h

    -- Prepare for rotation
    cr:translate(m2, m2)

    -- Rotate back to original angle
    cr:rotate(-tmp_angle)

    -- Rotate to new angle
    cr:rotate(angle)

    -- Go back to original location
    cr:translate(-m2, -m2)

    -- Draw the hand
    cr:set_source(gears.color(options.color))

    -- The subtraction for the first two parameters makes sure that
    -- the bases of the hands are on the center of the context
    cr:rectangle(m2 - w/2, m2 - h, w, h)

    -- Fill the context
    cr:fill()

    -- Return new angle for next hand
    return angle
end
-- }}}

-- {{{ Function to draw all hands
local function draw_hands(_, cr, width, height, options)
    -- Make sure antialias is set to BEST
    cr.antialias = cairo.Antialias.BEST

    -- Variable definitions
    local m2 = math.min(width, height) / 2
    local tmp_angle = 0

    -- Get the current time
    local second = os.date('%S')
    local minute = os.date('%M')
    local hour   = os.date('%H')

    -- Angle correction
    local minute_new = (options.second.enable and (minute + second/60) or minute)
    local hour_new   = (options.minute.enable and (hour   + minute/60) or hour  )

    -- Draw hands
    if options.second.enable then tmp_angle = draw_hand(cr, m2, tmp_angle, false, second,     options.second) end
    if options.minute.enable then tmp_angle = draw_hand(cr, m2, tmp_angle, false, minute_new, options.minute) end
    if options.hour.enable   then tmp_angle = draw_hand(cr, m2, tmp_angle, true,  hour_new,   options.hour  ) end
end
-- }}}

-- {{{ Return function
return function(options)
    -- {{{ Create the widget
    local analog_clock = wibox.widget {
        -- Set the contained widget to nil since we don't need one,
        -- we draw everything in the bgimage function
        nil,

        -- Function for drawing hands
        bgimage = function(_, cr, width, height)
            draw_hands(_, cr, width, height, options)
        end,

        bg = options.background.color,
        shape = options.background.shape,

        id = 'analog_clock',
        widget = wibox.container.background
    }
    -- }}}

    -- {{{ Start the update timer
    gears.timer {
        -- Get timeout based on requirements
        timeout = ( options.second.enable and 1    or (
                    options.minute.enable and 60   or (
                    options.hour.enable   and 3600 or nil ))),

        -- Timer options
        call_now = true,
        autostart = true,

        -- Update the clock using redraw signal
        callback = function()
            analog_clock:emit_signal('widget::redraw_needed')
        end
    }
    -- }}}

    -- Return the widget
    return analog_clock
end
-- }}}
