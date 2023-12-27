local opt = vim.opt

--------------------------------------> settings <------------------------------------------

opt.rnu = true
vim.o.guifont = "JetbrainsMono Nerd Font:h10"
--------------------------------------> usercommands <-------------------------------------------------

require "custom.autocmd"
require "custom.usrcmd"

vim.env.GIT_EDITOR = "nvr --remote-tab-wait +'set bufhidden=delete'"
