local M = {}

local highlights = require "custom.highlights"

M.ui = {
  theme = "github_dark",

  hl_override = highlights.override,

  hl_add = highlights.add,

  extended_integrations = {
    "bufferline",
    "trouble",
    "alpha",
    "dap",
  },
  cmp = {
    icons = true,
    lspkind_text = true,
    style = "default",
    border_color = "grey_fg",
    selected_item_bg = "colored",
  },

  telescope = { style = "borderless" },
  tabufline = {
    show_numbers = false,
    enabled = true,
    lazyload = true,
    overriden_modules = function(modules)
      table.remove(modules, 4)
    end,
  },

  statusline = {
    theme = "minimal",
    separator_style = "round",
    overriden_modules = nil,
  },
  nvdash = {
    load_on_startup = true,
  },
}

M.plugins = "custom.plugins"

M.mappings = require "custom.mappings"

for i = 1, 9, 1 do
  vim.keymap.set("n", string.format("<A-%s>", i), function()
    vim.api.nvim_set_current_buf(vim.t.bufs[i])
  end)
end

return M
