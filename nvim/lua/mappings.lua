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
-- map("n", "<leader>e", "<cmd>Telescope fd<CR>", "Toggle NvimTree")

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

-- split
map("n", "<leader>sv", "<cmd>:vsplit<CR>")

-- Venv select
map("n", "<leader>cv", "<cmd>VenvSelect<cr>")

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
