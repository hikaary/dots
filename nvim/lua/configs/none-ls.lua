local null_ls = require "null-ls"

local function get_project_root()
  return vim.fn.getcwd()
end

local mypy = null_ls.builtins.diagnostics.mypy.with {
  command = "mypy",
  args = function(params)
    return {
      -- "run",
      -- "mypy",
      "--hide-error-context",
      "--no-color-output",
      "--show-absolute-path",
      "--show-column-numbers",
      "--show-error-codes",
      "--no-error-summary",
      "--no-pretty",
      "--follow-imports=silent",
      "--ignore-missing-imports",
      params.bufname,
    }
  end,
  cwd = get_project_root,
  timeout = 10000,
}

local sources = {
  mypy,
}

null_ls.setup {
  sources = sources,
  debug = true,
}
