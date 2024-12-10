return {
  'neovim/nvim-lspconfig',
  event = { 'BufReadPre', 'BufNewFile' },
  config = function()
    local lspconfig = require 'lspconfig'

    local function setup_server(server, config)
      if not config then
        return
      end

      if type(config) ~= 'table' then
        config = {}
      end

      config = vim.tbl_deep_extend('force', {
        on_attach = function(client, bufnr)
          local keymap = vim.keymap.set
          keymap('n', 'gd', '<cmd>Lspsaga goto_definition<CR>', { buffer = bufnr })
          keymap('n', 'K', '<cmd>Lspsaga hover_doc<CR>', { buffer = bufnr })
          keymap('n', 'gf', '<cmd>Lspsaga finder<CR>', { buffer = bufnr })
          keymap('n', '<leader>ca', '<cmd>Lspsaga code_action<CR>', { buffer = bufnr })
          keymap('n', '<leader>lr', '<cmd>Lspsaga rename<CR>', { buffer = bufnr })
        end,
        capabilities = require('blink.cmp').get_lsp_capabilities(config.capabilities),
      }, config)

      lspconfig[server].setup(config)
    end

    local servers = {
      'html',
      'cssls',
      'lua_ls',
      'bashls',
      'taplo',
      'biome',
      'yamlls',
      'dockerls',
      'jqls',
    }

    for _, server in ipairs(servers) do
      setup_server(server, {})
    end

    -- Настройка Lua LSP
    setup_server('lua_ls', {
      settings = {
        Lua = {
          runtime = { version = 'LuaJIT' },
          diagnostics = { globals = { 'vim' } },
          workspace = {
            library = vim.api.nvim_get_runtime_file('', true),
            checkThirdParty = false,
          },
          telemetry = { enable = false },
        },
      },
    })

    -- Настройка Ruff (нового)
    setup_server('ruff', {
      settings = {
        organizeImports = true,
        fixAll = true,
      },
    })

    -- Настройка базового Python LSP
    setup_server('basedpyright', {
      settings = {
        basedpyright = {
          analysis = {
            typeCheckingMode = 'basic',
            diagnosticMode = 'openFilesOnly',
            useLibraryCodeForTypes = true,
            reportMissingImports = true,
            reportUndefinedVariable = true,
          },
        },
      },
    })

    local function show_line_diagnostics()
      local opts = {
        focusable = false,
        close_events = { 'BufLeave', 'CursorMoved', 'InsertEnter', 'FocusLost' },
        border = 'rounded',
        source = 'always',
        prefix = ' ',
      }
      vim.diagnostic.open_float(nil, opts)
    end

    vim.api.nvim_create_autocmd('CursorHold', {
      callback = function()
        show_line_diagnostics()
      end,
    })
  end,
}
