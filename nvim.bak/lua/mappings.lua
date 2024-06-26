require "nvchad.mappings"

local map = vim.keymap.set
local opts = { noremap = true, silent = true }

-- general
map("n", "<leader>q", ":quit<Return>", opts)
map("n", "q", ":quit<Return>", opts)
map("n", ";", ":")
map("n", "<C-j>", ":m .+1<CR>==", opts)
map("n", "<C-k>", ":m .-2<CR>==", opts)
map("n", "<leader>h", "", opts)
map("n", ";", ":", { desc = "CMD enter command mode" })
map("i", "jk", "<ESC>")

-- map("n", "<leader>e", "<cmd>lua require('mini.files').open()<CR>")
map("n", "<leader>e", "<cmd>NvimTreeToggle<CR>", { desc = "Toggle NvimTree" })
map("n", "-", "<CMD>Oil<CR>", { desc = "Open parent directory" })

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

map({ "n", "t" }, "<C-f>", function()
  require("nvchad.term").toggle { pos = "float", id = "floatTerm", float_opts = {} }
end)

-- split
map("n", "<leader>sv", "<cmd>:vsplit<CR>")

--LSP
--
map("n", "<leader>lr", function()
  return ":IncRename " .. vim.fn.expand "<cword>"
end, { expr = true })

map("n", "<leader>gd", ":Telescope lsp_definitions<CR>", opts)
map("n", "gd", "", opts)
