local awful = require("awful")

local interval = 10

awful.widget.watch("ip a", interval, function(_, stdout)
    local state

    state = string.match(stdout, "state (UP)")

    awesome.emit_signal("sysinfo::network", state)
end)
