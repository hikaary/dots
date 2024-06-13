vim.cmd [[hi WinBar guisp=#00000000 guibg=#00000000]]
vim.cmd [[hi WinBarNC guisp=#00000000 guibg=#0000000]]

return {
  {
    "ThePrimeagen/harpoon",
    branch = "harpoon2",
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = {},
  },
  {
    "Bekaboo/dropbar.nvim",
    branch = "feat-winbar-background-highlight",
    event = "BufReadPost",
    opts = {},
  },
}
