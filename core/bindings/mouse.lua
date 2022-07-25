local awful = require("awful")

-- {{{ Global mousebinds
awful.mouse.append_global_mousebindings({
    awful.button({ }, 1, function () Menu:hide() end),
    awful.button({ }, 3, function () Menu:toggle() end),
    awful.button({ }, 4, awful.tag.viewprev),
    awful.button({ }, 5, awful.tag.viewnext),
})
-- }}}

-- {{{ Client mousebinds
client.connect_signal("request::default_mousebindings", function()
    awful.mouse.append_client_mousebindings({
        awful.button({ }, 1, function (c)
            c:activate { context = "mouse_click" }
            Menu:hide()
        end),
        awful.button({ Modkey }, 1, function (c)
            c:activate { context = "mouse_click", action = "mouse_move"  }
            Menu:hide()
        end),
        awful.button({ Modkey }, 3, function (c)
            c:activate { context = "mouse_click", action = "mouse_resize"}
            Menu:hide()
        end),
    })
end)
-- }}}
