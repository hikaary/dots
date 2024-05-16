return {
  {
    "echasnovski/mini.files",
    keys = {
      { "<leader>e", "<cmd>lua require('mini.files').open()<CR>", desc = "mini.files: Open" },
    },
    init = function()
      if vim.fn.argc() == 1 then
        local stat = vim.loop.fs_stat(vim.fn.argv(0))
        if stat and stat.type == "directory" then
          require "mini.files"
        end
      end
      vim.api.nvim_create_autocmd("User", {
        pattern = "MiniFilesWindowOpen",
        callback = function(args)
          local win_id = args.data.win_id

          vim.api.nvim_win_set_config(win_id, { border = "solid" })
        end,
      })
    end,
    opts = {
      windows = {
        max_number = math.huge,
        preview = true,
        width_focus = 40,
        width_nofocus = 10,
        width_preview = 45,
      },
      mappings = {
        close = "q",
        go_in = "<cr>",
        go_in_plus = "L",
        go_out = "h",
        go_out_plus = "H",
        reset = "R",
        reveal_cwd = "@",
        show_help = "g?",
        synchronize = "<C-s>",
        trim_left = "<",
        trim_right = ">",
      },
    },
  },
}
