local gears = require('gears')
local wibox = require('wibox')

local theme = require('beautiful').get()

local draw = require('widgets.wibar.clock.draw')

-- {{{ widget definition
local clock = wibox.widget {
	layout = wibox.container.rotate,
	direction = 'east', -- lowest hour is at the bottom

	forced_height = theme.clock.total_height,

	{
		id = 'horizontal',
		layout = wibox.layout.fixed.horizontal,
		spacing = theme.clock.gap,
		-- empty layout, widgets will be added later
	},
}
local container = clock:get_children_by_id('horizontal')[1]
local function new_hour_bar(draw_callback)
	return wibox.widget {
		layout = wibox.container.margin,
		left = 0,

		{
			layout = wibox.layout.stack,

			-- hour bar
			{
				widget = wibox.widget.progressbar,
				forced_width = theme.clock.bar_length,

				background_color = theme.clock.empty_color,
				color = theme.clock.filled_color,

				max_value = 60,
				value = 0,
			},

			-- battery/calendar ticks container stacked on top of hour bar
			{
				widget = wibox.widget.background,
				bgimage = draw_callback,
				nil
			}
		}
	}
end
-- }}}

-- {{{ helper functions
local function idx_to_hour(i)
	local hour = i - 1
	if hour == 0 then
		hour = 12
	end
	return hour
end

local function hour_to_idx(hour)
	-- mod 12 because 12 is the first one
	-- plus 1 to account for lua one-indexing
	return hour % 12 + 1
end

-- get the stack corresponding to the given hour (12 first, 11 last)
local function get_hour_stack(hour)
	-- .children[1] because all the bars are inside containers
	return container.children[hour_to_idx(hour)].children[1]
end

local function get_ticks_widget(hour)
	return get_hour_stack(hour).children[2]
end

local function set_hour_value(hour, value)
	get_hour_stack(hour).children[1].value = value
end
-- }}}

-- {{{ update clock
local function redraw()
	draw.prepare_redraw()
	-- TODO: THIS DOESN'T ACTUALLY DRAW ANYTHING
	for hour = 1, 12 do
		get_ticks_widget(hour):emit_signal('widget::redraw_needed')
	end
end

local function update_clock()
	local hour = tonumber(os.date('%I'))

	if hour == 12 then
		-- empty all bars except 12, we are at the start of the clock
		for i = 1, 11 do
			set_hour_value(i, 0)
		end
	elseif hour >= 1 then
		-- fill all bars below the current bar
		set_hour_value(12, 60)
		for i = 1, hour - 1 do
			set_hour_value(i, 60)
		end

		-- empty all bars above the current bar
		for i = hour + 1, 11 do
			set_hour_value(i, 0)
		end
	end

	-- set the value of the current bar
	set_hour_value(hour, tonumber(os.date('%M')))

	redraw()
end
-- }}}

-- init:
-- {{{ add hour bars to container
for i = 1, 12 do
	local hour_bar = new_hour_bar(draw.make_callback(idx_to_hour(i)))

	-- separate hour bars into four groups of 3 using extra margins
	if i ~= 1 and (i - 1) % 3 == 0 then
		-- add separator before 4th, 7th, and 10th bars
		hour_bar.left = theme.clock.large_gap - theme.clock.gap
	end

	container:add(hour_bar)
end
-- }}}

-- {{{ register signals
-- update hour bars periodically and on system resume
gears.timer {
	-- six minutes
	timeout = 360,
	autostart = true,
	call_now = true,
	callback = update_clock
}
awesome.connect_signal('system::resume', update_clock)

-- redraw event ticks when signalled
awesome.connect_signal('calendar::update', redraw)
-- }}}

return clock
