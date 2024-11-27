local M = {}

-- Получаем имя проекта из текущей директории
local function get_project_name()
  local cwd = vim.fn.getcwd()
  return vim.fn.fnamemodify(cwd, ":t")
end

-- Запуск таймера
function M.start_tracking()
  local project = get_project_name()
  -- Останавливаем предыдущий трекинг если есть
  vim.fn.system "timew stop"
  -- Запускаем новый с тегом проекта
  vim.fn.system('timew start "' .. project .. '" @coding')
  vim.notify("Started tracking: " .. project, vim.log.levels.INFO)
end

-- Остановка таймера
function M.stop_tracking()
  vim.fn.system "timew stop"
  vim.notify("Stopped time tracking", vim.log.levels.INFO)
end

return M
