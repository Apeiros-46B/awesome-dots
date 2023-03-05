local awful = require('awful')
local script = 'bash ' .. os.getenv('HOME') .. '/.config/awesome/scripts/'
local themes_path = os.getenv('HOME') .. '/.config/awesome/themes/'

awful.spawn(script .. 'picomutil start', false)
awful.spawn('xset r rate 350 75', false)
-- awful.spawn('setxkbmap -option caps:escape', false)
awful.spawn('xrdb -merge ' .. themes_path .. 'default/xrdb', false)
