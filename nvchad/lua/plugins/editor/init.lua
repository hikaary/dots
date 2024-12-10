-- This file serves as an index for all editor enhancement plugins
return {
  require "plugins.editor.conform",      -- Code formatting
  require "plugins.editor.treesitter",   -- Syntax highlighting and code analysis
  require "plugins.editor.indent-blankline", -- Indentation guides
  require "plugins.editor.mini",         -- Collection of minimal editor enhancements
  require "plugins.editor.autopairs",    -- Auto-close pairs
}
