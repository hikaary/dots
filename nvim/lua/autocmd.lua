local autocmd = vim.api.nvim_create_autocmd

autocmd('BufReadPost', {
  pattern = '*',
  callback = function()
    local line = vim.fn.line '\'"'
    if
      line > 1
      and line <= vim.fn.line '$'
      and vim.bo.filetype ~= 'commit'
      and vim.fn.index({ 'xxd', 'gitrebase' }, vim.bo.filetype) == -1
    then
      vim.cmd 'normal! g`"'
    end
  end,
})

-- autocmd('BufWritePre', {
--   pattern = '*',
--   callback = function(args)
--     require('conform').format { bufnr = args.buf }
--   end,
-- })

autocmd('TextYankPost', {
  group = vim.api.nvim_create_augroup('highlight_yank', { clear = true }),
  pattern = '*',
  desc = 'Highlight selection on yank',
  callback = function()
    vim.highlight.on_yank { timeout = 200, visual = true }
  end,
})
