local wez = require "wezterm"

local M = {}

M.apply_to_config = function(c)
  local modal = wez.plugin.require "https://github.com/MLFlexer/modal.wezterm"
  modal.apply_to_config(c)
end

return M
