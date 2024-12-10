-- Main plugin entry point

return {
  -- Core UI enhancements
  require "plugins.ui",

  -- LSP and completion
  require "plugins.lsp",

  -- Editor enhancements
  require "plugins.editor",

  -- AI features
  require "plugins.ai",

  -- Additional tools
  require "plugins.tools",
}
