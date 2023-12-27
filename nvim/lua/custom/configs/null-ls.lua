local null_ls = require "null-ls"

local formatting = null_ls.builtins.formatting
local lint = null_ls.builtins.diagnostics
local augroup = vim.api.nvim_create_augroup("LspFormatting", {})
local helpers = require "null-ls.helpers"
local methods = require "null-ls.methods"

local function ruff_format()
  return helpers.make_builtin {
    name = "ruff formatter",
    meta = {
      url = "https://github.com/charliermarsh/ruff/",
      description = "An extremely fast Python linter, written in Rust.",
    },
    method = methods.internal.FORMATTING,
    filetypes = { "python" },
    generator_opts = {
      command = "ruff",
      args = {
        "format",
        "--config",
        "~/.config/nvim/lua/custom/configs/ruff.toml",
        "--stdin-filename",
        "$FILENAME",
        "-",
      },
      to_stdin = true,
    },
    factory = helpers.formatter_factory,
  }
end

local function ruff_sort_import()
  return helpers.make_builtin {
    name = "ruff isort",
    meta = {
      url = "https://github.com/charliermarsh/ruff/",
      description = "An extremely fast Python linter, written in Rust.",
    },
    method = methods.internal.FORMATTING,
    filetypes = { "python" },
    generator_opts = {
      command = "ruff",
      args = {
        "check",
        "--fix",
        "--config",
        "~/.config/nvim/lua/custom/configs/ruff.toml",
        "--stdin-filename",
        "$FILENAME",
        "-",
      },
      to_stdin = true,
    },
    factory = helpers.formatter_factory,
  }
end

local sources = {
  -- Other
  formatting.prettier.with { filetypes = { "yaml", "json" } },
  -- Lua
  formatting.stylua,

  -- cpp
  formatting.clang_format,

  lint.ruff,
  lint.hadolint,

  -- json / yaml
  null_ls.builtins.diagnostics.spectral,

  ruff_sort_import(),
  ruff_format(),
}

null_ls.setup {
  on_attach = function(client, bufnr)
    if client.supports_method "textDocument/formatting" then
      vim.api.nvim_clear_autocmds { group = augroup, buffer = bufnr }
      vim.api.nvim_create_autocmd("BufWritePre", {
        group = augroup,
        buffer = bufnr,
        callback = function()
          vim.lsp.buf.format { bufnr = bufnr }
        end,
      })
    end
  end,
  debug = true,
  sources = sources,
}
