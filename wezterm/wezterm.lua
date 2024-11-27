local wez = require "wezterm"

local appearance = require "lua.appearance"
local bar = wez.plugin.require "https://github.com/adriankarlen/bar.wezterm"
local mappings = require "lua.mappings"

wez.plugin.require "https://github.com/MLFlexer/resurrect.wezterm"

local c = {}

if wez.config_builder then
  c = wez.config_builder()
end

-- General configurations
c.font = wez.font "Monaspace Neon"
-- c.font_rules = {
--   {
--     italic = true,
--     intensity = "Half",
--     font = wez.font("JetBrains Mono", { weight = "Medium", italic = true }),
--   },
-- }
c.font_size = 12
c.adjust_window_size_when_changing_font_size = false
c.audible_bell = "Disabled"
c.scrollback_lines = 3000
c.default_workspace = "main"
c.status_update_interval = 2000
c.enable_wayland = true
c.enable_kitty_keyboard = false
c.use_ime = true

-- appearance
appearance.apply_to_config(c)

-- keys
mappings.apply_to_config(c)

-- bar
bar.apply_to_config(c, { enabled_modules = { hostname = false } })

return c
