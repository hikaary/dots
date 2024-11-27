return {
  "hrsh7th/nvim-cmp",
  opts = function()
    local config = require "nvchad.configs.cmp"
    local cmp = require "cmp"
    config.mapping = {
      ["<Tab>"] = cmp.config.disable,
      ["<S-Tab>"] = cmp.config.disable,

      ["<C-j>"] = cmp.mapping.select_next_item(),
      ["<C-k>"] = cmp.mapping.select_prev_item(),

      ["<C-d>"] = cmp.mapping.scroll_docs(-4),
      ["<C-f>"] = cmp.mapping.scroll_docs(4),
      ["<C-Space>"] = cmp.mapping.complete(),
      ["<C-e>"] = cmp.mapping.close(),
      ["<CR>"] = cmp.mapping.confirm {
        behavior = cmp.ConfirmBehavior.Replace,
        select = true,
      },
    }

    return config
  end,
}
