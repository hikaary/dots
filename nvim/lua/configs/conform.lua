require("conform").setup {
  formatters_by_ft = {
    css = { "prettierd", "prettier" },
    toml = { "taplo" },
    lua = { "stylua" },
    python = { "ruff_format", "ruff_fix" },
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
