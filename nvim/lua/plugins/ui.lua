return {
  {
    "stevearc/dressing.nvim",
    event = "VeryLazy",
    config = function()
      require("dressing").setup {
        nui = {
          position = "50%",
          size = nil,
          relative = "editor",
          border = {
            style = "rounded",
          },
          buf_options = {
            swapfile = false,
            filetype = "DressingSelect",
          },
          win_options = {
            winblend = 100,
          },
          max_width = 80,
          max_height = 40,
          min_width = 40,
          min_height = 10,
        },
        input = {
          win_options = {
            winhighlight = "NormalFloat:DiagnosticError",
          },
        },
      }
    end,
  },
  {
    "NvChad/nvim-colorizer.lua",
    lazy = false,
    opts = {
      filetypes = {
        "*", -- all filetypes
        "!sass", -- исключить sass
        "!scss", -- исключить scss
      },
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
