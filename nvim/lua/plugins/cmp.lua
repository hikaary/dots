return {
  {
    "hrsh7th/nvim-cmp",
    opts = function(_, opts)
      require "configs.cmp"
    end,
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
}
