local on_attach = require("plugins.configs.lspconfig").on_attach
local capabilities = require("plugins.configs.lspconfig").capabilities

local lspconfig = require "lspconfig"

local servers = { "html", "cssls", "tsserver", "clangd", "dockerls" }

for _, lsp in ipairs(servers) do
  lspconfig[lsp].setup {
    on_attach = on_attach,
    capabilities = capabilities,
  }
end

lspconfig.pyright.setup {
  on_attach = on_attach,
  capabilities = capabilities,
  settings = {
    python = {
      analysis = {
        typeCheckingMode = "basic",
        diagnosticMode = "openFilesOnly",
        autoSearchPaths = true,
        useLibraryCodeForTypes = true,
        reportOptionalMemberAccess = false,
        reportOptionalSubscript = false,
        diagnosticSeverityOverrides = {
          reportPrivateImportUsage = "none",
          reportUndefinedVariable = "none",
        },
        maxLineLength = 88,
      },
    },
  },
}

-- lspconfig.ruff_lsp.setup {
--   capabilities = capabilities,
--   on_attach = function(client, bufnr)
--     vim.api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")
--   end,
--   settings = {
--     args = { "--config=~/.config/nvim/lua/custom/configs/ruff.toml" },
--     run = "onSave",
--   },
-- }
