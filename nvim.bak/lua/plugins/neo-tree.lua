return {
  "nvim-neo-tree/neo-tree.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-tree/nvim-web-devicons",
    "MunifTanjim/nui.nvim",
  },
  config = function()
    local HEIGHT_RATIO = 0.8
    local WIDTH_RATIO = 0.1

    require("neo-tree").setup({
      close_if_last_window = true,
      enable_git_status = true,
      popup_border_style = "rounded",
      enable_diagnostics = true,
      sort_case_insensitive = true,
      default_component_configs = {
        indent = {
          indent_size = 2,
          padding = 1,
          with_markers = true,
          indent_marker = "│",
          last_indent_marker = "└",
          highlight = "NeoTreeIndentMarker",
        },
        icon = {
          folder_closed = "",
          folder_open = "",
          folder_empty = "ﰊ",
          default = "*",
        },
        modified = {
          symbol = "[+]",
        },
        name = {
          trailing_slash = false,
          use_git_status_colors = true,
        },
      },
      window = {
        position = "float",
        width = function()
          return math.floor(vim.opt.columns:get() * WIDTH_RATIO)
        end,
        height = function()
          return math.floor(vim.opt.lines:get() * HEIGHT_RATIO)
        end,
        mapping_options = {
          noremap = true,
          nowait = true,
        },
        mappings = {
          ["<space>"] = "toggle_node",
          ["<2-LeftMouse>"] = "open",
          ["<cr>"] = "open",
          ["S"] = "open_split",
          ["s"] = "open_vsplit",
          ["t"] = "open_tabnew",
          ["C"] = "close_node",
          ["a"] = "add",
          ["A"] = "add_directory",
          ["d"] = "delete",
          ["r"] = "rename",
          ["y"] = "copy_to_clipboard",
          ["x"] = "cut_to_clipboard",
          ["p"] = "paste_from_clipboard",
          ["q"] = "close_window",
          ["R"] = "refresh",
        },
      },
      filesystem = {
        follow_current_file = {
          enabled = true,
          leave_dirs_open = false,
        },
        filtered_items = {
          visible = false,
          hide_dotfiles = false,
          hide_gitignored = false,
          hide_hidden = true,
          hide_by_name = {
            ".DS_Store",
            "thumbs.db",
            "node_modules",
            ".mypy*",
            "__pycache__",
            ".git",
            ".null-ls",
          },
        },
        hijack_netrw_behavior = "open_default",
        use_libuv_file_watcher = true,
      },
    })
  end,
}
