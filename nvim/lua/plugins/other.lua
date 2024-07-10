return {
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    config = function()
      require('nvim-autopairs').setup {
        map_cr = false,
      }
    end,

  },
  {
    "max397574/better-escape.nvim",
    event = "InsertEnter",
    config = function()
      require("better_escape").setup()
    end,
  },
}
