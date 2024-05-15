local cmp = require "cmp"
local types = require "cmp.types"

return {
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
