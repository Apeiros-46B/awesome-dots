-- Autoload luarocks modules
pcall(require, "luarocks.loader")

-- Error handling
require("core.error_handling")

-- Theme, layouts, Bling, variables and menu
require("core.misc")

-- Screen setup (wallpaper, tags, and wibar)
require("core.screen_setup")

-- Set key and mouse bindings
require("core.bindings")

-- Set client rules
require("core.rules")

-- Connect to signals
require("core.signal")

-- Start external programs (e.g. picom)
require("core.autostart")
