return {
  "nvimdev/lspsaga.nvim",
  event = "LspAttach",
  config = function()
    require("lspsaga").setup {
      ui = {
        border = "rounded",
        code_action = "💡",
      },
      symbol_in_winbar = {
        enable = true,
      },
      lightbulb = {
        enable = false,
      },
      outline = {
        layout = "normal",
      },
    }
  end,
  dependencies = {
    "nvim-treesitter/nvim-treesitter",
    "nvim-tree/nvim-web-devicons",
  },
}
