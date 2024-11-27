return {
  {
    "RRethy/vim-illuminate",
    event = "BufReadPost",
    config = function()
      require("illuminate").configure {
        -- настройки по вашему усмотрению
      }
    end,
  },
  {
    "nvim-treesitter/nvim-treesitter-context",
    dependencies = "nvim-treesitter/nvim-treesitter",
    config = true,
  },
  {
    "danymat/neogen",
    dependencies = "nvim-treesitter/nvim-treesitter",
    config = true,
    keys = {
      { "<leader>ng", ":lua require('neogen').generate()<CR>", desc = "Neogen Comment" },
    },
  },
  {
    "mg979/vim-visual-multi",
    event = "BufReadPost",
  },
  {
    "lewis6991/impatient.nvim",
    lazy = false,
    priority = 1000,
  },
  {
    "dstein64/vim-startuptime",
    cmd = "StartupTime",
    config = function()
      vim.g.startuptime_tries = 10
    end,
  },
  {
    dir = "~/.config/nvim/lua/custom/configs/timewarrior",
    dependencies = { "MunifTanjim/nui.nvim" },
    event = "VeryLazy",
    config = function()
      require("configs.timewarrior").setup()
    end,
    keys = {
      { "<leader>ts", "<cmd>TimeStart<cr>", desc = "Start time tracking" },
      { "<leader>tp", "<cmd>TimeStop<cr>", desc = "Stop time tracking" },
      { "<leader>tt", "<cmd>TimeStatus<cr>", desc = "Show time status" },
      { "<leader>td", "<cmd>TimeSum day<cr>", desc = "Show daily summary" },
      { "<leader>tw", "<cmd>TimeSum week<cr>", desc = "Show weekly summary" },
      { "<leader>tm", "<cmd>TimeSum month<cr>", desc = "Show monthly summary" },
    },
  },
}
