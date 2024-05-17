-- Pull in the wezterm API
local wezterm = require("wezterm")

-- This table will hold the configuration.
local config = {}

local tab_colors = {
	"Navy",
	"Red",
	"Green",
	"Olive",
	"Maroon",
	"Purple",
	"Teal",
	"Lime",
	"Yellow",
	"Blue",
	"Fuchsia",
	"Aqua",
}
local tab_bg = "rgba(22,22,22,0)"
wezterm.on("format-tab-title", function(tab)
	if tab.is_active then
		local accent = tab_colors[(tab.tab_index % #tab_colors) + 1]
		return wezterm.format({
			{ Background = { Color = tab_bg } },
			{ Foreground = { AnsiColor = accent } },
			{ Text = " " .. wezterm.nerdfonts.ple_left_half_circle_thick },
			{ Background = { AnsiColor = accent } },
			{ Foreground = { Color = tab_bg } },
			{ Text = tostring(tab.tab_index) .. ". " .. tab.active_pane.title },
			{ Background = { Color = tab_bg } },
			{ Foreground = { AnsiColor = accent } },
			{ Text = wezterm.nerdfonts.ple_right_half_circle_thick },
		})
	else
		return wezterm.format({
			{ Background = { Color = tab_bg } },
			{ Foreground = { AnsiColor = "White" } },
			--padding to make sure this takes the same space as the active tab
			{ Text = "  " .. tostring(tab.tab_index) .. ". " .. tab.active_pane.title .. " " },
		})
	end
end)

if wezterm.config_builder then
	config = wezterm.config_builder()
end

-- Window
config.initial_rows = 45
config.initial_cols = 180
-- config.enable_tab_bar = false
config.window_decorations = "INTEGRATED_BUTTONS|RESIZE"
config.max_fps = 120
config.window_padding = {
	left = "0",
	right = "0",
	top = "0",
	bottom = "0",
}

config.use_fancy_tab_bar = false
config.hide_tab_bar_if_only_one_tab = false
config.tab_bar_at_bottom = true

-- Font
config.font = wezterm.font_with_fallback({
	"Hack Nerd Font Mono",
	"Hack NF",
	"Hack Nerd Font",
	"Hack",
	"JetBrainsMono Nerd Font",
})
config.font_size = 14
-- config.line_height = 1.2
config.window_frame = {
	font = wezterm.font({ family = "Hack Nerd Font Mono", weight = "Light" }),
	font_size = 8,
}

-- Color scheme
config.color_scheme = "Snazzy"
config.inactive_pane_hsb = {
	saturation = 0,
	brightness = 0,
}
config.tab_max_width = 32
config.colors = {
	background = "161616",
	tab_bar = {
		background = "rgba(0,0,0,0)",
		-- active_tab = { bg_color = tab_bg, fg_color = "#f4f4f4" },
		-- inactive_tab = { bg_color = tab_bg, fg_color = "#f4f4f4" },
		-- inactive_tab_hover = { bg_color = tab_bg, fg_color = "#f4f4f4", italic = false },
		-- inactive_tab_edge = "rgba(0,0,0,0)",
		-- The active tab is the one that has focus in the window
		-- 	active_tab = {
		-- 		-- The color of the background area for the tab
		-- 		-- bg_color = "rbga(0,0,0,0)",
		-- 		bg_color = "#353535",
		-- 		-- The color of the text for the tab
		-- 		fg_color = "#fff",
		--
		-- 		-- Specify whether you want "Half", "Normal" or "Bold" intensity for the
		-- 		-- label shown for this tab.
		-- 		-- The default is "Normal"
		-- 		intensity = "Normal",
		--
		-- 		-- Specify whether you want "None", "Single" or "Double" underline for
		-- 		-- label shown for this tab.
		-- 		-- The default is "None"
		-- 		underline = "Double",
		--
		-- 		-- Specify whether you want the text to be italic (true) or not (false)
		-- 		-- for this tab.  The default is false.
		-- 		italic = true,
		--
		-- 		-- Specify whether you want the text to be rendered with strikethrough (true)
		-- 		-- or not for this tab.  The default is false.
		-- 		strikethrough = false,
		-- 	},
		--
		-- 	-- Inactive tabs are the tabs that do not have focus
		-- 	inactive_tab = {
		-- 		bg_color = "#161616",
		-- 		fg_color = "#808080",
		--
		-- 		-- The same options that were listed under the `active_tab` section above
		-- 		-- can also be used for `inactive_tab`.
		-- 	},
	},
config.tab_bar_style = {
	new_tab = "",
	new_tab_hover = "",
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
	config.default_domain = "WSL:Ubuntu-22.04"
	config.window_background_image = "c:/users/onion/terminal_background.png"
	config.window_background_opacity = 1
end
config.launch_menu = launch_menu

-- and finally, return the configuration to wezterm
return config
