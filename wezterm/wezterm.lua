local wezterm = require("wezterm")
local config = {}
if wezterm.config_builder then
	config = wezterm.config_builder()
end

-- Основные настройки
config.font = wezterm.font("JetBrains Mono")
config.font_size = 12.0
config.color_scheme = "Catppuccin Mocha"
config.term = "xterm-256color"
config.scrollback_lines = 10000
config.window_background_opacity = 0.9
config.window_padding = {
	left = 20,
	right = 20,
	top = 0,
	bottom = 0,
}

-- Тема
local custom = wezterm.color.get_builtin_schemes()["Catppuccin Mocha"]
custom.background = "#11111b"
config.color_schemes = {
	["my"] = custom,
}
config.color_scheme = "my"

-- Отключение ненужных элементов интерфейса
config.enable_tab_bar = false
config.use_fancy_tab_bar = false

-- Оптимизация производительности
config.front_end = "WebGpu"
config.webgpu_power_preference = "HighPerformance"

-- Улучшенная поддержка шрифтов и лигатур
config.harfbuzz_features = { "calt", "liga", "dlig", "ss01", "ss02", "ss03", "ss04", "ss05", "ss06", "ss07", "ss08" }

-- Быстрый выбор текста
config.quick_select_patterns = {
	"https?://\\S+",
	"\\d{1,3}\\.\\d{1,3}\\.\\d{1,3}\\.\\d{1,3}",
	"/\\S+",
}

-- Клавиатурные сочетания, оптимизированные для работы с tmux
config.keys = {
	{ key = "C", mods = "CTRL|SHIFT", action = wezterm.action.CopyTo("ClipboardAndPrimarySelection") },
	{ key = "V", mods = "CTRL|SHIFT", action = wezterm.action.PasteFrom("Clipboard") },
	{ key = "F", mods = "CTRL|SHIFT", action = wezterm.action.QuickSelect },
	{ key = "Backspace", mods = "CTRL", action = wezterm.action.SendString("\x17") },
	{
		key = "q",
		mods = "CTRL",
		action = wezterm.action.Multiple({
			wezterm.action.SendString("clear"),
			wezterm.action.SendKey({ key = "Enter" }),
		}),
	},
	{
		key = "u",
		mods = "CTRL|SHIFT",
		action = wezterm.action.Multiple({
			wezterm.action.SendString("CTRL|SHIFT"),
			wezterm.action.SendKey({ key = "Enter" }),
		}),
	},
}

-- Настройки мыши для удобной работы с tmux
config.mouse_bindings = {
	{
		event = { Down = { streak = 1, button = "Right" } },
		mods = "NONE",
		action = wezterm.action.PasteFrom("Clipboard"),
	},
	{
		event = { Down = { streak = 3, button = "Left" } },
		action = wezterm.action.SelectTextAtMouseCursor("Line"),
	},
}

config.animation_fps = 1

return config
