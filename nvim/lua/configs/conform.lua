local conform = require "conform"

conform.setup {
  formatters_by_ft = {
    lua = { "stylua" },
    python = { "ruff_format", "ruff_fix", "ruff_organize_imports" },
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

conform.formatters.ruff = {
  prepend_args = { "--config", "~/.config/nvim/ruff.toml" },
}
