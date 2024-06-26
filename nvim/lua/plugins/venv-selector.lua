return {
  {
    'linux-cultist/venv-selector.nvim',
    branch = 'regexp',
    dependencies = { 'neovim/nvim-lspconfig', 'nvim-telescope/telescope.nvim' },
    opts = {
      poetry_path = '~/.cache/pypoetry/virtualenvs/',
      auto_refresh = true,
      notify_user_on_activate = true,
    },

    config = function()
      require('venv-selector').setup()
      vim.api.nvim_create_autocmd('User', {
        pattern = 'VenvSelectActivated',
        callback = function()
          require 'configs.ale'
        end,
      })
    end,
    event = 'VeryLazy',
  },
}
