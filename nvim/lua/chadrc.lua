---@type ChadrcConfig
local M = {}

M.ui = {
  transparency = true,
  theme = "onedark",
  statusline = {
    order = {
      "mode",
      "file",
      "git",
      "%=",
      "diagnostics",
      "cwd",
      "cursor",
    },
  },

  tabufline = {
    enabled = false,
  },

  hl_override = {
    Comment = { italic = true },
    ["@comment"] = { italic = true },
  },
}

return M
