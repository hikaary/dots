return {
  "nvim-tree/nvim-tree.lua",
  event = "VeryLazy",
  requires = { "kyazdani42/nvim-web-devicons", opt = true },
  config = function()
    dofile(vim.g.base46_cache .. "nvimtree")

    local nvtree = require "nvim-tree"
    local api = require "nvim-tree.api"

    local function custom_on_attach(bufnr)
      local function opts(desc)
        return { desc = "nvim-tree: " .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
      end

      api.config.mappings.default_on_attach(bufnr)
      vim.keymap.set("n", "?", api.tree.toggle_help, opts "Help")
      vim.keymap.set("n", "<ESC>", api.tree.close, opts "Close")
      vim.keymap.set("n", "<C-]>", api.tree.change_root_to_node, opts "CD")
    end

    api.events.subscribe(api.events.Event.FileCreated, function(file)
      vim.cmd("edit " .. file.fname)
    end)

    local HEIGHT_RATIO = 0.8
    local WIDTH_RATIO = 0.5

    nvtree.setup {
      on_attach = custom_on_attach,
      update_focused_file = {
        enable = true,
        update_root = false,
      },
      respect_buf_cwd = false,
      sync_root_with_cwd = false,
      update_cwd = true,
      disable_netrw = true,
      hijack_netrw = true,
      filters = {
        dotfiles = false,
        git_clean = false,
        no_buffer = false,
        custom = { ".mypy*", "__pycache__", ".null-ls" },
      },
      git = {
        enable = true,
        ignore = false,
      },
      actions = {
        change_dir = {
          enable = false,
          global = false,
        },
        open_file = {
          quit_on_open = true, -- Закрывать tree при открытии файла
          resize_window = true,
        },
      },
      renderer = {
        highlight_git = true,
        icons = {
          show = {
            git = true,
          },
          glyphs = {
            git = {
              unstaged = "",
              staged = "✓",
              unmerged = "",
              renamed = "➜",
              untracked = "U",
              deleted = "",
              ignored = "◌",
            },
          },
        },
      },
      view = {
        float = {
          enable = true,
          open_win_config = function()
            local screen_w = vim.opt.columns:get()
            local screen_h = vim.opt.lines:get() - vim.opt.cmdheight:get()
            local window_w = screen_w * WIDTH_RATIO
            local window_h = screen_h * HEIGHT_RATIO
            local window_w_int = math.floor(window_w)
            local window_h_int = math.floor(window_h)
            local center_x = (screen_w - window_w) / 2
            local center_y = ((vim.opt.lines:get() - window_h) / 2) - vim.opt.cmdheight:get()
            return {
              border = "rounded",
              relative = "editor",
              row = center_y,
              col = center_x,
              width = window_w_int,
              height = window_h_int,
            }
          end,
        },
        width = function()
          return math.floor(vim.opt.columns:get() * WIDTH_RATIO)
        end,
      },
    }
  end,
}
