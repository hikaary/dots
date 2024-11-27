local M = {}

function M.setup()
  -- Оптимизации производительности
  vim.opt.redrawtime = 1500
  vim.opt.timeoutlen = 500
  vim.opt.updatetime = 300
  vim.opt.maxmempattern = 2000000
  vim.opt.synmaxcol = 240

  -- Ограничение размера файлов для различных операций
  vim.g.max_file = {
    size = 1024 * 128, -- 128KB
    lines = 10000,
  }

  -- Отключение лишних встроенных плагинов
  local disabled_built_ins = {
    "netrw",
    "netrwPlugin",
    "netrwSettings",
    "netrwFileHandlers",
    "gzip",
    "zip",
    "zipPlugin",
    "tar",
    "tarPlugin",
    "getscript",
    "getscriptPlugin",
    "vimball",
    "vimballPlugin",
    "2html_plugin",
    "logipat",
    "rrhelper",
    "spellfile_plugin",
    "matchit",
  }

  for _, plugin in pairs(disabled_built_ins) do
    vim.g["loaded_" .. plugin] = 1
  end

  vim.api.nvim_create_autocmd("BufReadPre", {
    callback = function()
      local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(0))
      if ok and stats and (stats.size > vim.g.max_file.size) then
        vim.b.large_buf = true
        vim.cmd [[syntax clear]]
        vim.opt_local.foldmethod = "manual"
        vim.opt_local.cmdheight = 2
        vim.notify "Large file detected, optimizations applied"
      else
        vim.b.large_buf = false
      end
    end,
  })
end

return M
