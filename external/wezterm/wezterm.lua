local wezterm = require('wezterm')

wezterm.on("format-tab-title", function(tab, tabs, panes, config, hover, max_width)
    if tab.is_active then
        return {
            {Background={Color="#a7c080"}},
            {Foreground={Color="#2b3339"}},
            {Text="  " .. tab.active_pane.title .. "  "},
        }
    else
        return {
            {Background={Color="#384348"}},
            {Foreground={Color="#d3c6aa"}},
            {Text="  " .. tab.active_pane.title .. "  "},
        }
    end
    return tab.active_pane.title
end)

return {
    exit_behavior="Close",
    check_for_updates = false,

    font = wezterm.font('JetBrainsMono Nerd Font'),
    font_size = 13.0,
    font_rules = {
        {
            italic = true,
            font = wezterm.font('JetBrainsMono Nerd Font', { italic = true }),
        },
        {
            italic = true,
            intensity = 'Bold',
            font = wezterm.font('JetBrainsMono Nerd Font', { italic = true, bold = true }),
        },
        {
            intensity = 'Bold',
            font = wezterm.font('JetBrainsMono Nerd Font', { bold = true }),
        },
    },
    warn_about_missing_glyphs = false,

    window_padding = {
        left = "2cell",
        right = "2cell",
        top = "1cell",
        bottom = "1cell",
    },

    hide_tab_bar_if_only_one_tab = true,
    use_fancy_tab_bar = false,
    tab_bar_at_bottom = true,
    tab_and_split_indices_are_zero_based = true,

    colors = {
        tab_bar = {
            background = "#2b3339",

            active_tab = {
                bg_color = "#7fbbb3",
                fg_color = "#2b3339",
                intensity = "Bold",
            },

            inactive_tab_hover = {
                bg_color = "#445055",
                fg_color = "#d3c6aa",
            },

            new_tab = {
                bg_color = "#384348",
                fg_color = "#607279",
            },
        }
    },

    animation_fps = 1,
    default_cursor_style = "SteadyBar",

    scrollback_lines = 4096,
    enable_scroll_bar = false,

    window_background_opacity = 1.0,

    bold_brightens_ansi_colors = false,
    color_scheme = 'Everforest',
    color_schemes = {
        ['Everforest'] = {

            foreground = '#d3c6aa',
            background = '#2b3339',

            cursor_bg = '#d3c6aa',
            cursor_fg = '#2b3339',
            cursor_border = '#d3c6aa',

            selection_fg = '#2b3339',
            selection_bg = '#d3c6aa',

            scrollbar_thumb = '#2b3339',

            split = '#2b3339',

            ansi = { '#384348', '#e67e80', '#a7c080', '#ddbc7f', '#7fbbb3', '#d699b6', '#83c092', '#d3c6aa' },
            brights = { '#607279', '#e67e80', '#a7c080', '#ddbc7f', '#7fbbb3', '#d699b6', '#83c092', '#d3c6aa' },

            -- indexed = { [136] = '#af8700' },
        },
    },
}
