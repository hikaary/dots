local M = {}

---@type ChadrcConfig
M.ui = {
  cmp = {
    icons = true,
    lspkind_text = true,
    style = "atom_colored", -- default/flat_light/flat_dark/atom/atom_colored
    format_colors = {
      tailwind = false,
    },
  },

  telescope = { style = "bordered" }, -- borderless / bordered

  ------------------------------- nvchad_ui modules -----------------------------
  tabufline = {
    enabled = false,
  },
  statusline = {
    -- enabled = false,
  },

  cheatsheet = { theme = "simple" }, -- simple/grid

  lsp = {
    signature = true,
    semantic_tokens = true,
  },
  icons = {
    LSP = {
      diagnostics = {
        Error = " ",
        Warn = " ",
        Hint = "󰌵 ",
        Info = " ",
      },
      kind = {
        Text = "󰉿",
        Method = "󰆧",
        Function = "󰊕",
        Constructor = "",
        Field = "󰜢",
        Variable = "󰀫",
        Class = "󰠱",
        Interface = "",
        Module = "",
        Property = "󰜢",
        Unit = "󰑭",
        Value = "󰎠",
        Enum = "",
        Keyword = "󰌋",
        Snippet = "",
        Color = "󰏘",
        File = "󰈙",
        Reference = "󰈇",
        Folder = "󰉋",
        EnumMember = "",
        Constant = "󰏿",
        Struct = "󰙅",
        Event = "",
        Operator = "󰆕",
        TypeParameter = "",
        Codeium = "",
        TabNine = "",
      },
    },
    buffers = {
      readonly = "󰌾 ",
      modified = "● ",
      unsaved_others = "○ ",
    },
    Git = {
      added = " ",
      remove = " ",
      changed = "󰣕 ",
    },
    Gitsigns = {
      add = "▎",
      change = "▎",
      delete = "",
    },
  },
}

M.base46 = {
  transparency = true,
  theme = "catppuccin",
  integrations = {
    "blankline",
    "cmp",
    "defaults",
    "devicons",
    "git",
    "lsp",
    "mason",
    "nvcheatsheet",
    "nvimtree",
    "statusline",
    "syntax",
    "treesitter",
    "tbline",
    "telescope",
    "whichkey",
  },
}

vim.api.nvim_create_augroup("TimewarriorTracking", { clear = true })

vim.api.nvim_create_autocmd("VimEnter", {
  group = "TimewarriorTracking",
  callback = function()
    local cwd = vim.fn.getcwd()
    local project = vim.fn.fnamemodify(cwd, ":t")
    if string.find(cwd, "/dev/") or string.find(cwd, "/projects/") then
      vim.fn.system "timew stop"
      vim.fn.system('timew start "' .. project .. '" @coding')
    end
  end,
})

vim.api.nvim_create_autocmd("VimLeave", {
  group = "TimewarriorTracking",
  callback = function()
    vim.fn.system "timew stop"
  end,
})

-- Добавляем команды
vim.api.nvim_create_user_command("TimeStart", function()
  local cwd = vim.fn.getcwd()
  local project = vim.fn.fnamemodify(cwd, ":t")
  vim.fn.system('timew start "' .. project .. '" @coding')
end, {})

vim.api.nvim_create_user_command("TimeStop", function()
  vim.fn.system "timew stop"
end, {})

vim.api.nvim_create_user_command("TimeStatus", function()
  local output = vim.fn.system "timew"
  vim.api.nvim_echo({ { output, "Normal" } }, true, {})
end, {})

return M
