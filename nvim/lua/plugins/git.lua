return {
  {
    "NeogitOrg/neogit",
    lazy = false,
    dependencies = {
      "nvim-lua/plenary.nvim", -- required
      "sindrets/diffview.nvim", -- optional - Diff integration

      -- Only one of these is needed.
      "nvim-telescope/telescope.nvim", -- optional
      "ibhagwan/fzf-lua", -- optional
      "echasnovski/mini.pick", -- optional
    },
    config = function()
      local neogit = require "neogit"
      neogit.setup {}
    end,
  },
  {
    "harrisoncramer/gitlab.nvim",
    dependencies = {
      "MunifTanjim/nui.nvim",
      "nvim-lua/plenary.nvim",
      "sindrets/diffview.nvim",
      "stevearc/dressing.nvim",
      "nvim-tree/nvim-web-devicons",
      enabled = true,
    },
    enabled = true,
    build = function()
      require("gitlab.server").build(true)
    end,
    config = function()
      require("gitlab").setup {
        reviewer = "diffview",
        keymaps = {
          popup = { -- The popup for comment creation, editing, and replying
            exit = "<Esc>",
            perform_action = "<leader>s", -- Once in normal mode, does action
          },
          discussion_tree = { -- The discussion tree that holds all comments
            jump_to_location = "o",
            edit_comment = "e",
            delete_comment = "dd",
            reply_to_comment = "r",
            toggle_node = "t",
          },
          dialogue = { -- The confirmation dialogue for deleting comments
            focus_next = { "j", "<Down>", "<Tab>" },
            focus_prev = { "k", "<Up>", "<S-Tab>" },
            close = { "<Esc>", "<C-c>" },
            submit = { "<CR>", "<Space>" },
          },
        },
      }
    end,
  },
}
