local M = {}

local highlights = require "custom.highlights"

M.ui = {
  theme = "everforest_green",
  theme_toggle = { "everforest_green", "everforest" },
  hl_override = highlights.override,
  transparency = true,

  hl_add = highlights.add,

  tabufline = {
    show_numbers = false,
    enabled = true,
    lazyload = true,
    overriden_modules = function(modules)
      table.remove(modules, 4)
    end,
  },

  statusline = {
    theme = "minimal",
    separator_style = "round",
    overriden_modules = nil,
  },
  nvdash = {
    load_on_startup = true,
  },
}

M.plugins = "custom.plugins"

M.mappings = require "custom.mappings"

return M
