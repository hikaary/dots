local opt = vim.opt

--------------------------------------> settings <------------------------------------------
vim.opt.scrolloff = 6
vim.opt.pumheight = 10
vim.opt.pumblend = 0
vim.wo.relativenumber = true
vim.opt.list = true
vim.opt.wrap = false
vim.g.indent_blankline_show_current_context = false
vim.o.guifont = "JetbrainsMono Nerd Font:h10"
--------------------------------------> usercommands <-------------------------------------------------

require "custom.autocmd"
require "custom.usrcmd"

vim.env.GIT_EDITOR = "nvr --remote-tab-wait +'set bufhidden=delete'"
