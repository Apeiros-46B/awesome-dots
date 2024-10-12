local awful = require('awful')
local ruled = require('ruled')

ruled.client.connect_signal('request::rules', function()
end)
