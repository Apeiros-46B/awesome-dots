local bling = require("bling")

bling.widget.window_switcher.enable {
    type = "normal", -- set to anything other than "thumbnail" to disable client previews

    -- keybindings (the examples provided are also the default if kept unset)
    hide_window_switcher_key = "Escape", -- The key on which to close the popup
    minimize_key = "m",                  -- The key on which to minimize the selected client
    unminimize_key = "M",                -- The key on which to unminimize all clients
    kill_client_key = "q",               -- The key on which to close the selected client
    cycle_key = "Tab",                   -- The key on which to cycle through all clients
    previous_key = "l",                  -- The key on which to select the previous client
    next_key = "h",                      -- The key on which to select the next client
    vim_previous_key = "j",              -- Alternative key on which to select the previous client
    vim_next_key = "k",                  -- Alternative key on which to select the next client
}
