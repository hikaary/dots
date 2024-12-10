return {
  "rebelot/heirline.nvim",
  lazy = false,
  dependencies = {
    "nvim-tree/nvim-web-devicons",
    "lewis6991/gitsigns.nvim",
  },
  config = function()
    local heirline = require "heirline"
    local conditions = require "heirline.conditions"
    local utils = require "heirline.utils"

    local function setup_colors()
      local present, base46 = pcall(require, "base46")
      if present then
        local colors = base46.get_theme_tb "base_30"
        return {
          bright_bg = "NONE",
          bright_fg = colors.white,
          red = colors.red,
          dark_red = colors.red,
          green = colors.green,
          blue = colors.blue,
          gray = colors.grey,
          orange = colors.orange,
          purple = colors.purple,
          cyan = colors.cyan,
          diag_warn = colors.yellow,
          diag_error = colors.red,
          diag_hint = colors.purple,
          diag_info = colors.green,
          git_del = colors.red,
          git_add = colors.green,
          git_change = colors.yellow,
        }
      end

      return {
        bright_bg = "#2d3149",
        bright_fg = "#c0caf5",
        red = "#f7768e",
        dark_red = "#db4b4b",
        green = "#9ece6a",
        blue = "#7aa2f7",
        gray = "#565f89",
        orange = "#ff9e64",
        purple = "#bb9af7",
        cyan = "#7dcfff",
        diag_warn = "#e0af68",
        diag_error = "#db4b4b",
        diag_hint = "#1abc9c",
        diag_info = "#0db9d7",
        git_del = "#db4b4b",
        git_add = "#449dab",
        git_change = "#6183bb",
      }
    end

    -- Компоненты
    local Align = { provider = "%=" }
    local Space = { provider = " " }

    -- Режим Vim
    local ViMode = {
      init = function(self)
        self.mode = vim.fn.mode(1)
      end,
      static = {
        mode_names = {
          n = "NORMAL",
          no = "OP",
          nov = "OP",
          noV = "OP",
          ["no\22"] = "OP",
          niI = "NORMAL",
          niR = "NORMAL",
          niV = "NORMAL",
          nt = "NORMAL",
          v = "VISUAL",
          vs = "VISUAL",
          V = "V-LINE",
          Vs = "V-LINE",
          ["\22"] = "V-BLOCK",
          ["\22s"] = "V-BLOCK",
          s = "SELECT",
          S = "S-LINE",
          ["\19"] = "S-BLOCK",
          i = "INSERT",
          ic = "INSERT",
          ix = "INSERT",
          R = "REPLACE",
          Rc = "REPLACE",
          Rx = "REPLACE",
          Rv = "V-REPLACE",
          Rvc = "V-REPLACE",
          Rvx = "V-REPLACE",
          c = "COMMAND",
          cv = "EX",
          ce = "EX",
          r = "REPLACE",
          rm = "MORE",
          ["r?"] = "CONFIRM",
          ["!"] = "SHELL",
          t = "TERMINAL",
        },
        mode_colors = {
          n = "blue",
          i = "green",
          v = "purple",
          V = "purple",
          ["\22"] = "purple",
          c = "orange",
          s = "purple",
          S = "purple",
          ["\19"] = "purple",
          R = "red",
          r = "red",
          ["!"] = "blue",
          t = "blue",
        },
      },
      provider = function(self)
        return " %2(" .. self.mode_names[self.mode] .. "%)"
      end,
      hl = function(self)
        local mode = self.mode:sub(1, 1)
        return { fg = self.mode_colors[mode], bold = true }
      end,
      update = {
        "ModeChanged",
        pattern = "*:*",
        callback = vim.schedule_wrap(function()
          vim.cmd "redrawstatus"
        end),
      },
    }

    -- Файл
    local FileNameBlock = {
      init = function(self)
        self.filename = vim.api.nvim_buf_get_name(0)
      end,
      hl = { fg = utils.get_highlight("Directory").fg },
    }

    local FileIcon = {
      init = function(self)
        local filename = self.filename
        local extension = vim.fn.fnamemodify(filename, ":e")
        self.icon, self.icon_color =
          require("nvim-web-devicons").get_icon_color(filename, extension, { default = true })
      end,
      provider = function(self)
        return self.icon and (self.icon .. " ")
      end,
      hl = function(self)
        return { fg = self.icon_color }
      end,
    }

    local FileName = {
      provider = function(self)
        local filename = vim.fn.fnamemodify(self.filename, ":.")
        if filename == "" then
          return "[No Name]"
        end
        if not conditions.width_percent_below(#filename, 0.25) then
          filename = vim.fn.pathshorten(filename)
        end
        return filename
      end,
      hl = { fg = "bright_fg" },
    }

    local FileFlags = {
      {
        provider = function()
          if vim.bo.modified then
            return " [+]"
          end
        end,
        hl = { fg = "green" },
      },
      {
        provider = function()
          if not vim.bo.modifiable or vim.bo.readonly then
            return " "
          end
        end,
        hl = { fg = "orange" },
      },
    }

    FileNameBlock = utils.insert(FileNameBlock, FileIcon, FileName, unpack(FileFlags))

    -- Git статус
    local Git = {
      condition = conditions.is_git_repo,
      init = function(self)
        self.status_dict = vim.b.gitsigns_status_dict
        self.has_changes = self.status_dict.added ~= 0 or self.status_dict.removed ~= 0 or self.status_dict.changed ~= 0
      end,
      hl = { fg = "orange" },
      {
        provider = function(self)
          return " " .. self.status_dict.head
        end,
        hl = { bold = true },
      },
      {
        condition = function(self)
          return self.has_changes
        end,
        provider = "(",
      },
      {
        provider = function(self)
          local count = self.status_dict.added or 0
          return count > 0 and ("+" .. count)
        end,
        hl = { fg = "git_add" },
      },
      {
        provider = function(self)
          local count = self.status_dict.removed or 0
          return count > 0 and ("-" .. count)
        end,
        hl = { fg = "git_del" },
      },
      {
        provider = function(self)
          local count = self.status_dict.changed or 0
          return count > 0 and ("~" .. count)
        end,
        hl = { fg = "git_change" },
      },
      {
        condition = function(self)
          return self.has_changes
        end,
        provider = ")",
      },
    }

    -- LSP диагностика
    local Diagnostics = {
      condition = conditions.has_diagnostics,
      static = {
        error_icon = "  ",
        warn_icon = "  ",
        info_icon = "  ",
        hint_icon = " ",
      },
      init = function(self)
        self.errors = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.ERROR })
        self.warnings = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.WARN })
        self.hints = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.HINT })
        self.info = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.INFO })
      end,
      update = { "DiagnosticChanged", "BufEnter" },
      {
        provider = function(self)
          return self.errors > 0 and (self.error_icon .. self.errors .. " ")
        end,
        hl = { fg = "diag_error" },
      },
      {
        provider = function(self)
          return self.warnings > 0 and (self.warn_icon .. self.warnings .. " ")
        end,
        hl = { fg = "diag_warn" },
      },
      {
        provider = function(self)
          return self.info > 0 and (self.info_icon .. self.info .. " ")
        end,
        hl = { fg = "diag_info" },
      },
      {
        provider = function(self)
          return self.hints > 0 and (self.hint_icon .. self.hints)
        end,
        hl = { fg = "diag_hint" },
      },
    }

    -- Позиция курсора
    local Ruler = {
      provider = "%7(%l/%3L%):%2c %P",
      hl = { fg = "bright_fg" },
    }

    -- LSP активность
    local LSPActive = {
      condition = conditions.lsp_attached,
      update = { "LspAttach", "LspDetach" },
      provider = function()
        local names = {}
        for _, server in pairs(vim.lsp.get_active_clients { bufnr = 0 }) do
          table.insert(names, server.name)
        end
        return " [" .. table.concat(names, " ") .. "]"
      end,
      hl = { fg = "green", bold = true },
    }
    local Messages = {
      provider = function()
        local messages = vim.api.nvim_exec("messages", true)
        if messages and messages ~= "" then
          -- Берём только последнее сообщение
          local last_message = vim.split(messages, "\n")[1]
          return last_message
        end
        return ""
      end,
      hl = { fg = "grey", italic = true },
    }

    local StatusLine = {
      ViMode,
      Space,
      FileNameBlock,
      Space,
      Git,
      Messages,
      Space,
      Diagnostics,
      Align,
      LSPActive,
      Space,
      Ruler,
      Space,
    }

    heirline.setup {
      statusline = StatusLine,
      opts = {
        colors = setup_colors(),
        disable_winbar_cb = function(args)
          return conditions.buffer_matches({
            buftype = { "nofile", "prompt", "help", "quickfix" },
            filetype = { "^git.*", "fugitive", "Trouble", "dashboard" },
          }, args.buf)
        end,
      },
    }

    vim.opt.winbar = ""
    vim.opt.laststatus = 3

    vim.api.nvim_set_hl(0, "WinBar", { bg = "NONE", fg = "#c0caf5" })
    vim.api.nvim_set_hl(0, "WinBarNC", { bg = "NONE", fg = "#565f89" })
    vim.api.nvim_set_hl(0, "StatusLine", { bg = "NONE" })
    vim.api.nvim_set_hl(0, "StatusLineNC", { bg = "NONE" })
  end,
}
