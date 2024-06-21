return {
  {
    "williamboman/mason-lspconfig.nvim",
    opts = {
      ensure_installed = { "basedpyright" },
    },
  },
  {
    "williamboman/mason.nvim",
    build = ":MasonUpdate",
    opts = function(_, opts)
      opts.ensure_installed = {
        "stylua",
        "ruff-lsp",
        "hyprls",
        "fixjson",
        "json-lsp",
      }
      opts.ui = { border = "rounded" }
      if vim.g.lazyvim_python_lsp == "basedpyright" then
        opts.ensure_installed = opts.ensure_installed or {}
        table.insert(opts.ensure_installed, "basedpyright")
      end
    end,
  },
}
