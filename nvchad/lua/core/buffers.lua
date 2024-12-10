local M = {}

function M.setup()
  -- Функция для закрытия всех буферов с файлами, кроме текущего
  local function close_other_file_buffers()
    local current = vim.fn.bufnr "%"
    local buffers = vim.api.nvim_list_bufs()

    for _, buf in ipairs(buffers) do
      if
        vim.api.nvim_buf_is_loaded(buf)
        and buf ~= current
        and vim.bo[buf].buftype == ""
        and vim.api.nvim_buf_get_name(buf) ~= ""
      then
        -- Сохраняем файл в истории перед закрытием
        local fname = vim.api.nvim_buf_get_name(buf)
        vim.fn.setpos("'\"", { buf, 1, 1, 0 })

        -- Сохраняем изменения если они есть
        if vim.bo[buf].modified then
          vim.api.nvim_buf_call(buf, function()
            vim.cmd "write"
          end)
        end

        -- Добавляем в историю старых файлов перед закрытием
        vim.fn.histadd("oldfiles", fname)

        -- Используем hidden вместо удаления
        vim.api.nvim_buf_set_option(buf, "buflisted", false)
        vim.api.nvim_buf_set_option(buf, "hidden", true)
      end
    end
  end

  -- Периодическая очистка скрытых буферов
  local function cleanup_hidden_buffers()
    local buffers = vim.api.nvim_list_bufs()
    for _, buf in ipairs(buffers) do
      if not vim.api.nvim_buf_get_option(buf, "buflisted") and vim.api.nvim_buf_get_option(buf, "hidden") then
        if not vim.api.nvim_buf_get_option(buf, "modified") then
          vim.api.nvim_buf_delete(buf, { force = false })
        end
      end
    end
  end

  -- Запускаем очистку каждые 5 минут
  vim.defer_fn(function()
    vim.schedule_wrap(cleanup_hidden_buffers)
  end, 300000)

  -- Автоматическое закрытие других буферов при открытии нового файла
  vim.api.nvim_create_autocmd("BufEnter", {
    callback = function()
      if vim.bo.buftype == "" and vim.fn.expand "%" ~= "" then
        vim.schedule(function()
          close_other_file_buffers()
        end)
      end
    end,
  })

  -- Восстановление позиции курсора
  vim.api.nvim_create_autocmd("BufReadPost", {
    callback = function()
      local mark = vim.api.nvim_buf_get_mark(0, '"')
      local lcount = vim.api.nvim_buf_line_count(0)
      if mark[1] > 0 and mark[1] <= lcount then
        pcall(vim.api.nvim_win_set_cursor, 0, mark)
      end
    end,
  })

  -- Автосохранение при потере фокуса
  vim.api.nvim_create_autocmd({ "FocusLost", "BufLeave" }, {
    callback = function()
      if vim.bo.modified and not vim.bo.readonly and vim.fn.expand "%" ~= "" then
        vim.api.nvim_command "silent! write"
      end
    end,
  })

  -- Очистка пробелов при сохранении
  vim.api.nvim_create_autocmd({ "BufWritePre" }, {
    callback = function()
      if not vim.b.large_buf then
        vim.cmd [[%s/\s\+$//e]]
      end
    end,
  })
end

return M
