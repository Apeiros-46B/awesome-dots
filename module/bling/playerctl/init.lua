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
local function rew() core.rew(15) end
local function fwd() core.fwd(15) end

local function toggle_extras() awesome.emit_signal('playerctl::toggle_extras') end
local function toggle_scroll() awesome.emit_signal('playerctl::toggle_scroll') end

awful.keyboard.append_global_keybindings({
    -- {{{ song control
    awful.key({ Ctl }, 'F6', core.prev,       { description = 'previous song', group = 'media' }),
    awful.key({ Ctl }, 'F7', core.play_pause, { description = 'play/pause',    group = 'media' }),
    awful.key({ Ctl }, 'F8', core.next,       { description = 'next song',     group = 'media' }),

    -- XF86
    awful.key({}, 'XF86AudioPrev', core.prev,       {}),
    awful.key({}, 'XF86AudioPlay', core.play_pause, {}),
    awful.key({}, 'XF86AudioNext', core.next,       {}),
    -- }}}

    -- {{{ positional control
    awful.key({ Ctl, S }, 'F6', rew, { description = 'rewind 15s',       group = 'media' }),
    awful.key({ Ctl, S }, 'F8', fwd, { description = 'fast-forward 15s', group = 'media' }),

    -- XF86
    awful.key({}, 'XF86AudioRewind',  rew, {}),
    awful.key({}, 'XF86AudioForward', fwd, {}),
    -- }}}

    -- {{{ playlist control
    awful.key({ Alt }, 'F6', core.toggle_shuffle, { description = 'toggle shuffle', group = 'media' }),
    awful.key({ Alt }, 'F8', core.cycle_loop,     { description = 'toggle loop',    group = 'media' }),

    -- XF86
    awful.key({ Ctl }, 'XF86AudioPrev',    core.toggle_shuffle, {}),
    awful.key({ Ctl }, 'XF86AudioNext',    core.cycle_loop,     {}),
    awful.key({ Ctl }, 'XF86AudioRewind',  core.toggle_shuffle, {}),
    awful.key({ Ctl }, 'XF86AudioForward', core.cycle_loop,     {}),
    -- }}}

    -- {{{ widget control
    awful.key({ Alt    }, 'F7', toggle_extras, { description = 'toggle extra info',  group = 'media' }),
    awful.key({ Alt, S }, 'F7', toggle_scroll, { description = 'toggle info scroll', group = 'media' }),

    -- XF86
    awful.key({ Ctl }, 'XF86AudioPlay', toggle_extras, {}),
    awful.key({ Alt }, 'XF86AudioPlay', toggle_scroll, {}),
    -- }}}

    -- {{{ [WIP] player control
    -- awful.key({ Alt, S }, 'F6', core.prev_player, {description = 'control previous', group = 'media'}),
    -- awful.key({ Alt, S }, 'F8', core.next_player, {description = 'control next', group = 'media'}),
    -- }}}
})
-- }}}
-- }}}

return M
