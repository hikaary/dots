require "nvchad.mappings"

-- add yours here
--
local function map(mode, lhs, rhs, desc)
  vim.keymap.set(mode, lhs, rhs, { silent = true, desc = desc, noremap = true })
end

map("n", "<leader>pa", "")

map("n", ";", ":", "CMD enter command mode")

-- general
map("n", "<leader>q", ":quit<Return>")
map("n", "q", ":quit<Return>")
map("n", ";", ":")
map("n", "<C-s>", ":write<CR>")
map("n", "<leader>h", "")
map("n", ";", ":", "CMD enter command mode")
map("n", "<leader>v", "")
map("n", "<C-c>", "<cmd>%y+<CR>", "file copy whole")
map("n", "<Esc>", "<cmd>noh<CR>", "general clear highlights")

map("n", "<leader>e", "<cmd>NvimTreeToggle<CR>", "Toggle NvimTree")

-- GIT
map("n", "<leader>lg", "<cmd>Neogit<CR>", "Toggle Neogit")

-- move lines
map("v", "<A-j>", ":m '>+1<CR>gv=gv")
map("v", "<A-k>", ":m '<-2<CR>gv=gv")
map("n", "<A-k>", ":m .-2<CR>==")
map("n", "<A-j>", ":m .+1<CR>==")

-- split window
map("n", "sh", ":split<Return>")
map("n", "sv", ":vsplit<Return>")

-- move window
map("n", "sh", "<C-w>h")
map("n", "sk", "<C-w>k")
map("n", "sj", "<C-w>j")
map("n", "sl", "<C-w>l")

-- aerial
map("n", "<leader>a", "<cmd>AerialToggle!<CR>")
-- resize window
map("n", "<C-S-h>", "<C-w><")
map("n", "<C-S-l>", "<C-w>>")
map("n", "<C-S-k>", "<C-w>+")
map("n", "<C-S-j>", "<C-w>-")

-- telescope
map("n", "<leader>fw", "<cmd> Telescope live_grep <CR>")
map("n", "<leader>fo", "<cmd>Telescope oldfiles<CR>")

-- Term
map({ "n", "t" }, "<C-f>", function()
  require("nvterm.terminal").toggle "float"
end)

-- split
map("n", "<leader>sv", "<cmd>:vsplit<CR>")

-- Venv select
map("n", "<leader>cv", "<cmd>VenvSelect<cr>")

-- Хоткеи для gitlab.nvim
local gitlab = require "gitlab"

-- Обзор текущего MR (Merge Request)
map("n", "<leader>gl", gitlab.choose_merge_request, "Выбор MR")

-- Обзор текущего MR (Merge Request)
map("n", "<leader>gr", gitlab.review, "Обзор текущего MR")

-- Показать сводку MR
map("n", "<leader>gs", gitlab.summary, "Показать сводку MR")

-- Одобрить текущий MR
map("n", "<leader>ga", gitlab.approve, "Одобрить MR")

-- Отозвать одобрение MR
map("n", "<leader>gR", gitlab.revoke, "Отозвать одобрение MR")

-- Создать комментарий
map("n", "<leader>gc", gitlab.create_comment, "Создать комментарий")

-- Создать многострочный комментарий (в визуальном режиме)
map(
  "v",
  "<leader>gC",
  gitlab.create_multiline_comment,
  "Создать многострочный комментарий"
)

-- Создать предложение изменения (в визуальном режиме)
map("v", "<leader>gS", gitlab.create_comment_suggestion, "Создать предложение изменения")

-- Создать новый MR
map("n", "<leader>gn", gitlab.create_mr, "Создать новый MR")

-- Переключить отображение обсуждений
map("n", "<leader>gd", gitlab.toggle_discussions, "Переключить отображение обсуждений")

-- Опубликовать все черновики
map("n", "<leader>gp", gitlab.publish_all_drafts, "Опубликовать все черновики")

-- Переключить режим черновика
map("n", "<leader>gt", gitlab.toggle_draft_mode, "Переключить режим черновика")

-- Добавить рецензента
map("n", "<leader>gA", gitlab.add_reviewer, "Добавить рецензента")

-- Удалить рецензента
map("n", "<leader>gD", gitlab.delete_reviewer, "Удалить рецензента")

-- Показать информацию о pipeline
map("n", "<leader>gP", gitlab.pipeline, "Показать информацию о pipeline")

-- Открыть MR в браузере
map("n", "<leader>go", gitlab.open_in_browser, "Открыть MR в браузере")

-- Скопировать URL текущего MR
map("n", "<leader>gy", gitlab.copy_mr_url, "Скопировать URL MR")

-- Объединить (merge) текущий MR
map("n", "<leader>gm", gitlab.merge, "Объединить текущий MR")

-- parrot (AI)

-- Переключить текущий чат
map("n", "<leader>pc", ":PrtChatToggle<CR>")

-- Открыть поиск по чатам
map("n", "<leader>pf", ":PrtChatFinder<CR>")

-- Сгенерировать докстринг для функции под курсором
map(
  "v",
  "<leader>pd",
  ":PrtRewrite Сгенерируй докстринг для функции. Описание пиши на русском. Не забывай про кавычки Вот пример докстринга: def func(arg1, arg2): Тут описание :param arg1: Описание arg1. :type arg1: int :param arg2: Описание arg2. :type arg2: int :raise: ValueError if arg1 is больше to arg2 :return: Описание того, что возвращается :rtype: bool <CR>"
)

-- Добавить логи в выделенный код
map(
  "v",
  "<leader>pl",
  ":PrtRewrite Добавь логи в этот код, используя logger. Не изменяй существующий код, только добавь логи. Не добавляй импорты или другие изменения. Логи должны быть информативными и помогать в отладке. Используй разные уровни логирования (debug, info, warning, error) в зависимости от контекста. Вот пример того, как нужно добавлять логи: logger.debug('Начало выполнения функции example_function') logger.info(f'Получено значение: {value}') logger.warning('Предупреждение: достигнут лимит попыток') logger.error(f'Ошибка при обработке данных: {str(e)}') <CR>"
)
-- Исправить ошибку в текущей строке
map("v", "<leader>pf", ":PrtRewrite Исправь ошибку<CR>")

-- Сгенерировать юнит-тесты для текущей функции
map("v", "<leader>pt", ":PrtRewrite Сгенерируй юнит-тесты (pytest)<CR>")

-- Оптимизация
map(
  "v",
  "<leader>po",
  ":PrtRewrite Оптимизируй этот код для лучшей производительности<CR>"
)
