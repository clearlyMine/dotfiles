-- Pull in the wezterm API
local wezterm = require("wezterm")

-- This table will hold the configuration.
local config = {}

-- In newer versions of wezterm, use the config_builder which will
-- help provide clearer error messages
if wezterm.config_builder then
	config = wezterm.config_builder()
end

-- Window
config.initial_rows = 45
config.initial_cols = 180
-- config.enable_tab_bar = false
config.window_decorations = "RESIZE"
config.window_background_opacity = 0.99
config.max_fps = 144
-- config.animation_fps = 60
config.cursor_blink_rate = 250
config.window_padding = {
	left = "0.25cell",
	right = "0.25cell",
	top = "0.25cell",
	bottom = "0cell",
}

config.use_fancy_tab_bar = true
config.hide_tab_bar_if_only_one_tab = false
config.tab_bar_at_bottom = true

-- Font
config.font = wezterm.font_with_fallback({
	-- 'RobotoMono Nerd Font',
	-- 'Fira Code',
	-- { family = 'Hack NF Mono', weight = 'Regular', italic = false, stretch = "Regular", style = "Regular" },
	"Hack Nerd Font Mono",
	"Hack NF",
	"Hack Nerd Font",
	"Hack",
	"JetBrainsMono Nerd Font",
	-- 'Cascadia Code PL',
	-- 'Cascadia Code',
	-- 'Material Design Icons Desktop',
})
config.font_size = 14
-- config.line_height = 1.2
config.window_frame = {
	font = wezterm.font({ family = "RobotoMono Nerd Font", weight = "Regular" }),
	font_size = 8,
	-- The overall background color of the tab bar when
	-- the window is focused
	active_titlebar_bg = "#161616",
	-- The overall background color of the tab bar when
	-- the window is not focused
	inactive_titlebar_bg = "#353535",
}

-- Color scheme
config.color_scheme = "Snazzy"
config.colors = {
	background = "161616",
	tab_bar = {
		background = "#161616",
		inactive_tab_edge = "#161616",
		-- The active tab is the one that has focus in the window
		active_tab = {
			-- The color of the background area for the tab
			bg_color = "#161616",
			-- The color of the text for the tab
			fg_color = "#c0c0c0",

			-- Specify whether you want "Half", "Normal" or "Bold" intensity for the
			-- label shown for this tab.
			-- The default is "Normal"
			intensity = "Normal",

			-- Specify whether you want "None", "Single" or "Double" underline for
			-- label shown for this tab.
			-- The default is "None"
			underline = "None",

			-- Specify whether you want the text to be italic (true) or not (false)
			-- for this tab.  The default is false.
			italic = false,

			-- Specify whether you want the text to be rendered with strikethrough (true)
			-- or not for this tab.  The default is false.
			strikethrough = false,
		},

		-- Inactive tabs are the tabs that do not have focus
		inactive_tab = {
			bg_color = "#353535",
			fg_color = "#808080",

			-- The same options that were listed under the `active_tab` section above
			-- can also be used for `inactive_tab`.
		},
	},
}

local act = wezterm.action
config.keys = {
	-- Change debug menu keys
	{
		key = "d",
		mods = "CTRL|SHIFT|SUPER",
		action = act.ShowDebugOverlay,
	},
	-- Be more like vim
	{
		key = "L",
		mods = "CTRL|SHIFT",
		action = act.ActivatePaneDirection("Right"),
	},
	{
		key = "H",
		mods = "CTRL|SHIFT",
		action = act.ActivatePaneDirection("Left"),
	},
	{
		key = "J",
		mods = "CTRL|SHIFT",
		action = act.ActivatePaneDirection("Down"),
	},
	{
		key = "K",
		mods = "CTRL|SHIFT",
		action = act.ActivatePaneDirection("Up"),
	},
	{
		key = "|",
		mods = "CTRL|SHIFT|ALT",
		action = act.SplitHorizontal({ domain = "CurrentPaneDomain" }),
	},
	{
		key = "_",
		mods = "CTRL|SHIFT|ALT",
		action = act.SplitVertical({ domain = "CurrentPaneDomain" }),
	},
}

local launch_menu = {}

if wezterm.target_triple == "x86_64-pc-windows-msvc" then
	table.insert(launch_menu, {
		label = "PowerShell 7",
		args = { "C:\\Program Files\\PowerShell\\7\\pwsh.exe", "-NoLogo" },
	})
	config.font_size = 10
	config.font = wezterm.font_with_fallback({
		-- 'RobotoMono Nerd Font',
		-- 'Fira Code',
		-- { family = 'Hack NF Mono', weight = 'Regular', italic = false, stretch = "Regular", style = "Regular" },
		"Hack Nerd Font Mono",
		"Hack NF Mono",
		"Hack NF",
		"Hack Nerd Font",
		"Hack",
		"JetBrainsMono Nerd Font",
		-- 'Cascadia Code PL',
		-- 'Cascadia Code',
		-- 'Material Design Icons Desktop',
	})
	config.window_decorations = "RESIZE"
	config.default_domain = "WSL:Ubuntu-22.04"
end
config.launch_menu = launch_menu

-- and finally, return the configuration to wezterm
return config
