-- This file serves as an index for all LSP-related plugins
return {
  require "plugins.lsp.lspconfig", -- Base LSP configuration
  require "plugins.lsp.blink", -- Completion engine
  require "plugins.lsp.lspsaga", -- Enhanced LSP UI
  require "plugins.lsp.aerial", -- Code outline window
  require "plugins.lsp.trouble", -- Pretty diagnostics
  require "plugins.lsp.mason", -- LSP installer
}
