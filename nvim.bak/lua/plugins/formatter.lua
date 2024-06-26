return {
  {

    "stevearc/conform.nvim",
    lazy = false,
    config = function()
      require "configs.conform"
    end,
  },
  {
    "dense-analysis/ale",
    config = function()
      require "configs.ale"
    end,
    lazy = false,
  },
}
