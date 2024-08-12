local wezterm = require("wezterm")

local config = {}

if wezterm.config_builder then
	config = wezterm.config_builder()
end

local custom = wezterm.color.get_builtin_schemes()["Catppuccin Mocha"]
custom.background = "#11111b"
config.color_schemes = {
	["my"] = custom,
}
config.color_scheme = "my"
config.font = wezterm.font("JetBrains Mono")
config.font_size = 15.0
config.use_fancy_tab_bar = false
config.automatically_reload_config = true
config.term = "xterm-256color"
config.scrollback_lines = 10000
config.selection_word_boundary = ",│`|:\"' ()[]{}<>\t"
config.window_background_opacity = 0.95
config.window_padding = {
	left = 20,
	right = 20,
	top = 0,
	bottom = 0,
}
config.hide_tab_bar_if_only_one_tab = true

config.front_end = "WebGpu"

config.harfbuzz_features = { "calt", "liga", "dlig", "ss01", "ss02", "ss03", "ss04", "ss05", "ss06", "ss07", "ss08" }

config.quick_select_patterns = {
	"https?://\\S+",
	"\\d{1,3}\\.\\d{1,3}\\.\\d{1,3}\\.\\d{1,3}",
	"/\\S+",
}

-- Клавиатурные сочетания
config.keys = {
	{ key = "Backspace", mods = "CTRL", action = wezterm.action.SendString("\x17") },
	{ key = "C", mods = "CTRL|SHIFT", action = wezterm.action.CopyTo("ClipboardAndPrimarySelection") },
	{ key = "V", mods = "CTRL|SHIFT", action = wezterm.action.PasteFrom("Clipboard") },
	{ key = "|", mods = "LEADER|SHIFT", action = wezterm.action.SplitHorizontal({ domain = "CurrentPaneDomain" }) },
	{ key = "-", mods = "LEADER", action = wezterm.action.SplitVertical({ domain = "CurrentPaneDomain" }) },
	{
		key = "q",
		mods = "CTRL",
		action = wezterm.action.Multiple({
			wezterm.action.SendString("clear"),
			wezterm.action.SendKey({ key = "Enter" }),
		}),
	},

	{ key = "F", mods = "CTRL|SHIFT", action = wezterm.action.QuickSelect },
}

return config
