return {
  "ThePrimeagen/refactoring.nvim",
  event = "VeryLazy",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-treesitter/nvim-treesitter",
  },
  config = true,
  keys = {
    { "<leader>rr", "<cmd>Refactor<cr>", desc = "Refactor" },
  },
}
