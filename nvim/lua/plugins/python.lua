return {
  "linux-cultist/venv-selector.nvim",
  dependencies = {
    "neovim/nvim-lspconfig",
    "mfussenegger/nvim-dap", "mfussenegger/nvim-dap-python",
    { "nvim-telescope/telescope.nvim", branch = "0.1.x", dependencies = { "nvim-lua/plenary.nvim" } },
  },
  lazy = false,
  branch = "regexp",
  config = function()
    local function on_venv_activate()
      local python = require("venv-selector").python()

      vim.g.ale_python_mypy_options = string.format(
        "--python-executable %s "
        .. "--follow-imports=silent "
        .. "--ignore-missing-imports "
        .. "--no-strict-optional "
        .. "--show-column-numbers "
        .. "--no-implicit-reexport "
        .. "--no-implicit-optional "
        .. "--namespace-packages",
        python
      )
    end


    require("venv-selector").setup {
      settings = {
        options = {
          on_venv_activate_callback = on_venv_activate,
        },
      },
    }
  end,
  keys = {
    { ",v", "<cmd>VenvSelect<cr>" },
  },
}
