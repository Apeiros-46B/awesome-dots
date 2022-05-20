local awful = require("awful")

local interval = 10

awful.widget.watch("cat /proc/meminfo", interval, function(_, stdout)
    local mem_total = tonumber(stdout:match("MemTotal: *(%d*) kB"))
    local shmem = tonumber(stdout:match("Shmem: *(%d*) kB"))
    local mem_free = tonumber(stdout:match("MemFree: *(%d*) kB"))
    local buffers = tonumber(stdout:match("Buffers: *(%d*) kB"))
    local cached = tonumber(stdout:match("Cached: *(%d*) kB"))
    local sreclaimable = tonumber(stdout:match("SReclaimable: *(%d*) kB"))

    local usage = math.floor((mem_total + shmem - mem_free - buffers - cached - sreclaimable) / 1024)
    local total = math.floor(mem_total / 1024)

    awesome.emit_signal("status::memory", usage, usage / total * 100)
end)
