-- Pull in the wezterm API
local wezterm = require 'wezterm'

-- This table will hold the configuration.
local config = {}

-- In newer versions of wezterm, use the config_builder which will
-- help provide clearer error messages
if wezterm.config_builder then
    config = wezterm.config_builder()
end

-- This is where you actually apply your config choices
if wezterm.target_triple == 'x86_64-pc-windows-msvc' then
    config.default_prog = { 'pwsh.exe', '-NoLogo' }
end
config.color_scheme = 'Snazzy'
config.font = wezterm.font_with_fallback {
    -- 'RobotoMono Nerd Font',
    -- 'Fira Code',
    -- { family = 'Hack NF Mono', weight = 'Regular', italic = false, stretch = "Regular", style = "Regular" },
    'Hack Nerd Font Mono',
    'Hack NF',
    'Hack Nerd Font',
    'Hack',
    'JetBrainsMono Nerd Font',
    -- 'Cascadia Code PL',
    -- 'Cascadia Code',
    -- 'Material Design Icons Desktop',
}
-- config.font = wezterm.font('Hack NF Mono')
config.font_size = 14;
-- config.line_height = 1.2
config.window_frame = {
    font = wezterm.font { family = 'RobotoMono Nerd Font', weight = 'Regular' },
}



local launch_menu = {}

if wezterm.target_triple == 'x86_64-pc-windows-msvc' then
    table.insert(launch_menu, {
        label = 'PowerShell 7',
        args = { 'C:\\Program Files\\PowerShell\\7\\pwsh.exe', '-NoLogo' },
    })
    config.font_size = 10
    config.font = wezterm.font_with_fallback {
        -- 'RobotoMono Nerd Font',
        -- 'Fira Code',
        -- { family = 'Hack NF Mono', weight = 'Regular', italic = false, stretch = "Regular", style = "Regular" },
        'Hack NF Mono',
        'Hack Nerd Font Mono',
        'Hack NF',
        'Hack Nerd Font',
        'Hack',
        'JetBrainsMono Nerd Font',
        -- 'Cascadia Code PL',
        -- 'Cascadia Code',
        -- 'Material Design Icons Desktop',
    }
    config.window_decorations = "RESIZE"
end
config.launch_menu = launch_menu

-- and finally, return the configuration to wezterm
return config
