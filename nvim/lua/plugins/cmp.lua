return {
  {
    "hrsh7th/nvim-cmp",
    opts = require "configs.cmp",
    dependencies = {
      {
        "L3MON4D3/LuaSnip",
        after = "nvim-cmp",
        dependencies = { "rafamadriz/friendly-snippets" },
        config = function(_, opts)
          require("luasnip.loaders.from_vscode").load {}
        end,
      },
    },
  },
}
