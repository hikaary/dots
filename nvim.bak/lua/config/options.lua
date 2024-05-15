vim.g.mapleader = " "

vim.scriptencoding = "utf-8"
vim.opt.encoding = "utf-8"
vim.opt.fileencoding = "utf-8"

vim.opt.number = true

vim.opt.title = true
vim.opt.autoindent = true
vim.opt.smartindent = true
vim.opt.hlsearch = true
vim.opt.backup = false
vim.opt.showcmd = true
vim.opt.cmdheight = 0
vim.opt.laststatus = 0
vim.opt.expandtab = true
vim.opt.inccommand = "split"
vim.opt.ignorecase = true
vim.opt.smarttab = true
vim.opt.breakindent = true
vim.opt.splitbelow = true
vim.opt.splitright = true
vim.opt.splitkeep = "cursor"
vim.opt.mouse = ""
vim.opt.scrolloff = 6
vim.opt.pumheight = 10
vim.opt.pumblend = 0
vim.wo.relativenumber = true
vim.opt.list = true
vim.opt.wrap = false
vim.g.indent_blankline_show_current_context = false
vim.opt.formatoptions:append({ "r" })

vim.api.nvim_set_hl(0, "NormalFloat", {
  fg = "none",
  bg = "none",
})
