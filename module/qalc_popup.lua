local awful = require("awful")

-- qalc.nvim popup

-- Change this to your terminal's class flag
-- (e.g. I use st which uses -c to provide a class)
local class_arg = " -c qalcpopup"

return function(dir)
    -- Determine filename
    local filename = dir .. os.date("%Y-%m-%d.%H-%M-%S.qalc")

    -- Open the popup
    awful.spawn.easy_async(Terminal .. class_arg .. " -e " .. Editor .. " " .. filename, function() end)
end
