return {
  'nvim-neo-tree/neo-tree.nvim',
  branch = 'v3.x',
  dependencies = {
    'nvim-lua/plenary.nvim',
    'nvim-tree/nvim-web-devicons',
    'MunifTanjim/nui.nvim',
    '3rd/image.nvim',
  },
  cmd = 'Neotree',
  config = function()
    local icons = {
      modified = '●',
      git = {
        unstaged = '✗',
        staged = '✓',
        unmerged = '',
        renamed = '➜',
        untracked = '★',
        deleted = '',
        ignored = '◌',
      },
    }

    require('neo-tree').setup {
      close_if_last_window = true,
      popup_border_style = 'rounded',
      enable_git_status = true,
      enable_diagnostics = true,
      open_files_do_not_replace_types = { 'terminal', 'trouble', 'qf' },
      sort_case_insensitive = true,
      default_component_configs = {
        container = {
          enable_character_fade = true,
        },
        indent = {
          indent_size = 2,
          padding = 1,
          with_markers = true,
          indent_marker = '│',
          last_indent_marker = '└',
          highlight = 'NeoTreeIndentMarker',
          with_expanders = true,
          expander_collapsed = '',
          expander_expanded = '',
          expander_highlight = 'NeoTreeExpander',
        },
        icon = {
          default = '*',
          highlight = 'NeoTreeFileIcon',
        },
        modified = {
          symbol = icons.modified,
          highlight = 'NeoTreeModified',
        },
        name = {
          trailing_slash = false,
          use_git_status_colors = true,
          highlight = 'NeoTreeFileName',
        },
        git_status = {
          symbols = icons.git,
        },
      },
      commands = {
        system_open = function(state)
          vim.api.nvim_command(string.format("silent !xdg-open '%s'", state.tree:get_node():get_id()))
        end,
      },
      window = {
        position = 'float',
        width = 35,
        mapping_options = {
          noremap = true,
          nowait = true,
        },
        mappings = {
          ['<space>'] = {
            'toggle_node',
            nowait = false,
          },
          ['<2-LeftMouse>'] = 'open',
          ['<cr>'] = 'open',
          ['<esc>'] = 'cancel',
          ['P'] = { 'toggle_preview', config = { use_float = true } },
          ['l'] = 'focus_preview',
          ['S'] = 'open_split',
          ['s'] = 'open_vsplit',
          ['t'] = 'open_tabnew',
          ['w'] = 'open_with_window_picker',
          ['C'] = 'close_node',
          ['z'] = 'close_all_nodes',
          ['a'] = {
            'add',
            config = {
              show_path = 'none',
            },
          },
          ['A'] = 'add_directory',
          ['d'] = 'delete',
          ['r'] = 'rename',
          ['y'] = 'copy_to_clipboard',
          ['x'] = 'cut_to_clipboard',
          ['p'] = 'paste_from_clipboard',
          ['c'] = 'copy',
          ['m'] = 'move',
          ['q'] = 'close_window',
          ['R'] = 'refresh',
          ['?'] = 'show_help',
          ['<'] = 'prev_source',
          ['>'] = 'next_source',
        },
        float = {
          enable = true,
          quit_on_focus_loss = true,
          open_win_config = function()
            local screen_w = vim.opt.columns:get()
            local screen_h = vim.opt.lines:get()
            local window_w = screen_w * 0.5
            local window_h = screen_h * 0.8
            local window_w_int = math.floor(window_w)
            local window_h_int = math.floor(window_h)
            local center_x = (screen_w - window_w) / 2
            local center_y = ((vim.opt.lines:get() - window_h) / 2) - vim.opt.cmdheight:get()
            return {
              border = 'rounded',
              relative = 'editor',
              row = center_y,
              col = center_x,
              width = window_w_int,
              height = window_h_int,
            }
          end,
        },
      },
      filesystem = {
        filtered_items = {
          visible = false,
          hide_dotfiles = false,
          hide_gitignored = false,
          hide_by_name = {
            '__pycache__',
            '.git',
            '.pytest_cache',
            '.mypy_cache',
            '.ruff_cache',
            '.coverage',
            '.DS_Store',
            'node_modules',
          },
          never_show = {
            '__pycache__',
            '.git',
            '.pytest_cache',
            '.mypy_cache',
            '.ruff_cache',
          },
        },
        follow_current_file = {
          enabled = true,
          leave_dirs_open = true,
        },
        group_empty_dirs = true,
        hijack_netrw_behavior = 'open_default',
      },
      buffers = {
        follow_current_file = {
          enabled = true,
          leave_dirs_open = true,
        },
        group_empty_dirs = true,
        show_unloaded = true,
      },
      git_status = {
        window = {
          position = 'float',
        },
      },
      event_handlers = {
        {
          event = 'file_opened',
          handler = function()
            require('neo-tree.command').execute { action = 'close' }
          end,
        },
      },
    }
  end,
}
