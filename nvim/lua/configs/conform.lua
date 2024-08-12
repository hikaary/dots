local conform = require "conform"

conform.formatters.ruff_format = {
  prepend_args = { "format", "--config", "~/.config/nvim/ruff.toml" },
}

conform.setup {
  formatters_by_ft = {
    lua = { "stylua" },
    python = { "ruff_organize_imports", "ruff_format", "ruff_fix" },
    javascript = { "prettier" },
    typescript = { "prettier" },
    json = { "prettier" },
    html = { "prettier" },
    css = { "prettier" },
    sh = { "shfmt" },
  },
  format_on_save = {
    timeout_ms = 500,
    lsp_fallback = true,
  },
}
