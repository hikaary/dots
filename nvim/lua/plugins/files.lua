return {
  {
    "nvim-tree/nvim-tree.lua",
    event = "VeryLazy",
    requires = { "kyazdani42/nvim-web-devicons", opt = true },
    config = function()
      require "configs.nvim-tree"
    end,
  },
}
