require "nvchad.mappings"

-- add yours here

local map = vim.keymap.set
local opts = { noremap = true, silent = true }

map("n", ";", ":", { desc = "CMD enter command mode" })

-- general
map("n", "<leader>q", ":quit<Return>", opts)
map("n", "q", ":quit<Return>", opts)
map("n", ";", ":")
map("n", "<C-s>", ":write<CR>", opts)
map("n", "<C-j>", ":m .+1<CR>==", opts)
map("n", "<C-k>", ":m .-2<CR>==", opts)
map("n", "<leader>h", "", opts)
map("n", ";", ":", { desc = "CMD enter command mode" })
map("n", "<leader>v", "")
map("n", "<C-c>", "<cmd>%y+<CR>", { desc = "file copy whole" })
map("n", "<Esc>", "<cmd>noh<CR>", { desc = "general clear highlights" })

map("n", "<leader>e", "<cmd>NvimTreeToggle<CR>", { desc = "Toggle NvimTree" })
-- map('n', '<leader>e', ':CHADopen<CR>', opts)
-- map("n", "<leader>e", ":Neotree toggle<CR>", { noremap = true, silent = true })

-- move lines
map("v", "<C-j>", ":m '>+1<CR>gv=gv", opts)
map("v", "<C-k>", ":m '<-2<CR>gv=gv", opts)
map("n", "<C-k>", ":m .-2<CR>==", opts)
map("n", "<C-j>", ":m .+1<CR>==", opts)

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
map("n", "<leader>fo", "<cmd>Telescope oldfiles<CR>")

-- Term
map({ "n", "t" }, "<C-f>", function()
  require("nvterm.terminal").toggle "float"
end)

-- split
map("n", "<leader>sv", "<cmd>:vsplit<CR>")

-- Venv select
map("n", "<leader>cv", "<cmd>VenvSelect<cr>")
