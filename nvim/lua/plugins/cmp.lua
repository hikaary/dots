return {
  {
    "hrsh7th/nvim-cmp",
    opts = require "configs.cmp",
  },
  {
    "L3MON4D3/LuaSnip",
    config = function()
      require("luasnip.loaders.from_vscode").lazy_load()
    end,
    dependencies = {
      "rafamadriz/friendly-snippets",
      "fivethree-team/vscode-svelte-snippets",
    },
    event = "InsertEnter",
    after = "nvim-cmp",
  },
  {
    "nvim-cmp",
    dependencies = { "hrsh7th/cmp-emoji" },
    opts = function(_, opts)
      table.insert(opts.sources, { name = "emoji" })
    end,
  },
}
