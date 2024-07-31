return {
  "hedyhli/outline.nvim",
  cmd = "Outline",
  init = function()
    vim.keymap.set("n", "<leader>w", "<cmd>Outline<CR>", { desc = "Toggle Outline" })
  end,
  config = function()
    require("outline").setup {}
  end,
}
