return {
  'NvChad/nvterm',
  config = function()
    require('nvterm').setup {
      behavior = {
        autoclose_on_quit = {
          enabled = false,
          confirm = true,
        },
        close_on_exit = false,
        auto_insert = true,
      },
    }
  end,
  opts = {},
  lazy = false,
}
