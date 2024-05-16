return {
  -- {
  --   "folke/flash.vim",
  --   opts = {},
  --   keys = {
  --     {
  --       "s",
  --       '<cmd>lua require("flash").jump()<CR>',
  --       desc = "Flash",
  --     },
  --     {
  --       "S",
  --       '<cmd>lua require("flash").treesitter()<CR>',
  --       desc = "Flash tree-sitter",
  --     },
  --     {
  --       "r",
  --       mode = "o",
  --       '<cmd>lua require("flash").remote()<CR>',
  --       desc = "Remote Flash",
  --     },
  --     {
  --       "R",
  --       mode = { "o", "x" },
  --       '<cmd>lua require("flash").treesitter_search()<CR>',
  --       desc = "Treesitter Search",
  --     },
  --     { "f", mode = { "n", "x", "o" } },
  --     { "F", mode = { "n", "x", "o" } },
  --     { "t", mode = { "n", "x", "o" } },
  --     { "T", mode = { "n", "x", "o" } },
  --     "/",
  --     "?",
  --   },
  -- },
  {
    "altermo/ultimate-autopair.nvim",
    event = { "InsertEnter", "CmdlineEnter" },
    branch = "v0.6",
  },
  {
    "echasnovski/mini.visits",
    opts = true,
    keys = {
      {
        "<leader>fp",
        function()
          require("mini.visits").select_path()
        end,
      },
    },
  },
}
