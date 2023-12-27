local M = {}

M.general = {
  n = {
    [";"] = { ":", "enter command mode", opts = { nowait = true } },
    ["\\\\"] = { "<cmd>:vsplit<CR>", "Vertical split" },
    ["<leader>re"] = { "<cmd>e<CR>", "Restart null-ls" },
    ["<A-j>"] = { "V:m '>+1<cr>gv=gv<esc>", "Move one line down with Alt-j", opts = { silent = true } },
    ["<A-k>"] = { "V:m '<-2<cr>gv=gv<esc>", "Move one line up with Alt-k", opts = { silent = true } },
    ["<S-h>"] = { "^", "Move up with Alt-k" },
    ["<S-l>"] = { "$", "Move up with Alt-l" },
    ["<leader>lg"] = { "<cmd> LazyGit <CR>", "Open LazyGit", opts = { silent = true } },
    ["<S-.>"] = { "<gv", "Move Indent Left" },
    ["<S-,>"] = { ">gv", "Move Indent Right" },
    -- ["<leader>th"] = { "", "Removed" },
  },
  v = {
    ["<A-j>"] = { ":m '>+1<CR>gv=gv", "Move up with Alt-j", opts = { silent = true } },
    ["<A-k>"] = { ":m '<-2<CR>gv=gv", "Move up with Alt-k", opts = { silent = true } },
    ["<S-h>"] = { "^", "Move up with Alt-k" },
    ["<S-l>"] = { "$", "Move up with Alt-l" },
    ["<S-.>"] = { "<gv", "Move Indent Left" },
    ["<S-,>"] = { ">gv", "Move Indent Right" },
  },
  i = {
    ["<A-j>"] = {
      "<Esc>:m .+1<CR>==gi",
      "Move the line up",
      opts = { silent = true },
    },

    ["<A-k>"] = {
      "<Esc>:m .-2<CR>==gi",
      "Move the line down",
      opts = { silent = true },
    },
  },
}

-- M.dap = {
--   plugin = true,
--   n = {
--     ["<leader>db"] = { "<cmd> DapToggleBreakpoint <CR>" },
--   },
-- }
--
-- M.dap_python = {
--   plugin = true,
--   n = {
--     ["<leader>dpr"] = {
--       function()
--         require("dap-python").test_method()
--       end,
--     },
--   },
-- }
--
M.trouble = {
  n = {
    ["<leader>xd"] = { "<cmd>TroubleToggle<CR>", "Toggle Trouble" },
    ["<leader>xx"] = { "<cmd>TroubleToggle document_diagnostics<CR>", "Trouble Document Diagonstics" },
  },
}

M.TODO = {
  n = {
    ["<leader>ft"] = { "<cmd>TodoTelescope<CR>", "Toggle Trouble" },
  },
}

M.nvterm = {
  n = {
    ["<C-f>"] = {
      function()
        require("nvterm.terminal").toggle "float"
      end,
      "Toggle float term",
    },
  },
  t = {
    ["<C-f>"] = {
      function()
        require("nvterm.terminal").toggle "float"
      end,
      "Toggle float term",
    },
  },
}

M.lsp = {
  n = {
    ["gd"] = {
      function()
        require("telescope.builtin").lsp_definitions()
      end,
      "Go to definition",
    },

    ["gr"] = {
      function()
        require("telescope.builtin").lsp_references()
      end,
      "LSP references",
    },
    ["K"] = {
      vim.lsp.buf.hover,
      "LSP hover",
    },
    ["<C-k>"] = {
      vim.lsp.buf.signature_help,
      "LSP signature help",
    },
  },
}

return M
