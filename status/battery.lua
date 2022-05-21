local awful = require("awful")

local interval = 3

awful.widget.watch("acpi", interval, function(_, stdout)
    local remaining = 0
    local charging = false

    remaining = tonumber(string.match(stdout, "(%d?%d?%d)%%"))
    if (string.match(stdout, ": (%w+)") == "Charging") then
        charging = true
    end

    awesome.emit_signal("status::battery", remaining, charging)
end)
