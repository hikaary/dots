return {
  {
    'gelguy/wilder.nvim',
    keys = {
      ':',
      '/',
      '?',
    },
    lazy = false,
    dependencies = {
      'catppuccin/nvim',
    },
    config = function()
      local wilder = require 'wilder'
      local macchiato = require('catppuccin.palettes').get_palette 'mocha'

      local text_highlight =
        wilder.make_hl('WilderText', { { a = 1 }, { a = 1 }, { foreground = macchiato.text } })
      local mauve_highlight =
        wilder.make_hl('WilderMauve', { { a = 1 }, { a = 1 }, { foreground = macchiato.mauve } })

      wilder.setup { modes = { ':', '?' } }

      wilder.set_option(
        'renderer',
        wilder.popupmenu_renderer(wilder.popupmenu_border_theme {
          highlighter = wilder.basic_highlighter(),
          highlights = {
            default = text_highlight,
            border = mauve_highlight,
            accent = mauve_highlight,
          },
          pumblend = 5,
          min_width = '100%',
          min_height = '25%',
          max_height = '25%',
          border = 'rounded',
          left = { ' ', wilder.popupmenu_devicons() },
          right = { ' ', wilder.popupmenu_scrollbar() },
        })
      )
    end,
  },
}
