local configs = require "nvchad.configs.lspconfig"
local function get_python_root_dir(fname)
  local util = require "lspconfig/util"
  return util.root_pattern("pyproject.toml", "setup.py", "setup.cfg", "requirements.txt", ".git")(fname)
    or util.path.dirname(fname)
end
vim.opt.exrc = true
local servers = {
  html = {},
  awk_ls = {},
  bashls = {},

  basedpyright = {
    enabled = true,
    settings = {
      basedpyright = {
        analysis = {
          maxLineLength = 79,
          typeCheckingMode = "basic", -- off, basic, standard, strict, all
          autoSearchPaths = true,
          useLibraryCodeForTypes = true,
          autoImportCompletions = true,
          diagnosticsMode = "openFilesOnly", -- workspace, openFilesOnly
          diagnosticSeverityOverrides = {
            reportMissingTypeStubs = "error",
            reportUnknownVariableType = "error",
            reportUnknownArgumentType = "error",
            reportUnusedCallResult = "error",
            reportUnusedImports = true,
            reportUnusedVariable = true,
            reportUnusedClass = "warning",
            reportUnusedFunction = "warning",
            reportUndefinedVariable = true,
          },
        },
      },
    },
  },
}

for name, opts in pairs(servers) do
  opts.on_init = configs.on_init
  opts.on_attach = configs.on_attach
  opts.capabilities = configs.capabilities

  require("lspconfig")[name].setup(opts)
end
