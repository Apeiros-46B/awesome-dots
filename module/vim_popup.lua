local awful = require("awful")

-- Budget vim-anywhere, but for awesomewm

-- Change this to your terminal's class flag
-- (e.g. I use st which uses -c to provide a class)
local class_arg = " -c vimpopup"

return function(dir)
  local filename = dir .. os.date("%Y.%m.%d_%H-%M-%S.txt")

  -- popup
  awful.spawn.easy_async(Terminal .. class_arg .. " -e " .. Editor .. " " .. filename, function()
    -- check file contents
    awful.spawn.easy_async("cat " .. filename, function(stdout)
      stdout = stdout:gsub("%s+", "")

      if stdout == nil or stdout == '' then
        -- remove the file if empty (or whitespace only)
        awful.spawn("rm " .. filename, false)
      else
        -- copy file contents to clipboard
        awful.spawn("xclip -r -sel clip " .. filename, false)
      end
    end)
  end)
end
