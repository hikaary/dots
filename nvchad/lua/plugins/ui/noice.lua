return {
  "folke/noice.nvim",
  event = "VeryLazy",
  opts = function()
    return {
      presets = { bottom_search = true },
      cmdline = {
        enabled = false,
      },
      views = {
        cmdline_popup = {
          border = {
            style = "none",
            padding = { 1, 2 },
          },
          win_options = {
            winhighlight = {
              Normal = "Normal",
              FloatBorder = "DiagnosticInfo",
            },
          },
        },
      },
      messages = { enabled = false },
      lsp = {
        hover = { enabled = false },
        signature = { enabled = false },
        progress = { enabled = false },
        message = { enabled = false },
        smart_move = { enabled = false },
      },
    }
  end,
}
