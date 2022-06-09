-- Find luarocks packages
pcall(require, "luarocks.loader")

-- Autofocus
require("awful.autofocus")

-- Error handling
require("util.error_handling")

-- Theme, layouts, Bling, variables and menu
require("util.misc")

-- Screen setup (wallpaper, tags, and wibar)
require("util.screen_setup")

-- Set key and mouse bindings
require("util.bindings_init")

-- Set client rules
require("util.rules")

-- Connect to signals
require("util.signal")

-- Start external programs (e.g. picom)
require("util.autostart")
