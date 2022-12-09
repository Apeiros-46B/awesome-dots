-- {{{ imports
local core   = require('module.bling.playerctl.core')
local notify = require('module.notify')
local awful  = require('awful')
-- }}}

-- {{{ add
local M = {}

M.widget   = require('module.bling.playerctl.widget')  (core, notify)
M.notifier = require('module.bling.playerctl.notifier')(core, notify)
M.core     = core

-- {{{ keybinds
awful.keyboard.append_global_keybindings({
    -- {{{ song control
    awful.key({ Ctl,              }, "F6", core.prev,
              {description = "previous song", group = "media"}),

    awful.key({ Ctl,              }, "F7", core.play_pause,
              {description = "play/pause", group = "media"}),

    awful.key({ Ctl,              }, "F8", core.next,
              {description = "next song", group = "media"}),
    -- }}}

    -- {{{ positional control
    awful.key({ Ctl, S            }, "F6", function() core.rew(15) end,
              {description = "rewind 15s", group = "media"}),

    awful.key({ Ctl, S            }, "F8", function() core.fwd(15) end,
              {description = "fast-forward 15s", group = "media"}),
    -- }}}

    -- {{{ playlist control
    awful.key({ Alt,              }, "F6", core.toggle_shuffle,
              {description = "toggle shuffle", group = "media"}),

    awful.key({ Alt,              }, "F8", core.cycle_loop,
              {description = "toggle loop", group = "media"}),
    -- }}}

    -- {{{ [WIP] player control
    awful.key({ Alt, S            }, "F6", core.prev_player,
              {description = "control previous", group = "media"}),

    awful.key({ Alt, S            }, "F8", core.next_player,
              {description = "control next", group = "media"}),
    -- }}}

    -- {{{ widget control
    awful.key({ Alt,              }, "F7", function() awesome.emit_signal("playerctl::toggle_extras") end,
              {description = "toggle extra info", group = "media"}),

    awful.key({ Alt, S            }, "F7", function() awesome.emit_signal("playerctl::toggle_scroll") end,
              {description = "toggle scroller", group = "media"}),
    -- }}}
})
-- }}}
-- }}}

return M
