-- Autoload luarocks modules
pcall(require, "luarocks.loader")

-- Error handling
require("core.error_handling")

-- Theme & variables
require("core.variables")

-- Bling, menu, & garbage collection
require("core.misc")

-- Screen setup (wallpaper, tags, layouts, & wibar)
require("core.screen_setup")

-- Key & mouse buttons
require("core.bindings.init")

-- Client rules
require("core.rules")

-- Manage signal, border colors, titlebars
require("core.signal")

-- Start external programs (e.g. picom)
require("core.autostart")
