local gtable = require('gears.table')

local theme = require('beautiful').get()

local util = require('util')

--- @class Event
--- @field id UUID
--- @field color string
--- @field start_time number
--- @field start_date osdate
--- @field end_date osdate
local Event = {
	id = '',

	name = 'Unnamed Event',
	color = theme.colors.green,

	start_time = -1, -- seconds (-1 = uninit)
	duration = 0,    -- seconds ( 0 = none)
	period = 0,      -- days    ( 0 = none)
}
Event.__index = Event

-- {{{ construct
--- @param args table?
--- @return Event
local function new(args)
	local o = args or {}
	o = setmetatable(o, Event)

	if o.id == '' then
		o.id = util.uuid()
	end
	if o.start_time == -1 then
		o.start_time = os.time()
	end

	o.start_date = os.date('*t', o.start_time) --[[@as osdate]]

	if o.duration ~= 0 then
		o.end_date = os.date('*t', o.start_time + o.duration) --[[@as osdate]]
	end

	return o
end

function Event:new(args)
	local o = gtable.clone(args)
	return new(o)
end

--- @param seconds number
--- @param args table?
--- @return Event
function Event:new_from_now(seconds, args)
	args = args and gtable.clone(args) or {}
	args.start_time = os.time() + seconds
	return Event:new(args)
end

--- @param seconds number
--- @return Event
function Event:new_from_self(seconds)
	local this = gtable.clone(self)
	this.start_time = this.start_time + seconds
	return Event:new(this)
end
-- }}}

-- {{{ de/serialize
--- @return string
function Event:to_str()
	return ([[id=%s name='%s' color=%s start=%d duration=%d period=%s]]):format(
		self.id,
		self.name,
		self.color,
		self.start_time,
		self.duration,
		self.period
	)
end

local pattern = table.concat({
	'id=(' .. util.uuid_pattern .. ')',
	"name='([^']+)'",
	'color=(#%x%x%x%x%x%x)',
	'start=(%d+)',
	'duration=(%d+)',
	'period=(%d+)',
}, ' ')

--- @param str string
--- @return Event
function Event:from_str(str)
	local id, name, color, start_time, duration, period = str:match(pattern)
	return Event:new {
		id = id,
		name = name,
		color = color,
		start_time = tonumber(start_time),
		duration = tonumber(duration),
		period = tonumber(period),
	}
end
-- }}}

-- {{{ utility
--- @return boolean
function Event:repeating()
	return self.period ~= 0
end

--- @return boolean
function Event:has_duration()
	return self.duration ~= 0
end

--- @return osdate
function Event:get_end_date()
	if not self:has_duration() then
		return self.start_date
	else
		return self.end_date
	end
end

-- return the next occurrence of a recurring event
--- @return Event
function Event:get_next_occurrence()
	-- TODO: events on specific weekdays, events every month, daylight savings
	if not self:repeating() then
		return self
	else
		local period_seconds = self.period * 24 * 60 * 60
		local recurrences = math.ceil((os.time() - self.start_time) / period_seconds)
		return self:new_from_self(recurrences * period_seconds)
	end
end
-- }}}

return Event
