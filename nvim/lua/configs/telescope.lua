return {
  opts = {
    default = {
      file_ignore_pattern = { ".git", "venv" },
      initial_mode = "normal",
    },
    extension_list = { "notify", "flutter", "treesitter", "ui-select" },
    extensions = {
      notify = {},
      ["ui-select"] = {
        require("telescope.themes").get_dropdown {},
      },
    },
  },
  pickers = {
    buffers = {
      mappings = {
        i = {
          ["<C-c>"] = function(prompt_bufnr)
            local action_state = require "telescope.actions.state"
            local current_picker = action_state.get_current_picker(prompt_bufnr)
            current_picker:delete_selection(function(selection)
              local bufnr = selection.bufnr
              local winids = vim.fn.win_findbuf(bufnr)
              for _, winid in ipairs(winids) do
                local new_buf = vim.api.nvim_create_buf(false, true)
                vim.api.nvim_win_set_buf(winid, new_buf)
              end
              vim.api.nvim_buf_delete(bufnr, { force = true })
            end)
          end,
        },
      },
    },
  },
}
