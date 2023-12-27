local M = {}

---@type Base46HLGroupsList
M.override = {
  Comment = {
    italic = true,
  },
  Search = { fg = "black", bg = "blue" },
  IncSearch = { fg = "black", bg = "red" },
  CurSearch = { fg = "black", bg = "blue" },
  Substitute = { fg = "black", bg = "green" },
  NvDashAscii = { bg = "NONE", fg = "blue" },
  NvDashButtons = { bg = "NONE" },
  FoldColumn = { bg = "NONE" },
  LspReferenceRead = { link = "Underlined" },
  LspReferenceText = { link = "Underlined" },
  LspReferenceWrite = { link = "Underlined" },
}

---@type HLTable
M.add = {
  NvimTreeOpenedFolderName = { fg = "green", bold = false },
  DiffviewDiffAdd = { fg = "black", bg = "green" },
  DiffviewDiffChange = { fg = "black", bg = "light_grey" },
  DiffviewDiffModified = { fg = "black", bg = "orange" },
  DiffviewDiffDelete = { fg = "black", bg = "red" },
  DiffviewDiffAddAsDelete = { fg = "black", bg = "red" },
}

return M
