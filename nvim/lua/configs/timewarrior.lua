local Popup = require "nui.popup"
local NuiText = require "nui.text"
local event = require("nui.utils.autocmd").event

local M = {}

-- Конфигурация по умолчанию остается без изменений
M.config = {
  track_paths = { "/dev/", "/projects/" },
  default_tags = { "@coding" },
  popup = {
    width = 80,
    height = 20,
    border = {
      style = "rounded",
      padding = { top = 1, bottom = 1, left = 2, right = 2 },
    },
  },
  highlights = {
    header = { fg = "#7aa2f7", bold = true },
    project = { fg = "#9ece6a" },
    duration = { fg = "#ff9e64" },
  },
}

-- Функция для получения статуса остается без изменений
M.get_status = function()
  local handle = io.popen "timew"
  if handle then
    local result = handle:read "*a"
    handle:close()
    if string.find(result, "Tracking") then
      local cwd = vim.fn.getcwd()
      local project = vim.fn.fnamemodify(cwd, ":t")
      return "⏱️  " .. project
    end
  end
  return ""
end

local function refresh_summary(popup, sorter, header)
  vim.api.nvim_buf_set_option(popup.bufnr, "modifiable", true)

  local command = { "timew", "summary", sorter }

  vim.fn.jobstart(command, {
    stdout_buffered = true,
    on_stdout = function(_, data)
      if data then
        local lines = {}

        if data[2] then -- Пропускаем пустую первую строку и берем заголовок
          table.insert(lines, data[2])
        end

        if data[3] then -- Строка с разделителем
          table.insert(lines, data[3])
        end

        -- Добавляем остальные строки
        for i = 4, #data do
          if data[i] and data[i] ~= "" then
            table.insert(lines, data[i])
          end
        end

        -- Устанавливаем строки в буфер
        vim.schedule(function()
          if vim.api.nvim_buf_is_valid(popup.bufnr) then
            vim.api.nvim_buf_set_lines(popup.bufnr, 0, -1, false, lines)

            local ns_id = vim.api.nvim_create_namespace "timewarrior_highlights"
            vim.api.nvim_buf_clear_namespace(popup.bufnr, ns_id, 0, -1)

            for i = 0, #lines - 1 do
              if i == 0 then
                vim.api.nvim_buf_add_highlight(popup.bufnr, ns_id, "TimewarriorHeader", i, 0, -1)
              elseif not lines[i + 1]:match "^%-" then -- Не подсвечиваем строки-разделители
                -- Подсветка данных
                local line = lines[i + 1]
                local wk_end = line:find " " or 4
                local tags_start = line:find "@" or 30

                vim.api.nvim_buf_add_highlight(popup.bufnr, ns_id, "Comment", i, 0, wk_end)
                vim.api.nvim_buf_add_highlight(popup.bufnr, ns_id, "TimewarriorProject", i, tags_start, -1)

                local time_start = line:find "%d+:%d+:%d+$"
                if time_start then
                  vim.api.nvim_buf_add_highlight(popup.bufnr, ns_id, "TimewarriorDuration", i, time_start, -1)
                end
              end
            end

            vim.api.nvim_buf_set_option(popup.bufnr, "modifiable", false)
          end
        end)
      end
    end,
    on_stderr = function(_, data) end,
  })
end

-- Функция для получения ID интервала из строки
local function get_interval_id(line_nr, popup)
  local lines = vim.api.nvim_buf_get_lines(popup.bufnr, 0, -1, false)
  local line = lines[line_nr + 1]

  -- Пропускаем заголовки и пустые строки
  if not line or line:match "^%s*$" or line:match "^%-" or line:match "^Wk" then
    return nil
  end

  -- Проверяем, есть ли в строке время начала
  local start_time = line:match "(%d+:%d+:%d+)"
  if not start_time then
    return nil
  end

  -- Собираем все строки с временем
  local time_lines = {}
  for i = 2, #lines do
    local curr_line = lines[i]
    if curr_line and curr_line:match "(%d+:%d+:%d+)" then
      table.insert(time_lines, i)
    end
  end

  -- Находим позицию текущей строки среди строк с временем
  for i, line_index in ipairs(time_lines) do
    if line_index == line_nr + 1 then
      -- Возвращаем индекс в обратном порядке
      return #time_lines - i
    end
  end

  return nil
end

-- Функция для удаления временного интервала
local function delete_interval(interval_index, popup, sorter)
  if not interval_index then
    return
  end

  vim.ui.input({
    prompt = "Delete this time entry? (y/N): ",
  }, function(input)
    if input == "y" or input == "Y" then
      local command = string.format("timew delete @%d", interval_index)
      vim.fn.system(command)
      vim.notify(string.format("Time entry deleted @%d", interval_index), vim.log.levels.INFO)
      refresh_summary(popup, sorter)
    end
  end)
end

-- Создание всплывающего окна с summary
M.show_summary = function(opts, width, height)
  local sorter = ":" .. (opts or "week")

  local popup = Popup {
    position = "50%",
    size = {
      width = width or M.config.popup.width,
      height = height or M.config.popup.height,
    },
    enter = true,
    focusable = true,
    zindex = 50,
    relative = "editor",
    border = {
      style = M.config.popup.border.style,
      padding = M.config.popup.border.padding,
      text = {
        top = NuiText(" Timewarrior Summary ", "Special"),
        top_align = "center",
        bottom = NuiText(" q:quit  r:refresh  D:day  w:week  m:month  d:delete ", "SpecialComment"),
      },
    },
    buf_options = {
      modifiable = true,
      readonly = false,
      filetype = "timewarrior-summary",
    },
    win_options = {
      cursorline = true,
      cursorlineopt = "line",
    },
  }

  for name, opts in pairs(M.config.highlights) do
    vim.api.nvim_set_hl(0, "Timewarrior" .. name:gsub("^%l", string.upper), opts)
  end

  -- Клавиши
  local keymaps = {
    ["q"] = function()
      popup:unmount()
    end,
    ["r"] = function()
      refresh_summary(popup, sorter)
    end,
    ["D"] = function() -- Изменено с 'd' на 'D' для дневного отчёта
      refresh_summary(popup, "day")
    end,
    ["w"] = function()
      refresh_summary(popup, "week")
    end,
    ["m"] = function()
      refresh_summary(popup, "month")
    end,
    ["d"] = function()
      local current_line = vim.api.nvim_win_get_cursor(popup.winid)[1] - 1
      local interval_index = get_interval_id(current_line, popup)
      if interval_index then
        delete_interval(interval_index, popup, sorter)
      else
        vim.notify("No valid time entry on this line", vim.log.levels.WARN)
      end
    end,
    ["<Esc>"] = function()
      popup:unmount()
    end,
  }

  for key, handler in pairs(keymaps) do
    popup:map("n", key, handler, { noremap = true })
  end

  local header = string.format("%-30s %-20s %10s", "Date Range", "Project", "Duration")

  popup:mount()
  popup:on(event.BufLeave, function()
    popup:unmount()
  end)

  refresh_summary(popup, sorter, header)
  return popup
end

-- Остальные функции остаются без изменений
local function start_tracking()
  local cwd = vim.fn.getcwd()
  local project = vim.fn.fnamemodify(cwd, ":t")
  local tags = table.concat(M.config.default_tags, " ")
  vim.fn.system('timew start "' .. project .. '" ' .. tags)
  vim.notify("Started tracking: " .. project, vim.log.levels.INFO)
end

local function stop_tracking()
  vim.fn.system "timew stop"
  vim.notify("Stopped tracking", vim.log.levels.INFO)
end

M.setup = function(opts)
  M.config = vim.tbl_deep_extend("force", M.config, opts or {})

  local group = vim.api.nvim_create_augroup("TimewarriorTracking", { clear = true })

  vim.api.nvim_create_autocmd("VimEnter", {
    group = group,
    callback = function()
      local cwd = vim.fn.getcwd()
      for _, path in ipairs(M.config.track_paths) do
        if string.find(cwd, path) then
          vim.fn.system "timew stop"
          start_tracking()
          break
        end
      end
    end,
  })

  vim.api.nvim_create_autocmd("VimLeave", {
    group = group,
    callback = stop_tracking,
  })

  vim.api.nvim_create_user_command("TimeStart", start_tracking, {})
  vim.api.nvim_create_user_command("TimeStop", stop_tracking, {})
  vim.api.nvim_create_user_command("TimeStatus", function()
    local output = vim.fn.system "timew"
    vim.api.nvim_echo({ { output, "Normal" } }, true, {})
  end, {})

  vim.api.nvim_create_user_command("TimeSum", function(opts)
    M.show_summary(opts.args or "week", M.config.popup.width, M.config.popup.height)
  end, {
    nargs = "?",
    complete = function()
      return { "day", "week", "month", "year" }
    end,
  })
end

return M
