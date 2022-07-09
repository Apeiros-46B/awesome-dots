local awful = require("awful")

local interval = 10

local mb_format = true -- MB of usage
-- local mb_format = false -- percentage usage

awful.widget.watch("cat /proc/meminfo", interval, function(_, stdout)
    local mem_total = tonumber(stdout:match("MemTotal: *(%d*) kB"))
    local shmem = tonumber(stdout:match("Shmem: *(%d*) kB"))
    local mem_free = tonumber(stdout:match("MemFree: *(%d*) kB"))
    local buffers = tonumber(stdout:match("Buffers: *(%d*) kB"))
    local cached = tonumber(stdout:match("Cached: *(%d*) kB"))
    local sreclaimable = tonumber(stdout:match("SReclaimable: *(%d*) kB"))

    local usage = math.floor((mem_total + shmem - mem_free - buffers - cached - sreclaimable) / 1024)
    local total = math.floor(mem_total / 1024)
    local percent = usage / total * 100

    awesome.connect_signal("sysinfo::memory::format_changed", function()
        mb_format = not mb_format
    end)

    if mb_format then
        awesome.emit_signal("sysinfo::memory", usage, percent, "mb")
    else
        awesome.emit_signal("sysinfo::memory", percent, percent, "%")
    end
end)
