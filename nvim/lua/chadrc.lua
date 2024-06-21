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
}

return M
