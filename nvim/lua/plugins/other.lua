return {
  {
    "michaelrommel/nvim-silicon",
    cmd = "Silicon",
    init = function()
      local wk = require "which-key"
      wk.register({
        ["<leader>sc"] = { ":Silicon<CR>", "Snapshot Code" },
      }, { mode = "v" })
    end,
    config = function()
      require("silicon").setup {
        font = "JetBrainsMono Nerd Font=34; Noto Color Emoji=34",
        theme = "Dracula",
        background = "#94e2d5",
        window_title = function()
          return vim.fn.fnamemodify(vim.api.nvim_buf_get_name(vim.api.nvim_get_current_buf()), ":t")
        end,
      }
    end,
  },
  {
    "kevinhwang91/nvim-ufo",
    event = "BufEnter",
    dependencies = {
      "kevinhwang91/promise-async",
      {
        "luukvbaal/statuscol.nvim",
        config = function()
          local builtin = require "statuscol.builtin"
          require("statuscol").setup {
            relculright = true,
            segments = {
              { text = { "%s" }, click = "v:lua.ScSa" },
              { text = { builtin.lnumfunc, " " }, click = "v:lua.ScLa" },
            },
          }
        end,
      },
    },
    opts = {},
    config = function()
      require("ufo").setup {
        provider_selector = function()
          return { "treesitter", "indent" }
        end,
        close_fold_kinds_for_ft = {
          default = { "imports", "comment" },
        },
      }

      vim.o.fillchars = [[eob: ,fold: ,foldopen:,foldsep: ,foldclose:]]
      vim.o.foldcolumn = "1" -- '0' is not bad
      vim.o.foldlevel = 99 -- Using ufo provider need a large value, feel free to decrease the value
      vim.o.foldlevelstart = 99
      vim.o.foldenable = true
    end,
  },
  {
    "echasnovski/mini.surround",
    opts = {
      mappings = {
        add = "gza",
        delete = "gzd",
        find = "gzf",
        find_left = "gzF",
        highlight = "gzh",
        replace = "gzr",
        update_n_lines = "gzn",
      },
    },
    lazy = false,
  },
  {
    "kdheepak/lazygit.nvim",
    cmd = "LazyGit",
    dependencies = {
      "nvim-lua/plenary.nvim",
    },

    keys = { { "<leader>lg", "<cmd> LazyGit <CR>", silent = true, noremap = true, desc = "Open LazyGit" } },
  },
  { "elkowar/yuck.vim" },
  {
    "max397574/better-escape.nvim",
    event = "InsertEnter",
    config = function()
      require("better_escape").setup()
    end,
  },
  {
    "m4xshen/hardtime.nvim",
    dependencies = { "MunifTanjim/nui.nvim", "nvim-lua/plenary.nvim" },
    opts = {
      disabled_filetypes = { "qf", "netrw", "NvimTree", "lazy", "mason", "oil", "harpoon", "spectre" },
      max_count = 1000,
    },
    event = "BufEnter",
  },
}
