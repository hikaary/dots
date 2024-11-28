return {
  "saghen/blink.cmp",
  lazy = false,
  dependencies = "rafamadriz/friendly-snippets",
  build = "cargo build --release",
  ---@module 'blink.cmp'
  opts = {
    keymap = {
      preset = "default",
      ["<C-k>"] = { "select_prev", "fallback" },
      ["<C-j>"] = { "select_next", "fallback" },
      ["<CR>"] = { "select_and_accept", "fallback" },
    },
    appearance = {
      use_nvim_cmp_as_default = false,
      nerd_font_variant = "mono",
    },

    sources = {
      completion = {
        enabled_providers = { "lsp", "path", "snippets", "buffer" },
      },
    },

    completion = { accept = { auto_brackets = { enabled = true } } },

    signature = { enabled = true },
    windows = {
      documentation = {
        border = vim.g.borderStyle,
        min_width = 15,
        max_width = 45,
        max_height = 10,
        auto_show = true,
        auto_show_delay_ms = 250,
      },
      autocomplete = {
        border = vim.g.borderStyle,
        min_width = 10, -- max_width controlled by draw-function
        max_height = 10,
        cycle = { from_top = false }, -- cycle at bottom, but not at the top
        draw = function(ctx)
          local source, client = ctx.item.source_id, ctx.item.client_id
          if client and vim.lsp.get_client_by_id(client).name == "emmet_language_server" then
            source = "emmet"
          end

          local sourceIcons = { snippets = "󰩫", buffer = "󰦨", emmet = "" }
          local icon = sourceIcons[source] or ctx.kind_icon

          return {
            {
              " " .. ctx.item.label .. " ",
              fill = true,
              hl_group = ctx.deprecated and "BlinkCmpLabelDeprecated" or "BlinkCmpLabel",
              max_width = 40,
            },
            { icon .. " ", hl_group = "BlinkCmpKind" .. ctx.kind },
          }
        end,
      },
    },
    kind_icons = {
      Text = "",
      Method = "󰊕",
      Function = "󰊕",
      Constructor = "",
      Field = "󰇽",
      Variable = "󰂡",
      Class = "󰜁",
      Interface = "",
      Module = "",
      Property = "󰜢",
      Unit = "",
      Value = "󰎠",
      Enum = "",
      Keyword = "󰌋",
      Snippet = "󰒕",
      Color = "󰏘",
      Reference = "",
      File = "",
      Folder = "󰉋",
      EnumMember = "",
      Constant = "󰏿",
      Struct = "",
      Event = "",
      Operator = "󰆕",
      TypeParameter = "󰅲",
    },
  },
  opts_extend = { "sources.completion.enabled_providers" },
}
