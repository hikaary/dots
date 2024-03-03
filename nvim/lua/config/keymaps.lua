local map = vim.keymap.set
local opts = { noremap = true, silent = true }

--Removed
map("n", "<C-/>", "")
map("v", "<C-/>", "")

-- general
map("n", "<Leader>q", ":quit<Return>", opts)
map("n", "<Leader>l", "")
map("n", ";", ":")
map("n", "<C-j>", ":m .+1<CR>==", opts)
map("n", "<C-k>", ":m .-2<CR>==", opts)
map("v", "<C-j>", ":m .+1<CR>==", opts)
map("v", "<C-k>", ":m .-2<CR>==", opts)
map("n", "<leader>fe", "")

map("n", "<C-c>", "<cmd> %y+ <CR>")

-- nvimtree
map("n", "<C-e>", "<cmd> NvimTreeToggle <CR>")
map("n", "<leader>e", "<cmd> NvimTreeToggle <CR>")

-- Split window
map("n", "ss", ":split<Return>", opts)
map("n", "sv", ":vsplit<Return>", opts)

-- Move window
map("n", "sh", "<C-w>h")
map("n", "sk", "<C-w>k")
map("n", "sj", "<C-w>j")
map("n", "sl", "<C-w>l")

-- Resize window
map("n", "<C-S-h>", "<C-w><")
map("n", "<C-S-l>", "<C-w>>")
map("n", "<C-S-k>", "<C-w>+")
map("n", "<C-S-j>", "<C-w>-")

-- Term
map("n", "<C-f>", '<CMD>lua require("FTerm").toggle()<CR>')
map("t", "<C-f>", '<C-\\><C-n><CMD>lua require("FTerm").toggle()<CR>')