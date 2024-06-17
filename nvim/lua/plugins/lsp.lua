return {
  {
    "neovim/nvim-lspconfig",
    lazy = false,
    config = function()
      vim.diagnostic.config {
        virtual_text = {
          prefix = "●",
        },
      }
      require("nvchad.configs.lspconfig").defaults()
      require "configs.lsp"
    end,
  },
  {
    "rmagatti/goto-preview",
    event = "LspAttach",
    config = function()
      require("goto-preview").setup {
        default_mappings = true,
      }
    end,
  },
}
