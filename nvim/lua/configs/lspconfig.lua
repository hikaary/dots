local configs = require "nvchad.configs.lspconfig"

local servers = {
  html = {},
  awk_ls = {},
  bashls = {},

  pyright = { enabled = false },
  basedpyright = {
    enabled = true,
    settings = {
      basedpyright = {
        analysis = {
          typeCheckingMode = "basic",
          maxLineLength = 80,

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
  on_init = configs.on_init,
  capabilities = configs.capabilities,
  on_attach = function(client, _)
    if client.name == "ruff_lsp" then
      client.server_capabilities.hoverProvider = false
    end
  end,
}

vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = "*",
  callback = function(args)
    require("conform").format { bufnr = args.buf }
  end,
})
