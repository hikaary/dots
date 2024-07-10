return {
  {
    'catppuccin/nvim',
    name = 'catppuccin',
    priority = 1000,
    config = function()
      require('catppuccin').setup {
        flavour = 'mocha',
        transparent_background = true,
        integrations = {
          nvimtree = true,
          mini = {
            enabled = true,
          },
          coc_nvim = true,
          which_key = true,
          cmp = true,
          fidget = true,
          gitsigns = true,
          harpoon = true,
          indent_blankline = {
            enabled = false,
            scope_color = 'sapphire',
            colored_indent_levels = false,
          },
          mason = true,
          noice = true,
          notify = true,
          symbols_outline = true,
          telescope = true,
          treesitter = true,
          treesitter_context = true,
          native_lsp = {
            enabled = true,
            virtual_text = {
              errors = { 'italic' },
              hints = { 'italic' },
              warnings = { 'italic' },
              information = { 'italic' },
              ok = { 'italic' },
            },
            underlines = {
              errors = { 'underline' },
              hints = { 'underline' },
              warnings = { 'underline' },
              information = { 'underline' },
              ok = { 'underline' },
            },
            inlay_hints = {
              background = true,
            },
          },
        },
      }

      vim.cmd.colorscheme 'catppuccin'
    end,
  },
  {
    lazy = false,
    'stevearc/dressing.nvim',
    config = function()
      require('dressing').setup {}
    end,
  },
}
