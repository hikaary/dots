local overrides = require "custom.configs.overrides"

local plugins = {
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      {
        "jose-elias-alvarez/null-ls.nvim",
        config = function()
          require "custom.configs.null-ls"
        end,
      },
    },

    config = function()
      require "plugins.configs.lspconfig"
      require "custom.configs.lspconfig"
    end,
  },

  -- override plugin configs
  {
    "linux-cultist/venv-selector.nvim",
    dependencies = { "neovim/nvim-lspconfig", "nvim-telescope/telescope.nvim" },
    opts = overrides.venv_selector,
    event = "VeryLazy",
  },
  {
    "williamboman/mason.nvim",
    opts = overrides.mason,
  },
  {
    "nvim-treesitter/nvim-treesitter",
    opts = overrides.treesitter,
  },
  {
    "nvim-tree/nvim-tree.lua",
    opts = overrides.nvimtree,
  },

  -- Install a plugin
  {
    "antosha417/nvim-lsp-file-operations",
    lazy = false,
    config = function()
      require("lsp-file-operations").setup()
    end,
  },
  {
    "max397574/better-escape.nvim",
    event = "InsertEnter",
    config = function()
      require("better_escape").setup()
    end,
  },
  {
    "hrsh7th/nvim-cmp",
    opts = overrides.cmp,
    dependencies = {
      {
        "L3MON4D3/LuaSnip",
        after = "nvim-cmp",
        dependencies = { "rafamadriz/friendly-snippets" },
        config = function(_, opts)
          require("plugins.configs.others").luasnip(opts)
          require("luasnip.loaders.from_vscode").load {}
        end,
      },
    },
  },
  {
    "tpope/vim-surround",
    event = "VeryLazy",
  },
  { "phaazon/hop.nvim", opts = {} },
  {
    "NvChad/nvterm",
    config = function()
      require "custom.configs.extras.nvterm"
    end,
  },
  {
    "nacro90/numb.nvim",
    event = "VeryLazy",
    config = function()
      require("numb").setup()
    end,
  },

  -- UI
  {
    "iamcco/markdown-preview.nvim",
    cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
    ft = { "markdown" },
    build = function()
      vim.fn["mkdp#util#install"]()
    end,
  },
  {
    "kdheepak/lazygit.nvim",
    cmd = "LazyGit",
    opts = overrides.lazy_git,
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
  },
  {
    "folke/noice.nvim",
    event = "VeryLazy",
    config = function()
      require "custom.configs.extras.noice"
    end,
    dependencies = {
      "MunifTanjim/nui.nvim",
      "rcarriga/nvim-notify",
    },
    enabled = true,
  },
}

return plugins
