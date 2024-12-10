local wez = require "wezterm"

local M = {}

M.apply_to_config = function(c)
  c.color_scheme = "rose-pine"
  c.line_height = 1.35
  local scheme = wez.color.get_builtin_schemes()["rose-pine"]
  c.colors = {
    split = scheme.ansi[2],
  }
  c.window_background_opacity = 0.7
  c.inactive_pane_hsb = { brightness = 0.3 }
  c.window_padding = { left = "1cell", right = "1cell", top = 0, bottom = 0 }
  c.window_decorations = "NONE"
  c.show_new_tab_button_in_tab_bar = false
end

return M
