-- Main plugin entry point

return {
  -- Core UI enhancements
  require "plugins.ui",

  -- LSP and completion
  require "plugins.lsp",

  -- Editor enhancements
  require "plugins.editor",

  -- Git integration
  require "plugins.git",

  -- AI features
  require "plugins.ai",

  -- Additional tools
  require "plugins.tools",
}
