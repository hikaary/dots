local configs = require "nvchad.configs.lspconfig"

local servers = {
  html = {},
  awk_ls = {},
  bashls = {},

  basedpyright = {
    enabled = true,
    settings = {
      basedpyright = {
        analysis = {
          ignore = { "*" },
          maxLineLength = 80,
          typeCheckingMode = "basic",
          reportMissingTypeStubs = "error",
          reportUnknownVariableType = "error",
          reportUnknownArgumentType = "error",
          reportUnusedCallResult = "error",
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

require("lspconfig").ruff_lsp.setup {
  init_options = {
    settings = {
      args = {
        "--select=E,F,UP,N,I,ASYNC,S,PTH",
        "--line-length=79",
        "--respect-gitignore",
        "--target-version=py311",
      },
    },
  },
}
