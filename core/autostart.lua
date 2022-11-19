local awful = require('awful')
local script = 'bash ' .. os.getenv('HOME') .. '/.config/awesome/scripts/'

awful.spawn(script .. 'picomutil start', false)
awful.spawn('xset r rate 350 75', false)
awful.spawn('xmodmap -e "clear lock"', false)
awful.spawn('xmodmap -e "keycode 9 = Caps_Lock NoSymbol Caps_Lock"', false)
awful.spawn('xmodmap -e "keycode 66 = Escape NoSymbol Escape"', false)
