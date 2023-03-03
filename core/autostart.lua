local awful = require('awful')
local script = 'bash ' .. os.getenv('HOME') .. '/.config/awesome/scripts/'

awful.spawn(script .. 'picomutil start', false)
awful.spawn('xset r rate 350 75', false)
-- awful.spawn('setxkbmap -option caps:escape', false)
