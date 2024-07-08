local theme = require('beautiful').get()

local calendar = require('lib').calendar

local util  = require('util')

local M = {}

---@type table<UUID, boolean>
local finished_draw = {}
local finished_all = false
local date = os.date('*t')
local time = os.time()

function M.prepare_redraw()
	finished_draw = {}
	finished_all = false
	date = os.date('*t')
	time = os.time()
end

-- {{{ helper functions
local function to_12h(hour24)
	local hour12 = hour24 % 12
	if hour12 == 0 then
		hour12 = 12
	end
	return hour12
end

local function same_12h_span(hour24, hour24_)
	if hour24 < 12 and hour24_ < 12 then
		-- both AM
		return true
	elseif hour24 >= 12 and hour24_ >= 12 then
		-- both PM
		return true
	else
		return false
	end
end

-- return: 4 values
-- 1. should we draw anything for this event on the current hour bar?
-- 2. is this the last time this event will be drawn on the current clock?
-- 3. start minute on the hour bar (nil if not drawing)
-- 4. end minute on the hour bar (nil if not drawing)
---@param evt Event
local function span_within_hour(evt, hour12)
	local start_h12 = to_12h(evt.start_date.hour)

	if not evt:has_duration() then
		-- no duration
		if start_h12 == hour12 then
			-- event happens in the current hour
			return true, true, evt.start_date.min, evt.start_date.min
		else
			-- event doesn't happen
			return false, false, nil, nil
		end
	end

	local end_date = evt:get_end_date()
	local end_h12 = to_12h(end_date.hour)

	local start_same_h12 = start_h12 == hour12
	local end_same_h12 = end_h12 == hour12

	local start_before = start_h12 < hour12
	local end_after = end_h12 > hour12

	if start_same_h12 and end_same_h12 then
		return true, true, evt.start_date.min, end_date.min
	elseif start_same_h12 and end_after then
		return true, false, evt.start_date.min, 59
	elseif start_before and end_after then
		return true, false, 0, 59
	elseif start_before and end_same_h12 then
		return true, true, 0, end_date.min
	else
		return false, false, nil, nil
	end
end
-- }}}

local W = theme.clock.tick_thickness

local function fill_from_mins(cr, h, color, min_start, min_end)
	-- everything this draws is rotated 90deg CCW by the rotate container
	local thickness = W
	if min_start ~= min_end then
		thickness = (min_end - min_start + 1)/60 * theme.clock.bar_length
	end
	local x = min_start/60 * theme.clock.bar_length

	cr:set_source(require('gears').color(color))
	cr:rectangle(x, 0, thickness, h)
	cr:fill()
end

function M.make_callback(hour12)
	---@param evt Event
	local function draw(cr, h, evt)
		-- {{{ preconditions
		-- time is already past this hour bar, therefore no events should be drawn
		if to_12h(date.hour) > hour12 then
			-- other bars still need to draw this event! we are not setting finished_draw
			return
		end

		evt = evt:get_next_occurrence()

		-- event isn't today
		if evt.start_date.day ~= date.day and evt.end_date.day ~= date.day then
			-- other bars do not need to draw it
			finished_draw[evt.id] = true
			return
		end

		-- event has already passed
		if time > evt.start_time + evt.duration then
			-- other bars do not need to draw it
			finished_draw[evt.id] = true
			return
		end

		local same_start_span = same_12h_span(evt.start_date.hour, date.hour)
		local same_end_span = same_12h_span(evt:get_end_date().hour, date.hour)

		-- event isn't in the same 12-hour span as current time (one AM, one PM)
		if not same_start_span and not same_end_span then
			-- other bars do not need to draw it
			finished_draw[evt.id] = true
			return
		end
		-- }}}

		local should_draw, last_draw, start_min, end_min = span_within_hour(evt, hour12)
		if last_draw then
			finished_draw[evt.id] = true
		end
		if not should_draw then
			return
		end

		-- if the progressbar is on the current hour bar, we shouldn't draw over it
		if to_12h(date.hour) == hour12 then
			start_min = math.max(start_min --[[@as number]], date.min --[[@as number]])
		end

		fill_from_mins(cr, h, evt.color, start_min, end_min)
	end

	return function (_, cr, _, h)
		if finished_all then
			return
		end

		for _, evt in pairs(calendar.evts) do
			if not finished_draw[evt.id] then
				local ok, err = pcall(draw, cr, h, evt)
				if not ok then
					require('naughty').emit_signal('request::display_error', err)
				end
			end
		end
	end
end

return M
