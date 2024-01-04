vim.api.nvim_create_user_command("Nvtfloat", function()
  require("nvterm.terminal").toggle "float"
end, {})

vim.api.nvim_create_user_command("NotifLog", function()
  require("notify").history()
end, {})
