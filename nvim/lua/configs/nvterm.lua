require("nvterm").setup {
  behavior = {
    autoclose_on_quit = {
      enabled = false,
      confirm = true,
    },
    close_on_exit = false,
    auto_insert = true,
  },
  terminals = {
    shell = vim.o.shell,
    list = {},
    type_opts = {
      float = {
        relative = "editor",
        row = 0.3,
        col = 0.25,
        width = 0.5,
        height = 0.4,
        border = "single",
      },
      horizontal = { location = "rightbelow", split_ratio = 0.3 },
      vertical = { location = "rightbelow", split_ratio = 0.5 },
    },
  },

  -- Добавляем новую опцию для установки начальной директории
  start_in_insert = true,
  -- Функция для определения начальной директории
  get_starting_dir = function()
    local project_root = vim.fn.getcwd()
    return project_root or vim.fn.expand "%:p:h"
  end,
}
