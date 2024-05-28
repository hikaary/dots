require("conform").setup {
  format_on_save = {
    timeout_ms = 500,
    lsp_fallback = true,
  },
  formatters_by_ft = {
    css = { "prettierd", "prettier" },
    toml = { "taplo" },
    lua = { "stylua" },
    typst = { "prettypst_formatter" },
    json = { "fixjson" },
  },
  formatters = {
    prettypst_formatter = {
      command = "prettypst",
      args = { "--use-std-in", "--use-std-out" },
      stdin = true,
      cwd = require("conform.util").root_file { ".editorconfig", "prettypst.toml" },
    },
  },
}
