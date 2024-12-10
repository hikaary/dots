-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system {
    'git',
    'clone',
    '--filter=blob:none',
    'https://github.com/folke/lazy.nvim.git',
    '--branch=stable',
    lazypath,
  }
end
vim.opt.rtp:prepend(lazypath)

-- Configure lazy.nvim
require('lazy').setup {
  spec = {
    -- Import core plugins first
    { import = 'plugins.core' },
    -- Then import all other plugin configurations
    { import = 'plugins.ui' },
    { import = 'plugins.editor' },
    { import = 'plugins.lsp' },
    { import = 'plugins.tools' },
    { import = 'plugins.ai' },
  },
  defaults = {
    lazy = true,
    version = false,
  },
  checker = {
    enabled = true,
    notify = false,
  },
  change_detection = {
    notify = false,
  },
  performance = {
    rtp = {
      disabled_plugins = {
        'gzip',
        'tarPlugin',
        'tohtml',
        'tutor',
        'zipPlugin',
      },
    },
  },
}
