return {
  {

    'stevearc/conform.nvim',
    lazy = false,
    config = function()
      local slow_format_filetypes = {}
      require('conform').setup {
        formatters_by_ft = {
          css = { 'prettierd', 'prettier' },
          toml = { 'taplo' },
          lua = { 'stylua' },
          typst = { 'prettypst_formatter' },
          json = { 'clang-format' },
        },
        formatters = {
          prettypst_formatter = {
            command = 'prettypst',
            args = { '--use-std-in', '--use-std-out' },
            stdin = true,
            cwd = require('conform.util').root_file { '.editorconfig', 'prettypst.toml' },
          },
        },

        format_on_save = {
          timeout_ms = 500,
          lsp_format = 'fallback',
        },
        format_after_save = function(bufnr)
          if not slow_format_filetypes[vim.bo[bufnr].filetype] then
            return
          end
          return { lsp_fallback = true }
        end,
      }
    end,
  },
}
