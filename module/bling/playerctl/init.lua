local core   = require('module.bling.playerctl.core')
local notify = require('module.notify')

local M = {}

M.widget   = require('module.bling.playerctl.widget')  (core, notify)
M.notifier = require('module.bling.playerctl.notifier')(core, notify)

return M
