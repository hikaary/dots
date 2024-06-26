return {
  {
    'nvim-telescope/telescope-frecency.nvim',
    dependencies = {
      { 'nvim-telescope/telescope.nvim' },
    },
    config = function()
      require('telescope').load_extension 'frecency'
    end,
  },
  {
    'nvim-telescope/telescope.nvim',
    optional = true,
    config = function()
      require('telescope').setup {
        defaults = {
          file_sorter = require('telescope.sorters').get_fuzzy_file,
          file_ignore_patterns = { 'node_modules' },
          generic_sorter = require('telescope.sorters').get_generic_fuzzy_sorter,
          layout_config = {
            horizontal = {
              prompt_position = 'top',
              preview_width = 0.55,
              results_width = 0.8,
            },
            vertical = {
              mirror = false,
            },
            width = 0.87,
            height = 0.80,
            preview_cutoff = 120,
          },
          vimgrep_arguments = {
            'rg',
            '-L',
            '--color=never',
            '--no-heading',
            '--with-filename',
            '--line-number',
            '--column',
            '--smart-case',
          },
        },
      }
    end,
    opts = {},
  },
}
