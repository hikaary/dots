return {
  "nvimtools/none-ls.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
  },
  config = function()
    require "configs.none-ls"
  end,
  lazy = false,
}
