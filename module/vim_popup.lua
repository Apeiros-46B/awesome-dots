local awful = require("awful")

-- Budget vim-anywhere, but for awesomewm

-- Change this to your terminal's class flag
-- (e.g. I use st which uses -c to provide a class)
local class_arg = " -c vimpopup"

return function(dir)
    -- Determine filename
    local filename = (dir or "/tmp/") .. os.date("vimpopup-%Y-%b-%d.%H-%M-%S")

    -- Open the popup
    awful.spawn.easy_async(Terminal .. class_arg .. " -e " .. Editor .. " " .. filename, function()
        -- Check file contents
        awful.spawn.easy_async("cat " .. filename, function(stdout)
            -- Check if the file only contains whitespace
            stdout = stdout:gsub("%s+", "")
            if stdout == nil or stdout == '' then
                -- Remove the file to prevent clutter
                awful.spawn("rm " .. filename, false)
            else
                -- Copy the resulting output to clipboard
                awful.spawn("xclip -r -sel clip " .. filename, false)
            end
        end)
    end)
end
