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
map("n", "<leader>h", "", opts)
map("n", ";", ":", { desc = "CMD enter command mode" })
map("n", "<leader>v", "")
map("n", "<C-c>", "<cmd>%y+<CR>", { desc = "file copy whole" })
map("n", "<Esc>", "<cmd>noh<CR>", { desc = "general clear highlights" })

map("n", "<leader>e", "<cmd>NvimTreeToggle<CR>", { desc = "Toggle NvimTree" })
-- map('n', '<leader>e', ':CHADopen<CR>', opts)
-- map("n", "<leader>e", ":Neotree toggle<CR>", { noremap = true, silent = true })

-- move lines
--
map("v", "<A-j>", ":m '>+1<CR>gv=gv", opts)
map("v", "<A-k>", ":m '<-2<CR>gv=gv", opts)
map("n", "<A-k>", ":m .-2<CR>==", opts)
map("n", "<A-j>", ":m .+1<CR>==", opts)

-- split window
map("n", "sh", ":split<Return>", opts)
map("n", "sv", ":vsplit<Return>", opts)

-- move window
map("n", "sh", "<C-w>h")
map("n", "sk", "<C-w>k")
map("n", "sj", "<C-w>j")
map("n", "sl", "<C-w>l")

-- aerial
map("n", "<leader>a", "<cmd>AerialToggle!<CR>")
-- resize window
map("n", "<C-S-h>", "<C-w><")
map("n", "<C-S-l>", "<C-w>>")
map("n", "<C-S-k>", "<C-w>+")
map("n", "<C-S-j>", "<C-w>-")

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

-- Coq
map("i", "<Tab>", function()
  return vim.fn.pumvisible() == 1 and "<C-n>" or "<Tab>"
end, { expr = true, silent = true })

map("i", "<S-Tab>", function()
  return vim.fn.pumvisible() == 1 and "<C-p>" or "<S-Tab>"
end, { expr = true, silent = true })
