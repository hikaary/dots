return {
  "onsails/lspkind.nvim",
  enabled = not vim.g.fallback_icons_enabled,
  event = "VeryLazy",
  opts = {
    mode = "symbol",
    symbol_map = {
      Array = "󰅪",
      Boolean = "⊨",
      Class = "󰌗",
      Constructor = "",
      Key = "󰌆",
      Namespace = "󰅪",
      Null = "NULL",
      Number = "#",
      Object = "󰀚",
      Package = "󰏗",
      Property = "",
      Reference = "",
      Snippet = "",
      String = "󰀬",
      TypeParameter = "󰊄",
      Unit = "",
    },
    menu = {},
  },
  config = function(_, opts)
    require("lspkind").init(opts)
  end,
}
