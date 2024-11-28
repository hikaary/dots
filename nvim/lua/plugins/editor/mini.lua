return {
  {
    lazy = false,
    "echasnovski/mini.nvim",
    config = function()
      require("mini.surround").setup()
    end,
  },
  {
    "echasnovski/mini.indentscope",
    version = false,
    event = { "BufReadPre", "BufNewFile" },
    opts = {
      symbol = "│",
      options = { try_as_border = true },
    },
  },
}
