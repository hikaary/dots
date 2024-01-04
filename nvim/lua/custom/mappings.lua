local M = {}

M.disabled = {
  n = {
    ["<leader>wa"] = "",
    ["<leader>wr"] = "",
    ["<leader>wl"] = "",
    ["<leader>wk"] = "",
    ["<leader>wK"] = "",
    ["<leader>ca"] = "",
    ["<leader>cj"] = "",
    ["<leader>ch"] = "",
    ["<leader>cm"] = "",
    ["<leader>cc"] = "",
    ["<leader>b"] = "",
    ["<leader>f"] = "",
    ["<leader>ma"] = "",
    ["<leader>ra"] = "",
    ["<leader>rn"] = "",
    ["<leader>n"] = "",
    ["<leader>th"] = "",
    ["<leader>h"] = "",
    ["<leader>v"] = "",
    ["<A-i>"] = "",
    ["<leader>fm"] = "",
    ["<leader>pt"] = "",
  },
  t = {
    ["<A-i>"] = "",
  },
}

M.general = {
  n = {
    [";"] = { ":", "enter command mode", opts = { nowait = true } },
    ["<leader>q"] = {
      ":q<CR>",
      "Quit",
      opts = { nowait = true },
    },
    ["<leader><space>"] = {
      "<cmd>Telescope buffers<CR>",
      "Find buffers",
      opts = { nowait = true },
    },
    ["<C-a>"] = {
      "gg<S-v>G",
      "Select all text",
      opts = { nowait = true },
    },

    ["<A-j>"] = {
      ":m .+1<CR>==",
      "Move line down",
      opts = { nowait = true, silent = true },
    },
    ["<A-k>"] = {
      ":m .-2<CR>==",
      "Move line up",
      opts = { nowait = true, silent = true },
    },
    ["|"] = {
      ":vsplit<CR>",
      "Split vertical",
      opts = { nowait = true },
    },
    ["\\"] = {
      ":split<CR>",
      "Split horizontal",
      opts = { nowait = true },
    },
    ["f"] = {
      function()
        require("hop").hint_char1 {
          direction = require("hop.hint").HintDirection.AFTER_CURSOR,
          current_line_only = false,
        }
      end,
      "Hop after cursor",
    },
    ["F"] = {
      function()
        require("hop").hint_char1 {
          direction = require("hop.hint").HintDirection.BEFORE_CURSOR,
          current_line_only = false,
        }
      end,
      "Hop before cursor",
    },

    ["<leader>lg"] = { "<cmd> LazyGit <CR>", "Open LazyGit", opts = { silent = true } },
    ["<S-.>"] = { "<gv", "Move Indent Left" },
    ["<S-,>"] = { ">gv", "Move Indent Right" },
  },

  v = {
    ["<A-j>"] = { ":m '>+1<CR>gv=gv", "Move up with Alt-j", opts = { silent = true } },
    ["<A-k>"] = { ":m '<-2<CR>gv=gv", "Move up with Alt-k", opts = { silent = true } },
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
    ["<leader>la"] = {
      function()
        vim.lsp.buf.code_action()
      end,
      "Code action",
    },
    ["<leader>lj"] = {
      function()
        local ok, start = require("indent_blankline.utils").get_current_context(
          vim.g.indent_blankline_context_patterns,
          vim.g.indent_blankline_use_treesitter_scope
        )

        if ok then
          vim.api.nvim_win_set_cursor(vim.api.nvim_get_current_win(), { start, 0 })
          vim.cmd [[normal! _]]
        end
      end,
      "Jump to current context",
    },
    ["<leader>lr"] = {
      function()
        require("nvchad.renamer").open()
      end,
      "LSP rename",
    },
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
