require("nvterm").setup {
  terminals = {
    shell = vim.o.shell,
    list = {},
    type_opts = {
      float = {
        relative = "editor",
        row = 0.15,
        col = 0.1,
        width = 0.8,
        height = 0.7,
        border = "rounded",
      },
    },
  },
}
