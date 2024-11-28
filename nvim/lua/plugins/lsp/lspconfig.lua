return {
  "neovim/nvim-lspconfig",
  event = { "BufReadPre", "BufNewFile" },
  dependencies = {
    "hrsh7th/cmp-nvim-lsp",
  },
  config = function()
    local lspconfig = require "lspconfig"

    local function setup_server(server, config)
      if not config then
        return
      end

      if type(config) ~= "table" then
        config = {}
      end

      config = vim.tbl_deep_extend("force", {
        on_attach = function(client, bufnr)
          -- Настройка Lspsaga
          local keymap = vim.keymap.set
          keymap("n", "gd", "<cmd>Lspsaga goto_definition<CR>", { buffer = bufnr })
          keymap("n", "K", "<cmd>Lspsaga hover_doc<CR>", { buffer = bufnr })
          keymap("n", "gf", "<cmd>Lspsaga finder<CR>", { buffer = bufnr })
          keymap("n", "<leader>ca", "<cmd>Lspsaga code_action<CR>", { buffer = bufnr })
          keymap("n", "<leader>lr", "<cmd>Lspsaga rename<CR>", { buffer = bufnr })
        end,
        capabilities = require("cmp_nvim_lsp").default_capabilities(),
      }, config)

      lspconfig[server].setup(config)
    end

    -- Настройка серверов
    local servers = {
      "html",
      "cssls",
      "lua_ls",
      "bashls",
      "taplo",
      "biome",
      "yamlls",
      "dockerls",
      "jsonls",
    }

    for _, server in ipairs(servers) do
      setup_server(server, {})
    end

    -- Специфичные настройки для некоторых серверов
    setup_server("lua_ls", {
      settings = {
        Lua = {
          runtime = { version = "LuaJIT" },
          diagnostics = { globals = { "vim" } },
          workspace = {
            library = vim.api.nvim_get_runtime_file("", true),
            checkThirdParty = false,
            maxPreload = 100,
            preloadFileSize = 1000,
          },
          telemetry = { enable = false },
          completion = { callSnippet = "Replace" },
          hint = { enable = false },
        },
      },
    })

    setup_server("basedpyright", {
      settings = {
        basedpyright = {
          analysis = {
            typeCheckingMode = "basic",
            diagnosticMode = "openFilesOnly",
            useLibraryCodeForTypes = true,
            reportMissingImports = true,
            reportUndefinedVariable = true,
          },
        },
      },
    })

    setup_server("ruff_lsp", {
      init_options = {
        settings = {
          -- args = {
          --   "--config=~/.config/nvim/ruff.toml",
          -- },
        },
      },
    })

    -- Настройка автоматического показа диагностики
    local function show_line_diagnostics()
      local opts = {
        focusable = false,
        close_events = { "BufLeave", "CursorMoved", "InsertEnter", "FocusLost" },
        border = "rounded",
        source = "always",
        prefix = " ",
      }
      vim.diagnostic.open_float(nil, opts)
    end

    vim.api.nvim_create_autocmd("CursorHold", {
      callback = function()
        show_line_diagnostics()
      end,
    })
  end,
}
