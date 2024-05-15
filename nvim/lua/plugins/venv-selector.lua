return {
  {
    "linux-cultist/venv-selector.nvim",
    dependencies = { "neovim/nvim-lspconfig", "nvim-telescope/telescope.nvim" },
    opts = {
      path = "~/.cache/pypoetry/virtualenvs/",
      auto_refresh = true,
      notify_user_on_activate = true,
    },
    event = "VeryLazy",

    keys = { { "<leader>cv", "<cmd>:VenvSelect<cr>", desc = "Select VirtualEnv" } },
  },
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      if type(opts.ensure_installed) == "table" then
        vim.list_extend(opts.ensure_installed, { "ninja", "python", "rst", "toml" })
      end
    end,
    indent = {
      enable = true,
    },
  },
  {
    "antosha417/nvim-lsp-file-operations",
    lazy = false,
    config = function()
      require("lsp-file-operations").setup()
    end,
  },
}
