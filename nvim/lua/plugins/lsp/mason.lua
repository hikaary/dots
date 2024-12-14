return {
  'williamboman/mason.nvim',
  dependencies = {
    'williamboman/mason-lspconfig.nvim',
  },
  cmd = 'Mason',
  event = 'VeryLazy',
  keys = { { '<leader>cm', '<cmd>Mason<cr>', desc = 'Mason' } },
  opts = {
    ui = {
      border = 'rounded',
      icons = {
        package_installed = '✓',
        package_pending = '➜',
        package_uninstalled = '✗',
      },
    },
    ensure_installed = {
      'stylua',
      'shfmt',
      'ruff',
      'lua-language-server',
      'stylua',
      'html-lsp',
      'css-lsp',
      'prettier',
      'basedpyright',
      'bash-language-server',
      'yaml-language-server',
      'dockerfile-language-server',
      'taplo',
      'json-lsp',
      'shellcheck',
      'yamllint',
      'hadolint',
    },
  },
  config = function(_, opts)
    require('mason').setup(opts)
    local mr = require 'mason-registry'
    for _, tool in ipairs(opts.ensure_installed) do
      local p = mr.get_package(tool)
      if not p:is_installed() then
        p:install()
      end
    end
  end,
}
