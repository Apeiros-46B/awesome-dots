local theme = require('beautiful').get()

local Event = require('signals.calendar.event')
local util = require('util')

local M = {}
local first = true

---@type table<UUID, Event>
M.evts = {}

-- {{{ de/serialization
local function save_to_file()
	local buf = {}
	for _, evt in pairs(M.evts) do
		buf[#buf+1] = evt:to_str()
	end

	local f = assert(io.open(theme.settings.calendar_path, 'w'))
	f:write(table.concat(buf, '\n'))
	f:close()
end

local function read_from_file()
	local f = io.open(theme.settings.calendar_path, 'r')
	if not f then
		-- first time creating a calendar
		return
	end

	for line in f:lines() do
		if line ~= '' then
			local evt = Event:from_str(line)
			M.evts[evt.id] = evt
		end
	end

	f:close()
end
-- }}}

local function on_update()
	-- don't save immediately after reading
	if not first then
		save_to_file()
	end

	awesome.emit_signal('calendar::update')
	first = false
end

function M.init()
	read_from_file()
	require('gears').timer.delayed_call(on_update)
end

---@param evt Event
function M.add(evt)
	evt.id = evt.id or util.uuid()
	M.evts[evt.id] = evt
	on_update()
end

---@param id UUID
function M.remove(id)
	M.evts[id] = nil
	on_update()
end

---@param id UUID
---@param k string
---@param v any
function M.update(id, k, v)
	M.evts[id][k] = v
	on_update()
end

return M
