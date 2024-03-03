require("noice").setup {
  cmdline = {
    enabled = true,
    view = "cmdline_popup",
    opts = {},
    format = {
      cmdline = { pattern = "^:", icon = " 󰘳 ", lang = "vim" },
      search_down = { kind = "search", pattern = "^/", icon = "  ", lang = "regex", title = " Search " },
      search_up = { kind = "search", pattern = "^%?", icon = "  ", lang = "regex", title = " Search " },
      filter = { pattern = "^:%s*!", icon = "  ", lang = "bash", title = " Shell " },
      lua = { pattern = { "^:%s*lua%s+", "^:%s*lua%s*=%s*", "^:%s*=%s*" }, icon = "  ", lang = "lua" },
      help = { pattern = "^:%s*he?l?p?%s+", icon = " ", title = " Help " },
      input = {},
    },
  },
  messages = {
    enabled = true,
    view = "mini",
    view_error = "mini",
    view_warn = "mini",
    view_history = "messages",
    view_search = false,
  },
  popupmenu = {
    enabled = true,
    backend = "cmp",
    kind_icons = {},
  },
  redirect = {
    view = "popup",
    filter = { event = "msg_show" },
  },
  commands = {
    history = {
      view = "split",
      opts = { enter = true, format = "details" },
      filter = {
        any = {
          { event = "notify" },
          { error = true },
          { warning = true },
          { event = "msg_show", kind = { "" } },
          { event = "lsp", kind = "message" },
        },
      },
    },
    last = {
      view = "popup",
      opts = { enter = true, format = "details" },
      filter = {
        any = {
          { event = "notify" },
          { error = true },
          { warning = true },
          { event = "msg_show", kind = { "" } },
          { event = "lsp", kind = "message" },
        },
      },
      filter_opts = { count = 1 },
    },
    errors = {
      view = "popup",
      opts = { enter = true, format = "details" },
      filter = { error = true },
      filter_opts = { reverse = true },
    },
  },
  notify = {
    enabled = true,
    view = "notify",
  },
  lsp = {
    progress = {
      enabled = false,
    },
    override = {
      ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
      ["vim.lsp.util.stylize_markdown"] = true,
      ["cmp.entry.get_documentation"] = true,
    },
    hover = {
      enabled = true,
      view = nil,
      opts = {},
    },
    signature = {
      enabled = true,
      auto_open = {
        enabled = true,
        trigger = true,
        luasnip = true,
        throttle = 50,
      },
      view = nil,
      opts = {},
    },
    message = {
      enabled = false,
      view = "notify",
      opts = {},
    },
    documentation = {
      view = "hover",
      opts = {
        lang = "markdown",
        replace = true,
        render = "plain",
        format = { "{message}" },
        win_options = { concealcursor = "n", conceallevel = 3 },
      },
    },
  },
  markdown = {
    hover = {
      ["|(%S-)|"] = vim.cmd.help,
      ["%[.-%]%((%S-)%)"] = require("noice.util").open,
    },
    highlights = {
      ["|%S-|"] = "@text.reference",
      ["@%S+"] = "@parameter",
      ["^%s*(Parameters:)"] = "@text.title",
      ["^%s*(Return:)"] = "@text.title",
      ["^%s*(See also:)"] = "@text.title",
      ["{%S-}"] = "@parameter",
    },
  },
  health = {
    checker = false,
  },
  smart_move = {
    enabled = true,
    excluded_filetypes = { "cmp_menu", "cmp_docs", "notify" },
  },
  presets = {
    bottom_search = false,
    command_palette = false,
    long_message_to_split = true,
    inc_rename = true,
    lsp_doc_border = false,
  },
  throttle = 1000 / 30,
  views = {
    cmdline_popup = {
      position = {
        row = "50%",
        col = "50%",
      },
      size = {
        width = "50%",
        height = "auto",
      },
      filter_options = {},
    },
    split = {
      enter = true,
    },
    notify = {
      size = {
        width = 30,
      },
    },
    popupmenu = {
      relative = "editor",
      position = {
        row = 8,
        col = "50%",
      },
      size = {
        width = 60,
        height = 10,
      },
    },
  },
  routes = {
    {
      filter = {
        event = "msg_show",
        find = "written",
      },
      opts = { skip = true },
    },
  },
}

vim.notify = require "notify"

require("notify").setup {
  background_colour = "Normal",
  fps = 30,
  icons = {
    DEBUG = " ",
    ERROR = " ",
    INFO = " ",
    TRACE = "✎",
    WARN = " ",
  },
  level = 2,
  minimum_width = 10,
  maximum_width = 20,
  render = "default",
  stages = "slide",
  timeout = 1000,
}