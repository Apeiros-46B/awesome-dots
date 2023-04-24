local beautiful = require("beautiful")

-- Theme
local themes_path = os.getenv("HOME") .. "/.config/awesome/themes/"
beautiful.init(themes_path .. "default" .. "/theme.lua")

-- Default terminal emulator and editor
Terminal = "st"
Terminal_start_cmd = Terminal .. " -e "
Editor = os.getenv("EDITOR") or "nvim"
Editor_cmd = Terminal_start_cmd .. Editor
Editor_alt = "emacsclient -a '' -c"

-- Modkeys
Modkey = "Mod4"
Alt    = "Mod1"
S      = "Shift"
Ctl    = "Control"
