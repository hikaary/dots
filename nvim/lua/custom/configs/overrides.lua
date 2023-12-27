local M = {}

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

M.nvimtree = {
  actions = {
    open_file = {
      quit_on_open = true,
    },
  },
  filters = {
    dotfiles = false,
    git_clean = false,
    no_buffer = false,
    custom = { ".mypy*", "__pycache__", ".git", ".null-ls", ".vscode" },
  },
  git = {
    enable = true,
  },
  view = {
    width = 28,
    float = {
      -- enable = true,
      quit_on_focus_loss = true,
      open_win_config = {
        relative = "editor",
        border = "rounded",
        width = 50,
        height = 40,
        row = 6,
        col = 95,
      },
    },
  },
  renderer = {
    highlight_git = true,
    icons = {
      webdev_colors = true,
      show = {
        git = true,
        folder = true,
        file = true,
        folder_arrow = true,
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
}

M.nvterm = {
  terminals = {
    shell = vim.o.shell,
    list = {},
    type_opts = {
      float = {
        relative = "editor",
        row = 0.16,
        col = 0.09,
        width = 0.75,
        height = 0.7,
        border = "single",
      },
      horizontal = { location = "rightbelow", split_ratio = 0.3 },
      vertical = { location = "rightbelow", split_ratio = 0.5 },
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
