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
}
