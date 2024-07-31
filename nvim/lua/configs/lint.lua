local lint = require "lint"

lint.linters_by_ft = {
  python = { "ruff", "mypy" },
}

local function get_python_path()
  local venv = vim.fn.environ()["VIRTUAL_ENV"]
  if venv then
    return venv .. "/bin/python3"
  end
  return vim.fn.exepath "python3" or vim.fn.exepath "python" or "python"
end

lint.linters.ruff.args = {
  "check",
  "--config=~/.config/nvim/ruff.toml",
  "-",
}

lint.linters.mypy.args = {
  "--python-executable",
  get_python_path(),
  "--show-column-numbers",
  "--show-error-end",
  "--hide-error-codes",
  "--hide-error-context",
  "--no-color-output",
  "--no-error-summary",
  "--no-pretty",
}
local signs = { Error = "E", Warn = "W", Hint = "H", Info = "I" }
for type, icon in pairs(signs) do
  local hl = "DiagnosticSign" .. type
  vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
end

vim.diagnostic.config {
  virtual_text = {
    prefix = "●",
    spacing = 4,
  },
  float = {
    border = "rounded",
    header = "",
    prefix = function(diagnostic)
      local icons = {
        Error = " ",
        Warn = " ",
        Info = " ",
        Hint = " ",
      }
      return icons[vim.diagnostic.severity[diagnostic.severity]] or "●"
    end,
  },
  signs = true,
  underline = true,
  update_in_insert = false,
  severity_sort = true,
}

vim.o.updatetime = 250
vim.cmd [[autocmd CursorHold,CursorHoldI * lua vim.diagnostic.open_float(nil, {focus=false})]]

vim.api.nvim_create_autocmd({ "BufWritePost", "BufEnter" }, {
  pattern = "*.py",
  callback = function()
    lint.try_lint()
  end,
})

vim.api.nvim_create_user_command("DiagnosticShow", function()
  vim.diagnostic.open_float(0, { scope = "line" })
end, {})
