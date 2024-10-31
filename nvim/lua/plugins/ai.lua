return {
  {
    "frankroeder/parrot.nvim",
    lazy = false,
    dependencies = { "ibhagwan/fzf-lua", "nvim-lua/plenary.nvim" },
    config = function()
      require("parrot").setup {
        providers = {
          anthropic = {
            api_key = os.getenv "CLAUDE_API_KEY",
            topic = {
              model = "claude-3-5-sonnet-20241022",
            },
          },
          openai = {
            api_key = os.getenv "OPENAI_API_KEY",
          },
        },
        online_model_selection = false,
      }
    end,
  },
  -- {
  --   "Exafunction/codeium.nvim",
  --   lazy = false,
  --   dependencies = {
  --     "nvim-lua/plenary.nvim",
  --     "hrsh7th/nvim-cmp",
  --   },
  --   config = function()
  --     require("codeium").setup {
  --       detect_proxy = false,
  --       workspace_root = {
  --         use_lsp = true,
  --         paths = {
  --           ".git",
  --           ".hg",
  --           ".svn",
  --           "package.json",
  --         },
  --       },
  --     }
  --   end,
  -- },
}
