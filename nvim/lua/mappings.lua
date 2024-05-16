require "nvchad.mappings"

local map = vim.keymap.set
local opts = { noremap = true, silent = true }

-- general
map("n", "<Leader>q", ":quit<Return>", opts)
map("n", ";", ":")
map("n", "<C-j>", ":m .+1<CR>==", opts)
map("n", "<C-k>", ":m .-2<CR>==", opts)
map("v", "<C-j>", ":m .+1<CR>==", opts)
map("v", "<C-k>", ":m .-2<CR>==", opts)
map("n", ";", ":", { desc = "CMD enter command mode" })
map("i", "jk", "<ESC>")

-- buffer
map("n", "<leader>x", "<cmd>bd<CR>")
map("n", "<C-c>", "<cmd> %y+ <CR>")

-- split window
map("n", "sh", ":split<Return>", opts)
map("n", "sv", ":vsplit<Return>", opts)

-- move window
map("n", "sh", "<C-w>h")
map("n", "sk", "<C-w>k")
map("n", "sj", "<C-w>j")
map("n", "sl", "<C-w>l")

-- resize window
map("n", "<C-S-h>", "<C-w><")
map("n", "<C-S-l>", "<C-w>>")
map("n", "<C-S-k>", "<C-w>+")
map("n", "<C-S-j>", "<C-w>-")

-- terminal
map("n", "<C-f>", "<cmd>lua _toggle_console()<CR>", opts)
map("t", "<C-f>", "<cmd>lua _toggle_console()<CR>", opts)

-- telescope
map("n", "<leader>fw", "<cmd> Telescope live_grep <CR>")
map("n", "<leader>w", "<cmd> Telescope buffers <CR>")
map("n", "<space>ss", "<cmd>lua require('sg.extensions.telescope').fuzzy_search_results()<CR>")

map({ "n", "t" }, "<C-f>", function()
  require("nvchad.term").toggle { pos = "float", id = "floatTerm", float_opts = {} }
end)

map("n", "<leader>e", "<cmd>lua require('mini.files').open()<CR>")

-- split
map("n", "<leader>sv", "<cmd>:vsplit<CR>")
