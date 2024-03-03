local M = {}

local cmp = require "cmp"
local types = require "cmp.types"

M.cmp = {
  window = {
    documentation = {
      border = "rounded",
      winhighlight = "NormalFloat:TelescopeNormal,FloatBorder:TelescopeBorder",
    },
  },
  completion = {
    completeopt = "menu,menuone,noselect",
  },
  mapping = {
    ["<CR>"] = cmp.mapping.confirm {
      behavior = cmp.ConfirmBehavior.Replace,
      select = false,
    },
  },
  sources = {
    {
      name = "nvim_lsp",
      entry_filter = function(entry, _)
        local kind = types.lsp.CompletionItemKind[entry:get_kind()]

        if kind == "Text" then
          return false
        end
        return true
      end,
    },
    { name = "luasnip" },
    { name = "path" },
    { name = "nvim_lua" },
  },
}

M.treesitter = {
  ensure_installed = {
    "vim",
    "lua",
    "html",
    "css",
    "tsx",
    "c",
    "markdown",
    "markdown_inline",
    "python",
  },
  indent = {
    enable = true,
  },
}

M.mason = {
  ensure_installed = {
    -- lua stuff
    "lua-language-server",
    "stylua",

    -- web dev stuff
    "css-lsp",
    "html-lsp",

    -- python
    "ruff-lsp",
    "ruff",
    "pyright",
  },
}

local function on_attach_nvimtree(bufnr)
  local api = require "nvim-tree.api"

  local function opts(desc)
    return { desc = "nvim-tree: " .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
  end

  api.config.mappings.default_on_attach(bufnr)

  vim.keymap.set("n", "<C-t>", api.tree.change_root_to_parent, opts "Up")
  vim.keymap.set("n", "-", api.tree.toggle, opts "Toggle")
  vim.keymap.set("n", "?", api.tree.toggle_help, opts "Help")
  vim.keymap.set("n", "s", api.node.open.vertical, opts "Split vertical")
end

local HEIGHT_RATIO = 0.8
local WIDTH_RATIO = 0.5

M.nvimtree = {
  on_attach = on_attach_nvimtree,

  actions = {
    open_file = {
      quit_on_open = true,
    },
  },
  filters = {
    dotfiles = false,
    git_clean = false,
    no_buffer = false,
    custom = { ".mypy*", "__pycache__", ".git", ".null-ls" },
  },
  git = {
    enable = true,
  },

  renderer = {
    highlight_git = true,
    icons = {
      show = {
        git = true,
      },
      glyphs = {
        git = {
          unstaged = "",
          staged = "✓",
          unmerged = "",
          renamed = "➜",
          untracked = "U",
          deleted = "",
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

M.telescope = {
  opts = {
    default = {
      file_ignore_pattern = { ".git", "venv" },
      initial_mode = "normal",
    },
    extension_list = { "notify", "flutter", "treesitter", "ui-select" },
    extensions = {
      notify = {},
      ["ui-select"] = {
        require("telescope.themes").get_dropdown {},
      },
    },
  },
  pickers = {
    buffers = {
      mappings = {
        i = {
          ["<C-c>"] = function(prompt_bufnr)
            local action_state = require "telescope.actions.state"
            local current_picker = action_state.get_current_picker(prompt_bufnr)
            current_picker:delete_selection(function(selection)
              local bufnr = selection.bufnr
              local winids = vim.fn.win_findbuf(bufnr)
              for _, winid in ipairs(winids) do
                local new_buf = vim.api.nvim_create_buf(false, true)
                vim.api.nvim_win_set_buf(winid, new_buf)
              end
              vim.api.nvim_buf_delete(bufnr, { force = true })
            end)
          end,
        },
      },
    },
  },
}

M.venv_selector = {
  path = "~/.cache/pypoetry/virtualenvs/",
  auto_refresh = true,
  notify_user_on_activate = true,
}

M.lazy_nvim = {
  ui = {
    border = "rounded",
  },
}

return M
