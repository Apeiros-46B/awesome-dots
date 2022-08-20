local awful = require("awful")

local interval = 3

awful.widget.watch("acpi", interval, function(_, stdout)
    local remaining = tonumber(string.match(stdout, "(%d?%d?%d)%%"))

    local status = string.match(stdout, ": (%w+)")
    local charging = (status == "Charging" or status == "Full")

    awesome.emit_signal("sysinfo::battery", remaining, charging)
end)
