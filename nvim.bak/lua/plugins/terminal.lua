return {
  "akinsho/toggleterm.nvim",
  event = "VeryLazy",
  config = function()
    require("toggleterm").setup()

    local Terminal = require("toggleterm.terminal").Terminal
    local defaults = {
      direction = "float",
      float_opts = {
        border = "curved",
        title_pos = "center",
      },
      shade_terminals = true,
      terminal_mappings = true,
      close_on_exit = true,
      auto_scroll = true,
    }

    local console = Terminal:new(vim.tbl_deep_extend("force", {
      dir = "git_dir",
    }, defaults))

    function _toggle_console()
      console:toggle()
    end

    local htop = Terminal:new(vim.tbl_deep_extend("force", {
      cmd = "htop",
    }, defaults))

    function _toggle_htop()
      htop:toggle()
    end
  end,
}
