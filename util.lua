---@alias UUID string

local M = {}

function M.clamp(x, min, max)
	return math.max(min, math.min(max, x))
end

M.uuid_pattern = ('xxxxxxxx%-xxxx%-4xxx%-xxxx%-xxxxxxxxxxxx'):gsub('x', '%%x')

---@return UUID
function M.uuid()
	local template ='xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx'
	local res, _ = template:gsub('[xy]', function(c)
		local v = (c == 'x') and math.random(0, 0xf) or math.random(8, 0xb)
		return ('%x'):format(v)
	end)
	return res
end

-- {{{ table utilities
-- assumes no circular reference
---@param set table<any, boolean>
---@return any[]
function M.set_to_list(set)
	local list = {}
	for k, _ in pairs(set) do
		list[#list+1] = k
	end
	return list
end
-- }}}

-- {{{ debug utilities
-- assumes no circular reference
local function dbg_rec(o, buf, level)
	level = level or 0
	if type(o) == 'string' then
		buf[#buf+1] = ('%q'):format(o)
	elseif type(o) == 'table' then
		buf[#buf+1] = '{\n'
		for k, v in pairs(o) do
			buf[#buf+1] = ('  '):rep(level + 1) .. k .. ' = '
			dbg_rec(v, buf, level + 1)
			buf[#buf+1] = '\n'
		end
		buf[#buf+1] = ('  '):rep(level) .. '}'
	else
		buf[#buf+1] = tostring(o)
	end
end

function M.dbg(o)
	local buf = {}
	dbg_rec(o, buf)
	return table.concat(buf)
end

---@param o any
---@param msg string?
function M.inspect(o, msg)
	msg = msg or ''
	require('naughty').notify {
		-- urgency = 'critical',
		title = msg,
		text = M.dbg(o)
	}
	return o
end
-- }}}

function M.spawn_multi(cmds)
	for _, cmd in pairs(cmds) do
		require('awful').spawn(cmd, false)
	end
end

return M
