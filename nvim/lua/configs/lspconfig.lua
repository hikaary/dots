local on_init = require("nvchad.configs.lspconfig").on_init
local capabilities = require("nvchad.configs.lspconfig").capabilities
local on_attach = require("nvchad.configs.lspconfig").on_attach
local lspconfig = require "lspconfig"

local servers = {
  "html",
  "cssls",
  "lua_ls",
  "bashls",
  "taplo",
  "biome",
}

for _, lsp in ipairs(servers) do
  lspconfig[lsp].setup {
    on_attach = on_attach,
    on_init = on_init,
    capabilities = capabilities,
  }
end

lspconfig.lua_ls.setup {
  on_attach = on_attach,
  on_init = on_init,
  capabilities = capabilities,
  settings = {
    Lua = {
      runtime = { version = "LuaJIT" },
      diagnostics = { globals = { "vim" } },
      workspace = {
        library = vim.api.nvim_get_runtime_file("", true),
        checkThirdParty = false,
        maxPreload = 100,
        preloadFileSize = 1000,
      },
      telemetry = { enable = false },
      completion = { callSnippet = "Replace" },
      hint = { enable = false },
    },
  },
}

lspconfig.basedpyright.setup {
  on_attach = on_attach,
  on_init = on_init,
  capabilities = capabilities,
  settings = {
    basedpyright = {
      analysis = {
        typeCheckingMode = "basic",
        diagnosticMode = "openFilesOnly",
        useLibraryCodeForTypes = true,
        reportMissingImports = true,
        reportUndefinedVariable = true,
      },
    },
  },
}

lspconfig.ruff_lsp.setup {
  on_attach = on_attach,
  on_init = on_init,
  capabilities = capabilities,
  init_options = {
    settings = {
      args = {
        "--config=~/.config/nvim/ruff.toml",
      },
    },
  },
}

local function show_line_diagnostics()
  local opts = {
    focusable = false,
    close_events = { "BufLeave", "CursorMoved", "InsertEnter", "FocusLost" },
    border = "rounded",
    source = "always",
    prefix = " ",
  }
  vim.diagnostic.open_float(nil, opts)
end
vim.api.nvim_create_autocmd("CursorHold", {
  buffer = bufnr,
  callback = function()
    show_line_diagnostics()
  end,
})
