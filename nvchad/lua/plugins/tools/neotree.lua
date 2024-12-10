return {
  "nvim-neo-tree/neo-tree.nvim",
  branch = "v3.x",
  event = "VeryLazy",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
    "MunifTanjim/nui.nvim",
  },
  config = function()
    require("neo-tree").setup {
      sources = { "filesystem", "buffers", "git_status" },
      event_handlers = {
        {
          event = "file_open_requested",
          handler = function()
            require("neo-tree.command").execute { action = "close" }
          end,
        },
      },
      open_files_do_not_replace_types = { "terminal", "Trouble", "qf", "Outline" },
      default_component_configs = {
        indent = {
          with_expanders = true, -- if nil and file nesting is enabled, will enable expanders
          expander_collapsed = "",
          expander_expanded = "",
          expander_highlight = "NeoTreeExpander",
        },
      },
      filesystem = {
        filtered_items = {
          visible = false, -- set to true to show hidden files, without the need for pressing \
          hide_dotfiles = true,
          hide_gitignored = true,
          hide_by_name = {
            "node_modules",
          },
          hide_by_pattern = { -- uses glob style patterns
            "*.meta",
            "*/__pycache__/*",
          },
          never_show = { -- remains hidden even if visible is toggled to true
            ".DS_Store",
            "thumbs.db",
          },
          always_show = { -- remains visible even if filtered out by some other rule
            ".gitignored",
          },
        },
      },
    }
  end,
}
