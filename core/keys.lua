-- {{{ imports and variables
-- libs
local awful = require("awful")
local gears = require("gears")
local naughty = require("naughty")

-- menubar and hotkeys popup imports
local menubar = require("menubar")
local hotkeys_popup = require("awful.hotkeys_popup")

-- show help for vim or tmux when an app with a matching name is focused
require("awful.hotkeys_popup.keys")

-- keybinds table
local M = {}

-- modkey aliases
local modkey = "Mod4"
local alt = "Mod1"
local s = "Shift"
local ctl = "Control"

-- misc
local dpi = require("beautiful.xresources").apply_dpi
local script = "bash " .. os.getenv("HOME") .. "/.config/awesome/scripts/"
local notify = require("module.notify")
local playerctl = require("bling").signal.playerctl.lib()
-- }}}

-- == -- == --

-- {{{ begin global keybinds
M.globalkeys = gears.table.join(
-- }}}

-- -- --

    -- {{{ client focusing and swapping
    -- index swaps
    awful.key({ modkey, ctl       }, ".", function () awful.client.swap.byidx(  1)    end,
              {description = "swap with next client by index", group = "client"}),

    awful.key({ modkey, ctl       }, ",", function () awful.client.swap.byidx( -1)    end,
              {description = "swap with previous client by index", group = "client"}),

    -- index focus
    awful.key({ modkey, s         }, ".", function () awful.client.focus.byidx( 1) end,
              {description = "focus next by index", group = "client"}),

    awful.key({ modkey, s         }, ",", function () awful.client.focus.byidx(-1) end,
        {description = "focus previous by index", group = "client"}),

    -- directional swaps
    awful.key({ modkey, s         }, "h", function () awful.client.swap.bydirection('left')   end,
              {description = "swap leftwards ", group = "client"}),

    awful.key({ modkey, s         }, "j", function () awful.client.swap.bydirection('down')   end,
              {description = "swap downwards", group = "client"}),

    awful.key({ modkey, s         }, "k", function () awful.client.swap.bydirection('up')     end,
              {description = "swap upwards", group = "client"}),

    awful.key({ modkey, s         }, "l", function () awful.client.swap.bydirection('right')  end,
              {description = "swap rightwards", group = "client"}),

    -- directional focus
    awful.key({ modkey            }, "h", function () awful.client.focus.bydirection('left')  end,
              {description = "focus leftwards ", group = "client"}),

    awful.key({ modkey            }, "j", function () awful.client.focus.bydirection('down')  end,
              {description = "focus downwards", group = "client"}),

    awful.key({ modkey            }, "k", function () awful.client.focus.bydirection('up')    end,
              {description = "focus upwards", group = "client"}),

    awful.key({ modkey            }, "l", function () awful.client.focus.bydirection('right') end,
              {description = "focus rightwards", group = "client"}),

    -- jump to urgent
    awful.key({ modkey, s         }, "u", awful.client.urgent.jumpto,
              {description = "jump to urgent client", group = "client"}),

    -- jump to previous
    awful.key({ modkey,           }, "Tab", function ()
        awful.client.focus.history.previous()
        if client.focus then
            client.focus:raise()
        end
    end,
    {description = "go back", group = "client"}),

    -- window switcher
    awful.key({ alt }, "Tab", function ()
        awesome.emit_signal("bling::window_switcher::turn_on")
    end,
    {description = "window switcher", group = "client"}),

    -- unminimize
    awful.key({ modkey, s         }, "m", function ()
        local c = awful.client.restore()
        if c then
            c:emit_signal(
                "request::activate", "key.unminimize", {raise = true}
            )
        end
    end,
    {description = "unminimize", group = "client"}),
    -- }}}

    -- {{{ tags
    awful.key({ modkey,           }, ",",   awful.tag.viewprev,
              {description = "view previous", group = "tag"}),

    awful.key({ modkey,           }, ".",  awful.tag.viewnext,
              {description = "view next", group = "tag"}),

    awful.key({ modkey,           }, "Escape", awful.tag.history.restore,
              {description = "go back", group = "tag"}),
    -- }}}

    -- {{{ screens
    awful.key({ modkey, alt       }, ".", function () awful.screen.focus_relative( 1) end,
              {description = "focus the next screen", group = "screen"}),

    awful.key({ modkey, alt       }, ",", function () awful.screen.focus_relative(-1) end,
              {description = "focus the previous screen", group = "screen"}),
    -- }}}

    -- {{{ layout manipulation
    awful.key({ alt               }, "l",      function () awful.tag.incmwfact( 0.05)          end,
              {description = "increase master width factor", group = "layout"}),

    awful.key({ alt               }, "h",      function () awful.tag.incmwfact(-0.05)          end,
              {description = "decrease master width factor", group = "layout"}),

    awful.key({ modkey, ctl       }, "k",      function () awful.tag.incnmaster( 1, nil, true) end,
              {description = "increase the number of master clients", group = "layout"}),

    awful.key({ modkey, ctl       }, "j",      function () awful.tag.incnmaster(-1, nil, true) end,
              {description = "decrease the number of master clients", group = "layout"}),

    awful.key({ modkey, ctl       }, "l",      function () awful.tag.incncol( 1, nil, true)    end,
              {description = "increase the number of columns", group = "layout"}),

    awful.key({ modkey, ctl       }, "h",      function () awful.tag.incncol(-1, nil, true)    end,
              {description = "decrease the number of columns", group = "layout"}),

    awful.key({ modkey            }, "y",      function () awful.layout.inc( 1)                end,
              {description = "select next", group = "layout"}),
    
    awful.key({ modkey, s         }, "y",      function () awful.layout.inc(-1)                end,
              {description = "select previous", group = "layout"}),
    -- }}}

-- -- --

    -- {{{ launchers
    awful.key({ modkey,           }, "Return", function () awful.spawn(Terminal, false) end,
              {description = "terminal", group = "launcher"}),

    awful.key({ ctl, s            }, "Escape",  function () awful.spawn(Terminal_start_cmd .. "btop", false) end,
              {description = "task manager", group = "launcher"}),

    awful.key({ modkey,           }, "space",  function () awful.spawn(script .. "rofiutil", false) end,
              {description = "run menu", group = "launcher"}),

    awful.key({ modkey, s         }, "space",  function () awful.spawn(script .. "rofiutil -d", false) end,
              {description = "drun menu", group = "launcher"}),

    awful.key({ modkey,           }, "x",      function () awful.spawn(script .. "rofiutil -l", false) end,
              {description = "system menu", group = "launcher"}),

    awful.key({ modkey, s         }, "c",      function () awful.spawn(script .. "rofiutil -q", false) end,
              {description = "calculator menu", group = "launcher"}),

    awful.key({ modkey, alt       }, "s",      function () awful.spawn(script .. "rofiutil -s", false) end,
              {description = "screenshot menu", group = "launcher"}),

    awful.key({ modkey, s         }, "s",      function () awful.spawn("flameshot gui", false) end,
              {description = "flameshot", group = "launcher"}),

    awful.key({ modkey            }, "u",      function () awful.spawn("pavucontrol", false) end,
              {description = "pavucontrol", group = "launcher"}),

    -- {{{ stock awesome prompts & menubar
    -- prompts
    -- awful.key({ modkey            }, "r",      function () awful.screen.focused().promptbox:run() end,
    --           {description = "run prompt", group = "launcher"}),
    --
    -- awful.key({ modkey            }, "x", function ()
    --     awful.prompt.run {
    --         prompt       = "Run Lua code: ",
    --         textbox      = awful.screen.focused().promptbox.widget,
    --         exe_callback = awful.util.eval,
    --         history_path = awful.util.get_cache_dir() .. "/history_eval"
    --     }
    -- end,
    -- {description = "lua execute prompt", group = "awesome"}),

    -- menubar
    -- awful.key({ modkey            }, "p", function() menubar.show() end,
    --           {description = "show the menubar", group = "launcher"}),
    -- }}}

    -- }}}

    -- {{{ core keybinds
    awful.key({ modkey, s         }, "r",      awesome.restart,
              {description = "reload awesome", group = "awesome"}),

    -- awful.key({ modkey, s         }, "q",      awesome.quit,
              -- {description = "quit awesome", group = "awesome"}),

    awful.key({ modkey,           }, "w", function () Menu:show() end,
              {description = "show main menu", group = "awesome"}),

    awful.key({ modkey, s         }, "b",      hotkeys_popup.show_help,
              {description="show help", group="awesome"}),
    -- }}}

-- -- --

    -- {{{ misc
    -- toggles
    --- wibar
    awful.key({ modkey, s,        }, "d", function ()
        for s in screen do
            s.wibox.visible = not s.wibox.visible
        end
    end,
    {description = "wibar", group = "global toggle"}),

    --- picom
    awful.key({ modkey, s         }, "p",      function () awful.spawn(script .. "picomutil toggle", false) end,
              {description = "compositor", group = "global toggle"}),

    --- glava
    awful.key({ modkey, s         }, "g",      function () awful.spawn(script .. "glavautil toggle", false) end,
              {description = "audio visualizer", group = "global toggle"}),

    -- power
    --- suspend
    awful.key({ modkey, alt       }, "F12",    function () awful.spawn("loginctl suspend", false) end,
              {description = "suspend", group = "system"}),

    -- add typos to the clipboard
    awful.key({ modkey, s         }, "t",      function ()
        local typogen = require("module.util.typo_generator")

        awful.spawn.easy_async("xclip -o -selection clipboard", function(stdout, _, _, _)
            clipboard_contents = typogen.mainfunc(stdout, 10, typogen.keymaps.qwerty)
            new_clipboard = clipboard_contents:gsub("\n[^\n]*$", "")

            naughty.notify({
                title = "Clipboard Typo-ified",
                text = new_clipboard
            })
            awful.spawn.with_shell("printf \"" .. new_clipboard .. "\" | xclip -selection clipboard", nil)
        end)
    end,
    {description = "add typos to clipboard contents", group = "misc"}),

    awful.key({ modkey, s         }, "n",      function () notify(
        {
            title    = "This is a test notification",
            message  = "This is the notification content",
            app_name = "tester",
            replaces = true,
            -- replaces = false,
            actions  = {
                naughty.action { name = "Action 1", position = 1, selected = true  },
                naughty.action { name = "Action 2", position = 2, selected = false },
                naughty.action { name = "Action 3", position = 3, selected = false }
            }
        })
    end,
    {description = "send a test notification", group = "misc"}),

    awful.key({ modkey,           }, "n",      function () notify(
        {
            title    = "This is another test notification",
            message  = "This is the notification content",
            app_name = "tester2",
            replaces = true,
            -- replaces = false,
            actions  = {
                naughty.action { name = "Action 1", position = 1, selected = true  },
                naughty.action { name = "Action 2", position = 2, selected = false },
                naughty.action { name = "Action 3", position = 3, selected = false }
            }
        })
    end,
    {description = "send a different test notification", group = "misc"}),
    -- }}}

-- -- --

    -- {{{ audio control
    -- volume
    awful.key({ ctl,              }, "F1",     function () awful.spawn(script .. "audioutil vol inc-default-sink", false) end,
              {description = "cycle default sink", group = "audio"}),
    awful.key({ ctl,              }, "F2",     function () awful.spawn(script .. "audioutil vol dec", false) end,
              {description = "vol down", group = "audio"}),
    awful.key({ ctl,              }, "F3",     function () awful.spawn(script .. "audioutil vol inc", false) end,
              {description = "vol up", group = "audio"}),
    awful.key({ ctl,              }, "F4",     function () awful.spawn(script .. "audioutil vol mute", false) end,
              {description = "toggle mute", group = "audio"}),

    -- media
    awful.key({ ctl,              }, "F6",     function () awful.spawn(script .. "audioutil media prev", false) end,
              {description = "previous song", group = "audio"}),
    awful.key({ ctl,              }, "F7",     function () awful.spawn(script .. "audioutil media toggle", false) end,
              {description = "play/pause", group = "audio"}),
    awful.key({ ctl,              }, "F8",     function () awful.spawn(script .. "audioutil media next", false) end,
              {description = "next song", group = "audio"}),

    awful.key({ alt,              }, "F6",     function ()
        playerctl:cycle_shuffle()
    end,
    {description = "toggle shuffle", group = "audio"}),

    awful.key({ alt,              }, "F8",     function ()
        playerctl:cycle_loop_status()
    end,
    {description = "cycle loop", group = "audio"})
    -- }}}

-- -- --

-- {{{ end global keybinds
)
-- }}}

-- == -- == --

-- {{{ begin client keybinds
M.clientkeys = gears.table.join(
-- }}}

-- -- --

    -- {{{ close
    awful.key({ modkey,           }, "c",      function (c) c:kill()                         end,
              {description = "close", group = "client"}),
    -- }}}

    -- {{{ swap/move
    awful.key({ modkey, ctl       }, "Return", function (c) c:swap(awful.client.getmaster()) end,
              {description = "move to master", group = "client"}),

    awful.key({ modkey,           }, "o",      function (c) c:move_to_screen()               end,
              {description = "move to screen", group = "client"}),
    -- }}}

    -- {{{ toggle states
    awful.key({ modkey,           }, "t",      function (c) c.ontop = not c.ontop            end,
              {description = "toggle keep on top", group = "client"}),

    awful.key({ modkey, ctl       }, "s",      function (c) c.sticky = not c.sticky          end,
              {description = "toggle sticky/omnipresent", group = "client"}),

    awful.key({ modkey,           }, "f",      function (c)
        c.fullscreen = not c.fullscreen
        c:raise()
    end,
    {description = "toggle fullscreen", group = "client"}),

    awful.key({ modkey, s         }, "f",      function(c)
        c.floating = not c.floating
        c.ontop = c.floating
    end,
    {description = "toggle floating", group = "client"}),

    awful.key({ modkey,           }, "m",      function (c)
        -- we can assume focused is not minimized
        -- because minimized clients cannot be focused
        c.minimized = true
    end ,
    {description = "minimize", group = "client"}),

    awful.key({ modkey, ctl       }, "m",      function (c)
        c.maximized = not c.maximized
        c:raise()
    end ,
    {description = "toggle maximized", group = "client"}),

    awful.key({ modkey, alt       }, "m",      function (c)
        c.maximized_vertical = not c.maximized_vertical
        c:raise()
    end ,
    {description = "toggle maximized vertically", group = "client"}),

    awful.key({ modkey, s, alt    }, "m",      function (c)
        c.maximized_horizontal = not c.maximized_horizontal
        c:raise()
    end ,
    {description = "toggle maximized horizontally", group = "client"}),

    awful.key({ modkey,           }, "t",      function (c)
        awful.titlebar.toggle(c)

        if c.border_width == dpi(2) then
            c.border_width = 0
        else
            c.border_width = dpi(2)
        end
    end,
    {description = "toggle titlebar and borders", group = "client"})
-- }}}

-- -- --

-- {{{ end client keybinds
)
-- }}}

-- == -- == --

-- {{{ extra bindings

-- {{{ client buttons
M.clientbuttons = gears.table.join(
    awful.button({ }, 1, function (c)
        c:emit_signal("request::activate", "mouse_click", {raise = true})
    end),
    awful.button({ modkey }, 1, function (c)
        c:emit_signal("request::activate", "mouse_click", {raise = true})
        awful.mouse.client.move(c)
    end),
    awful.button({ modkey }, 3, function (c)
        c:emit_signal("request::activate", "mouse_click", {raise = true})
        awful.mouse.client.resize(c)
    end)
)
-- }}}

-- {{{ tag focusing and moving clients to tags
-- Be careful: we use keycodes to make it work on any keyboard layout.
-- This should map on the top row of your keyboard, usually 1 to 9.
for i = 1, 8 do
    M.globalkeys = gears.table.join(M.globalkeys,
        -- View tag only.
        awful.key({ modkey }, "#" .. i + 9, function ()
              local screen = awful.screen.focused()
              local tag = screen.tags[i]
              if tag then
                 tag:view_only()
              end
        end,
        {description = "view tag #"..i, group = "tag"}),

        -- Toggle tag display.
        awful.key({ modkey, ctl       }, "#" .. i + 9, function ()
            local screen = awful.screen.focused()
            local tag = screen.tags[i]
            if tag then
               awful.tag.viewtoggle(tag)
            end
        end,
        {description = "toggle tag #" .. i, group = "tag"}),

        -- Move client to tag.
        awful.key({ modkey, s       }, "#" .. i + 9, function ()
            if client.focus then
                local tag = client.focus.screen.tags[i]
                if tag then
                    client.focus:move_to_tag(tag)
                end
           end
        end,
        {description = "move focused client to tag #"..i, group = "tag"}),

        -- Toggle tag on focused client.
        awful.key({ modkey, ctl, s  }, "#" .. i + 9, function ()
            if client.focus then
                local tag = client.focus.screen.tags[i]
                if tag then
                    client.focus:toggle_tag(tag)
                end
            end
        end,
        {description = "toggle focused client on tag #" .. i, group = "tag"})
    )
end
-- }}}

--- }}}

-- {{{ return
return M
-- }}}
