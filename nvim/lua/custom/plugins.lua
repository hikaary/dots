local overrides = require "custom.configs.overrides"

---@type NvPluginSpec[]
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
    "max397574/better-escape.nvim",
    event = "InsertEnter",
    config = function()
      require("better_escape").setup()
    end,
  },
  {
    "folke/trouble.nvim",
    event = "BufReadPre",
    config = function()
      require("trouble").setup()
    end,
  },

  {
    "toppair/peek.nvim",
    build = "deno task --quiet build:fast",
    config = function()
      require("peek").setup()
    end,
  },
  {
    "alexghergh/nvim-tmux-navigation",
    event = "VeryLazy",
    config = function()
      require("nvim-tmux-navigation").setup { disable_when_zoomed = true } -- defaults to false
    end,
  },
  {
    "tpope/vim-surround",
    event = "VeryLazy",
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
    "dustinblackman/oatmeal.nvim",
    cmd = { "Oatmeal" },
    keys = {
      { "<leader>om", mode = "n", desc = "Start Oatmeal session" },
      { "<leader>om", mode = "v", desc = "Start Oatmeal session" },
    },
    opts = {
      backend = "ollama",
      model = "codellama:7b-python",
    },
  },
  -- UI
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

  --
  {
    "folke/todo-comments.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    event = "BufReadPre",
    config = function()
      require "custom.configs.extras.todo"
    end,
  },
  {
    "nacro90/numb.nvim",
    event = "VeryLazy",
    config = function()
      require("numb").setup()
    end,
  },
}

return plugins
