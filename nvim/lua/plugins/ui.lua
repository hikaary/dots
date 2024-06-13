local show_dotfiles = true
local filter_hide = function(fs_entry)
  return not (vim.startswith(fs_entry.name, ".") or vim.startswith(fs_entry.name, "__pycache__"))
end

return {
  {
    "echasnovski/mini.files",
    keys = {
      { "<leader>e", "<cmd>lua require('mini.files').open()<CR>", desc = "mini.files: Open" },
    },
    init = function()
      if vim.fn.argc() == 1 then
        local stat = vim.loop.fs_stat(vim.fn.argv(0))
        if stat and stat.type == "directory" then
          require "mini.files"
        end
      end
    end,
    default_filter = not show_dotfiles and filter_hide,
    content = { default_filter = not show_dotfiles and filter_hide },
    opts = {
      windows = {
        max_number = math.huge,
        preview = true,
        width_focus = 40,
        width_nofocus = 10,
        width_preview = 45,
      },
      content = { filter = true and filter_hide },
      mappings = {
        close = "q",
        go_in = "<cr>",
        go_in_plus = "L",
        go_out = "h",
        go_out_plus = "H",
        reset = "R",
        reveal_cwd = "@",
        show_help = "g?",
        synchronize = "<C-s>",
        trim_left = "<",
        trim_right = ">",
      },
    },
    config = function(_, opts)
      require("mini.files").setup(opts)
      local toggle_dotfiles = function()
        show_dotfiles = not show_dotfiles
        local new_filter = show_dotfiles and filter_hide
        require("mini.files").refresh { content = { filter = new_filter } }
      end
      vim.api.nvim_create_autocmd("User", {
        pattern = "MiniFilesBufferCreate",
        callback = function(args)
          local buf_id = args.data.buf_id
          vim.keymap.set("n", "g.", toggle_dotfiles, { buffer = buf_id, desc = "Toggle hidden files" })
        end,
      })
      vim.api.nvim_create_autocmd("User", {
        pattern = "MiniFilesWindowOpen",
        callback = function(args)
          local win_id = args.data.win_id
          vim.wo[win_id].winblend = 20
          vim.api.nvim_win_set_config(win_id, { border = "rounded" })
        end,
      })
    end,
  },
  {
    "nvim-tree/nvim-web-devicons",
    opts = function()
      return { override = require "nvchad.icons.devicons" }
    end,
    config = function(_, opts)
      dofile(vim.g.base46_cache .. "devicons")
      require("nvim-web-devicons").setup(opts)
    end,
  },
  {
    "rcarriga/nvim-notify",
    opts = function()
      return require "configs.notify"
    end,
    config = function()
      vim.notify = require "notify"
    end,
    init = function()
      vim.notify = function(...)
        if not require("lazy.core.config").plugins["nvim-notify"]._.loaded then
          require("lazy").load { plugins = "nvim-notify" }
        end
        require "notify"(...)
      end
    end,
  },
  {
    "stevearc/dressing.nvim",
    init = function()
      ---@diagnostic disable-next-line: duplicate-set-field
      vim.ui.select = function(...)
        require("lazy").load { plugins = { "dressing.nvim" } }
        return vim.ui.select(...)
      end
      ---@diagnostic disable-next-line: duplicate-set-field
      vim.ui.input = function(...)
        require("lazy").load { plugins = { "dressing.nvim" } }
        return vim.ui.input(...)
      end
    end,
  },
  {
    "tzachar/highlight-undo.nvim",
    opts = {},
    event = "BufReadPre",
  },
  {
    "j-hui/fidget.nvim",
    config = function()
      require("fidget").setup()
    end,
    event = "BufEnter",
  },
  {
    "folke/twilight.nvim",
    opts = {},
  },
  {
    "folke/zen-mode.nvim",
    opts = {},
  },
  {
    "echasnovski/mini.comment",
    event = "VeryLazy",
    dependencies = { "JoosepAlviste/nvim-ts-context-commentstring" },
    opts = {
      options = {
        custom_commentstring = function()
          return require("ts_context_commentstring.internal").calculate_commentstring() or vim.bo.commentstring
        end,
      },
    },
  },
  {
    "folke/todo-comments.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    lazy = false,
  },
}
