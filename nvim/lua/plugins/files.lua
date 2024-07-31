return {
  {
    "ThePrimeagen/harpoon",
    lazy = false,
    branch = "harpoon2",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      require "configs.harpoon"
    end,
  },
  {
    "nvim-tree/nvim-tree.lua",
    lazy = false,
    requires = { 'kyazdani42/nvim-web-devicons', opt = true },
    config = function()
      require("configs.nvim-tree")
    end,
  },
}
