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
        row = 0.1,
        col = 0.1,
        width = 0.8,
        height = 0.8,
        border = "single",
      },
      horizontal = { location = "rightbelow", split_ratio = 0.3 },
      vertical = { location = "rightbelow", split_ratio = 0.5 },
    },
  },
  start_in_insert = true,
  get_starting_dir = function()
    return vim.fn.getcwd()
    -- return project_root or vim.fn.expand "%:p:h"
  end,
}
