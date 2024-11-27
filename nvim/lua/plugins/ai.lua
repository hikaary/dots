return {
  {
    "frankroeder/parrot.nvim",
    lazy = true,
    event = "VeryLazy",
    dependencies = {
      "ibhagwan/fzf-lua",
      "nvim-lua/plenary.nvim",
    },
    config = function()
      require("parrot").setup {
        providers = {
          anthropic = {
            api_key = os.getenv "ANTHROPIC_API_KEY",
            topic = {
              model = "claude-3-5-sonnet-20241022",
            },
          },
        },
        online_model_selection = false,
      }
    end,
  },
  {
    "supermaven-inc/supermaven-nvim",
    event = "VeryLazy",
    config = function()
      require("supermaven-nvim").setup {}
    end,
  },
}
