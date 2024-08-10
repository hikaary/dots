return {
  "linux-cultist/venv-selector.nvim",
  dependencies = {
    "neovim/nvim-lspconfig",
    "mfussenegger/nvim-dap",
    "mfussenegger/nvim-dap-python",
    { "nvim-telescope/telescope.nvim", branch = "0.1.x", dependencies = { "nvim-lua/plenary.nvim" } },
  },
  lazy = false,
  branch = "regexp",
  config = function()
    local function on_venv_activate()
      -- vim.cmd "LspRestart"
    end

    require("venv-selector").setup {
      settings = {
        options = {
          on_venv_activate_callback = on_venv_activate,
        },
      },
    }
  end,
}
