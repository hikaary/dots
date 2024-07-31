return {
  {
    lazy = false,
    "echasnovski/mini.nvim",
    config = function()
      require("mini.surround").setup()
    end,
  },
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    config = function()
      require("nvim-autopairs").setup {
        map_cr = false,
      }
    end,
  },
}
