local wezterm = require("wezterm")

local config = {}

-- Terminal settings
config.term = "xterm-256color"
config.scrollback_lines = 10000

-- Window appearance
config.window_background_opacity = 0.9
config.macos_window_background_blur = 20
config.hide_tab_bar_if_only_one_tab = true
config.window_decorations = "NONE"
config.window_padding = {
	left = 20,
	right = 20,
	top = 0,
	bottom = 0,
}
config.enable_wayland = true

-- Font settings
config.font = wezterm.font("jetbrains mono")
config.font_size = 16

-- Cursor settings
config.default_cursor_style = "SteadyBlock"

local custom = wezterm.color.get_builtin_schemes()["Catppuccin Mocha"]
custom.background = "#141318"
config.color_schemes = {
	["OLEDppuccin"] = custom,
}
config.color_scheme = "OLEDppuccin"

-- Keyboard shortcuts
config.keys = {
	{ key = "Backspace", mods = "CTRL", action = wezterm.action.SendString("\x17") },
	{ key = "q", mods = "CTRL", action = wezterm.action.SendString("clear\n") },
	{ key = "c", mods = "CTRL|SHIFT", action = wezterm.action.CopyTo("Clipboard") },
	{ key = "c", mods = "CTRL", action = wezterm.action.SendString("\x03") },
	{ key = "v", mods = "CTRL|SHIFT", action = wezterm.action.PasteFrom("Clipboard") },
}

return config
