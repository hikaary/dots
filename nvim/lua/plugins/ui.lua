return {
  {
    "stevearc/dressing.nvim",
    lazy = false,
    config = function()
      require("dressing").setup {}
    end,
  },
  {
    "NvChad/nvim-colorizer.lua",
    lazy = false,
    opts = {
      user_default_options = {
        RRGGBBAA = true,
        rgb_fn = true,
        hsl_fn = true,
        css = true,
        css_fn = true,
        sass = { enable = true, parsers = { "css" } },
        mode = "virtualtext",
        virtualtext = "󱓻",
      },
    },
  },
  {
    "NvChad/nvterm",
    config = function()
      require "configs.nvterm"
    end,
  },
  {
    "Wansmer/treesj",
    keys = { "<leader>m" },
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    opts = {},
  },
  {
    "nvim-neorg/neorg",
    lazy = false,
    version = "*",
    config = true,
  },
}
