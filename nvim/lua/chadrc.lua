---@type ChadrcConfig
local M = {}

M.ui = {
  theme = "decay",
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
}

return M
