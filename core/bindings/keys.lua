-- {{{ Imports and variables
-- Libraries
local awful = require("awful")
local naughty = require("naughty")

-- Hotkeys popup
local hotkeys_popup = require("awful.hotkeys_popup")

-- Misc
local dpi       = require("beautiful.xresources").apply_dpi
local script    = "bash " .. os.getenv("HOME") .. "/.config/awesome/scripts/"
local notify    = require("module.notify")
local vim_popup = require("module.vim_popup")
local playerctl = require("bling").signal.playerctl.lib()
-- }}}

-- {{{ Global keybindings
awful.keyboard.append_global_keybindings({

    -- {{{ Tags
    -- {{{ Tag switching based on next/prev
    awful.key({ Modkey,           }, ",",   awful.tag.viewprev,
              {description = "view previous", group = "tag"}),

    awful.key({ Modkey,           }, ".",  awful.tag.viewnext,
              {description = "view next", group = "tag"}),

    awful.key({ Modkey,           }, "Escape", awful.tag.history.restore,
              {description = "go back", group = "tag"}),
    -- }}}

    -- {{{ Tag switching based on index
    awful.key {
        modifiers   = { Modkey },
        keygroup    = "numrow",
        description = "only view tag",
        group       = "tag",
        on_press    = function (index)
            local screen = awful.screen.focused()
            local tag = screen.tags[index]
            if tag then
                tag:view_only()
            end
        end,
    },

    awful.key {
        modifiers   = { Modkey, "Control" },
        keygroup    = "numrow",
        description = "toggle tag",
        group       = "tag",
        on_press    = function (index)
            local screen = awful.screen.focused()
            local tag = screen.tags[index]
            if tag then
                awful.tag.viewtoggle(tag)
            end
        end,
    },

    awful.key {
        modifiers = { Modkey, "Shift" },
        keygroup    = "numrow",
        description = "move focused client to tag",
        group       = "tag",
        on_press    = function (index)
            if client.focus then
                local tag = client.focus.screen.tags[index]
                if tag then
                    client.focus:move_to_tag(tag)
                end
            end
        end,
    },

    awful.key {
        modifiers   = { Modkey, "Control", "Shift" },
        keygroup    = "numrow",
        description = "toggle focused client on tag",
        group       = "tag",
        on_press    = function (index)
            if client.focus then
                local tag = client.focus.screen.tags[index]
                if tag then
                    client.focus:toggle_tag(tag)
                end
            end
        end,
    },

    awful.key {
        modifiers   = { Modkey },
        keygroup    = "numpad",
        description = "select layout directly",
        group       = "layout",
        on_press    = function (index)
            local t = awful.screen.focused().selected_tag
            if t then
                t.layout = t.layouts[index] or t.layout
            end
        end,
    },
    -- }}}
    -- }}}

    -- {{{ Screens
    awful.key({ Modkey, Alt       }, "l", function() awful.screen.focus_relative( 1) end,
              {description = "focus the next screen", group = "screen"}),

    awful.key({ Modkey, Alt       }, "h", function() awful.screen.focus_relative(-1) end,
              {description = "focus the previous screen", group = "screen"}),

    awful.key({ Modkey, Alt       }, "k", function() awful.screen.focus_relative( 1) end,
              {description = "focus the next screen", group = "screen"}),

    awful.key({ Modkey, Alt       }, "j", function() awful.screen.focus_relative(-1) end,
              {description = "focus the previous screen", group = "screen"}),
    -- }}}

    -- {{{ Layout manipulation
    awful.key({ Modkey, Ctl       }, "k",      function() awful.tag.incnmaster( 1, nil, true) end,
              {description = "increase master clients", group = "layout"}),

    awful.key({ Modkey, Ctl       }, "j",      function() awful.tag.incnmaster(-1, nil, true) end,
              {description = "decrease master clients", group = "layout"}),

    awful.key({ Modkey, Ctl       }, "l",      function() awful.tag.incncol( 1, nil, true)    end,
              {description = "increase columns", group = "layout"}),

    awful.key({ Modkey, Ctl       }, "h",      function() awful.tag.incncol(-1, nil, true)    end,
              {description = "decrease columns", group = "layout"}),

    awful.key({ Modkey            }, "y",      function() awful.layout.inc( 1)                end,
              {description = "select next", group = "layout"}),

    awful.key({ Modkey, S         }, "y",      function() awful.layout.inc(-1)                end,
              {description = "select previous", group = "layout"}),
    -- }}}

-- -- --

    -- {{{ Launchers
    awful.key({ Modkey,           }, "Return", function() awful.spawn(Terminal, false) end,
              {description = "terminal", group = "launcher"}),

    awful.key({ Ctl, S            }, "Escape", function() awful.spawn(Terminal_start_cmd .. "btop", false) end,
              {description = "task manager", group = "launcher"}),

    awful.key({ Modkey,           }, "v",      function() vim_popup(os.getenv("HOME") .. "/.cache/awesome/vimpopup/")  end,
              {description = "vim popup", group = "launcher"}),

    awful.key({ Modkey,           }, "space",  function() awful.spawn(script .. "rofiutil", false) end,
              {description = "run menu", group = "launcher"}),

    awful.key({ Modkey, S         }, "space",  function() awful.spawn(script .. "rofiutil -d", false) end,
              {description = "drun menu", group = "launcher"}),

    awful.key({ Modkey,           }, "x",      function() awful.spawn(script .. "rofiutil -l", false) end,
              {description = "system menu", group = "launcher"}),

    awful.key({ Modkey, S         }, "c",      function() awful.spawn(script .. "rofiutil -q", false) end,
              {description = "calculator menu", group = "launcher"}),

    awful.key({ Modkey, S         }, "e",      function() awful.spawn(script .. "rofiutil -e", false) end,
              {description = "emoji menu", group = "launcher"}),

    -- awful.key({ Modkey, Alt       }, "s",      function() awful.spawn(script .. "rofiutil -s", false) end,
    --           {description = "screenshot menu", group = "launcher"}),

    awful.key({ Modkey, S         }, "s",      function() awful.spawn("flameshot gui", false) end,
              {description = "flameshot", group = "launcher"}),

    awful.key({ Modkey            }, "u",      function() awful.spawn("pavucontrol", false) end,
              {description = "pavucontrol", group = "launcher"}),

    -- {{{ stock awesome prompts & menubar
    -- prompts
    -- awful.key({ modkey            }, "r",      function() awful.screen.focused().promptbox:run() end,
    --           {description = "run prompt", group = "launcher"}),
    --
    -- awful.key({ modkey            }, "x", function()
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

    -- {{{ Core keybinds
    awful.key({ Modkey, S         }, "r",      awesome.restart,
              {description = "reload awesome", group = "awesome"}),

    -- awful.key({ modkey, s         }, "q",      awesome.quit,
              -- {description = "quit awesome", group = "awesome"}),

    awful.key({ Modkey,           }, "w", function() Menu:show() end,
              {description = "show main menu", group = "awesome"}),

    awful.key({ Modkey, S         }, "b",      hotkeys_popup.show_help,
              {description="show help", group="awesome"}),
    -- }}}

-- -- --

    -- {{{ Misc
    -- {{{ Toggles
    -- Wibar
    awful.key({ Modkey, S,        }, "d", function()
        for s in screen do
            s.wibox.visible = not s.wibox.visible
        end
    end,
    {description = "wibar", group = "global toggle"}),

    -- Picom
    awful.key({ Modkey, S         }, "p",      function() awful.spawn(script .. "picomutil toggle",           false) end,
              {description = "compositor",        group = "global toggle"}),
    -- awful.key({ Modkey, Alt       }, "p",      function() awful.spawn(script .. "picomutil animation-toggle", false) end,
    --           {description = "window animations", group = "global toggle"}),

    -- Glava
    awful.key({ Modkey, S         }, "g",      function() awful.spawn(script .. "glavautil toggle", false) end,
              {description = "audio visualizer", group = "global toggle"}),
    -- }}}

    -- {{{ Power
    -- Suspend
    awful.key({ Modkey, Alt       }, "F12",    function() awful.spawn("loginctl suspend", false) end,
              {description = "suspend", group = "system"}),
    -- }}}

    -- {{{ Add typos to the clipboard
    awful.key({ Modkey, S         }, "t",      function()
        local typogen = require("module.util.typo_generator")

        awful.spawn.easy_async("xclip -o -sel clip", function(stdout, _, _, _)
            local clipboard_contents = typogen.mainfunc(stdout, 10, typogen.keymaps.qwerty)
            local new_clipboard = clipboard_contents:gsub("\n[^\n]*$", "")

            notify({
                title = "Typos added to clipboard",
                text = new_clipboard,
                app_name = "typo_generator",
                replaces = true
            })
            awful.spawn.with_shell([[echo "]] .. new_clipboard .. [[" | xclip -r -sel clip]])
        end)
    end,
    {description = "add typos to clipboard contents", group = "misc"}),
    -- }}}

    -- {{{ Key repeat
    awful.key({ Modkey,           }, "r",      function()
        awful.spawn("xset r rate 350 75", false)
        awful.spawn('xmodmap -e "clear lock"', false)
        awful.spawn('xmodmap -e "keycode 9 = Caps_Lock NoSymbol Caps_Lock"', false)
        awful.spawn('xmodmap -e "keycode 66 = Escape NoSymbol Escape"', false)
    end,
    {description = "reset keys", group = "misc"}),
    -- }}}

    -- {{{ Test notifications
    awful.key({ Modkey, S         }, "n",      function() notify(
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

    awful.key({ Modkey,           }, "n",      function() notify(
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
    -- }}}

-- -- --

    -- {{{ Audio control
    -- {{{ Volume
    awful.key({ Ctl,              }, "F1",     function() awful.spawn(script .. "audioutil vol inc_sink", false) end,
              {description = "cycle default sink (up)", group = "audio"}),

    awful.key({ Ctl, S            }, "F1",     function() awful.spawn(script .. "audioutil vol dec_sink", false) end,
              {description = "cycle default sink (down)", group = "audio"}),

    awful.key({ Ctl,              }, "F2",     function() awful.spawn(script .. "audioutil vol dec", false) end,
              {description = "vol down", group = "audio"}),

    awful.key({ Ctl,              }, "F3",     function() awful.spawn(script .. "audioutil vol inc", false) end,
              {description = "vol up", group = "audio"}),

    awful.key({ Ctl,              }, "F4",     function() awful.spawn(script .. "audioutil vol mute", false) end,
              {description = "toggle mute", group = "audio"}),
    -- }}}

    -- {{{ Media
    awful.key({ Ctl,              }, "F6",     function() awful.spawn(script .. "audioutil media prev", false) end,
              {description = "previous song", group = "audio"}),

    awful.key({ Ctl,              }, "F7",     function() awful.spawn(script .. "audioutil media toggle", false) end,
              {description = "play/pause", group = "audio"}),

    awful.key({ Ctl,              }, "F8",     function() awful.spawn(script .. "audioutil media next", false) end,
              {description = "next song", group = "audio"}),

    awful.key({ Alt,              }, "F6",     function()
        playerctl:cycle_shuffle()
    end,
    {description = "toggle shuffle", group = "audio"}),

    awful.key({ Alt,              }, "F8",     function()
        playerctl:cycle_loop_status()
    end,
    {description = "cycle loop", group = "audio"}),
    -- }}}
    -- }}}

    -- {{{ Brightness control
    awful.key({ Ctl,              }, "F11",    function() awful.spawn("brightnessctl s 10%-", false) end,
              {description = "brightness down", group = "system"}),

    awful.key({ Ctl,              }, "F12",    function() awful.spawn("brightnessctl s +10%", false) end,
              {description = "brightness up", group = "system"}),
    -- }}}

})
-- }}}

-- {{{ Client keybinds
awful.keyboard.append_global_keybindings({
    -- {{{ Index swaps
    awful.key({ Modkey, Ctl       }, ".", function() awful.client.swap.byidx(  1)    end,
              {description = "swap with next client by index", group = "client"}),

    awful.key({ Modkey, Ctl       }, ",", function() awful.client.swap.byidx( -1)    end,
              {description = "swap with previous client by index", group = "client"}),
    -- }}}

    -- {{{ Index focus
    awful.key({ Modkey, S         }, ".", function() awful.client.focus.byidx( 1) end,
              {description = "focus next by index", group = "client"}),

    awful.key({ Modkey, S         }, ",", function() awful.client.focus.byidx(-1) end,
        {description = "focus previous by index", group = "client"}),
    -- }}}

    -- {{{ Directional focus
    awful.key({ Modkey            }, "h", function() awful.client.focus.bydirection('left')  end,
              {description = "focus leftwards ", group = "client"}),

    awful.key({ Modkey            }, "j", function() awful.client.focus.bydirection('down')  end,
              {description = "focus downwards", group = "client"}),

    awful.key({ Modkey            }, "k", function() awful.client.focus.bydirection('up')    end,
              {description = "focus upwards", group = "client"}),

    awful.key({ Modkey            }, "l", function() awful.client.focus.bydirection('right') end,
              {description = "focus rightwards", group = "client"}),
    -- }}}

    -- {{{ Jump
    awful.key({ Modkey, S         }, "u", awful.client.urgent.jumpto,
              {description = "jump to urgent client", group = "client"}),

    awful.key({ Modkey,           }, "Tab", function()
        awful.client.focus.history.previous()
        if client.focus then
            client.focus:raise()
        end
    end,
    {description = "go back", group = "client"}),
    -- }}}

    -- {{{ Window switcher
    awful.key({ Alt }, "Tab", function()
        awesome.emit_signal("bling::window_switcher::turn_on")
    end,
    {description = "window switcher", group = "client"}),
    -- }}}

    -- {{{ Unminimize
    awful.key({ Modkey, S         }, "m", function()
        local c = awful.client.restore()
        if c then
            c:emit_signal(
                "request::activate", "key.unminimize", {raise = true}
            )
        end
    end,
    {description = "unminimize", group = "client"}),
    -- }}}
})

client.connect_signal("request::default_keybindings", function()
    awful.keyboard.append_client_keybindings({
        -- {{{ Close
        awful.key({ Modkey,           }, "c",      function(c) c:kill()                         end,
                  {description = "close", group = "client"}),
        -- }}}

        -- {{{ Swap/Move
        awful.key({ Modkey, Ctl       }, "Return", function(c) c:swap(awful.client.getmaster()) end,
                  {description = "move to master", group = "client"}),

        -- {{{ Directional swaps / move if floating
        awful.key({ Modkey, S         }, "h",      function(c)
            if c.floating then
                c:relative_move(-19, 0, 0, 0)
            else
                awful.client.swap.bydirection('left')
            end
        end,
        {description = "swap/move leftwards ", group = "client"}),

        awful.key({ Modkey, S         }, "j",      function(c)
            if c.floating then
                c:relative_move(0, 19, 0, 0)
            else
                awful.client.swap.bydirection('down')
            end
        end,
        {description = "swap/move downwards", group = "client"}),

        awful.key({ Modkey, S         }, "k",      function(c)
            if c.floating then
                c:relative_move(0, -19, 0, 0)
            else
                awful.client.swap.bydirection('up')
            end
        end,
        {description = "swap/move upwards", group = "client"}),

        awful.key({ Modkey, S         }, "l",      function(c)
            if c.floating then
                c:relative_move(19, 0, 0, 0)
            else
                awful.client.swap.bydirection('right')
            end
        end,
        {description = "swap/move rightwards", group = "client"}),

        awful.key({ Modkey, Alt, S    }, "h",      function(c)
            if c.floating then
                c:relative_move(-19, 0, 0, 0)
            else
                awful.client.swap.global_bydirection('left')
            end
        end,
        {description = "global swap/move leftwards ", group = "client"}),

        awful.key({ Modkey, Alt, S    }, "j",      function(c)
            if c.floating then
                c:relative_move(0, 19, 0, 0)
            else
                awful.client.swap.global_bydirection('down')
            end
        end,
        {description = "global swap/move downwards", group = "client"}),

        awful.key({ Modkey, Alt, S    }, "k",      function(c)
            if c.floating then
                c:relative_move(0, -19, 0, 0)
            else
                awful.client.swap.global_bydirection('up')
            end
        end,
        {description = "global swap/move upwards", group = "client"}),

        awful.key({ Modkey, Alt, S    }, "l",      function(c)
            if c.floating then
                c:relative_move(19, 0, 0, 0)
            else
                awful.client.swap.global_bydirection('right')
            end
        end,
        {description = "global swap/move rightwards", group = "client"}),

        -- }}}

        awful.key({ Modkey,           }, "o",      function(c) c:move_to_screen()               end,
                  {description = "move to screen", group = "client"}),
        -- }}}

        -- {{{ Resize / mwfact
        awful.key({ Alt               }, "h",      function(c)
            if c.floating then
                c:relative_move(0, 0, -19, 0)
            else
                awful.tag.incmwfact(-0.01)
            end
        end,
        {description = "decrease width / resize left",  group = "client"}),

        awful.key({ Alt               }, "l",      function(c)
            if c.floating then
                c:relative_move(0, 0, 19, 0)
            else
                awful.tag.incmwfact( 0.01)
            end
        end,
        {description = "increase width / resize right",  group = "client"}),

        awful.key({ Alt               }, "k",      function(c)
            c:relative_move(0, 0, 0, -19)
        end,
        {description = "resize up", group = "client"}),

        awful.key({ Alt               }, "j",      function(c)
            c:relative_move(0, 0, 0, 19)
        end,
        {description = "resize down", group = "client"}),
        -- }}}

        -- {{{ Toggle states
        awful.key({ Modkey, Alt       }, "t",      function(c) c.ontop = not c.ontop            end,
                  {description = "toggle keep on top", group = "client"}),

        awful.key({ Modkey,           }, "s",      function(c) c.sticky = not c.sticky          end,
                  {description = "toggle sticky/omnipresent", group = "client"}),

        awful.key({ Modkey,           }, "f",      function(c)
            c.fullscreen = not c.fullscreen
            c:raise()
        end,
        {description = "toggle fullscreen", group = "client"}),

        awful.key({ Modkey, S         }, "f",      function(c)
            c.floating = not c.floating
            c.ontop = c.floating
        end,
        {description = "toggle floating", group = "client"}),

        awful.key({ Modkey,           }, "m",      function(c)
            -- We can assume focused is not minimized
            -- because minimized clients cannot be focused
            c.minimized = true
        end ,
        {description = "minimize", group = "client"}),

        awful.key({ Modkey, Ctl       }, "m",      function(c)
            c.maximized = not c.maximized
            c:raise()
        end ,
        {description = "toggle maximized", group = "client"}),

        awful.key({ Modkey, Alt       }, "m",      function(c)
            c.maximized_vertical = not c.maximized_vertical
            c:raise()
        end ,
        {description = "toggle maximized vertically", group = "client"}),

        awful.key({ Modkey, S, Alt    }, "m",      function(c)
            c.maximized_horizontal = not c.maximized_horizontal
            c:raise()
        end ,
        {description = "toggle maximized horizontally", group = "client"}),
        -- }}}

        -- {{{ Misc
        awful.key({ Modkey,           }, "t",      function(c)
            awful.titlebar.toggle(c)

            if c.border_width == dpi(2) then
                c.border_width = 0
            else
                c.border_width = dpi(2)
            end
        end,
        {description = "toggle titlebar and borders", group = "client"})
        -- }}}
    })
end)
-- }}}
