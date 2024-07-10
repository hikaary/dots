function CHECK_BACK_SPACE()
  local col = vim.fn.col('.') - 1
  return col == 0 or vim.fn.getline('.'):sub(col, col):match('%s') ~= nil
end

return {
  {
    'neoclide/coc.nvim',
    branch = 'release',
    config = function()
      vim.g.coc_global_extensions = {
        'coc-json',
        'coc-tsserver',
        'coc-pyright',
        'coc-html',
        'coc-css',
        'coc-lua',
        'coc-prettier',
        'coc-eslint',
        '@yaegassy/coc-ruff',
        'coc-sh',
        'coc-toml',
      }

      -- Настройки для интеграции
      vim.g.coc_start_at_startup = 1
      vim.g.coc_snippet_next = '<tab>'

      -- Маппинги
      local opts = { silent = true, noremap = true, expr = true, replace_keycodes = false }

      vim.api.nvim_set_keymap('i', '<cr>',
        [[pumvisible() ? coc#_select_confirm() : "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"]],
        opts
      )

      vim.keymap.set(
        'i',
        '<TAB>',
        'coc#pum#visible() ? coc#pum#next(1) : v:lua.CHECK_BACK_SPACE() ? "<Tab>" : coc#refresh()',
        opts
      )
      vim.keymap.set('i', '<S-TAB>', [[coc#pum#visible() ? coc#pum#prev(1) : "\<C-h>"]], opts)


      vim.keymap.set('i', '<c-space>', 'coc#refresh()', { silent = true, expr = true })

      vim.keymap.set('n', 'gd', '<Plug>(coc-definition)', { silent = true })
      vim.keymap.set('n', 'gy', '<Plug>(coc-type-definition)', { silent = true })
      vim.keymap.set('n', 'gi', '<Plug>(coc-implementation)', { silent = true })
      vim.keymap.set('n', 'gr', '<Plug>(coc-references)', { silent = true })
      vim.keymap.set('n', '<leader>ca', '<Plug>(coc-codeaction)', { silent = true })
      vim.keymap.set(
        'n',
        'K',
        ':call CocActionAsync("doHover")<CR>',
        { silent = true, noremap = true }
      )
      vim.keymap.set('n', '<C-t>', '<C-o>', { silent = true, noremap = true })

      local coc_settings = {
        ['coc.preferences.maxFileSize'] = 1048576,

        ['suggest.noselect'] = true,
        ['suggest.enablePreselect'] = false,
        ['suggest.enablePreview'] = true,
        ['suggest.floatEnable'] = true,
        ['suggest.maxCompleteItemCount'] = 50,
        ['suggest.snippetIndicator'] = '►',

        ['diagnostic.errorSign'] = '✘',
        ['diagnostic.warningSign'] = '⚠',
        ['diagnostic.infoSign'] = 'ℹ',
        ['diagnostic.hintSign'] = '➤',
        ['diagnostic.virtualText'] = true,
        ['diagnostic.virtualTextCurrentLineOnly'] = false,
        ['diagnostic.messageTarget'] = 'float',
        ['diagnostic.checkCurrentLine'] = true,

        ['python.globalModuleInstallation'] = true,
        ['python.linting.enabled'] = true,
        ['python.linting.pylintEnabled'] = false,
        ['python.linting.flake8Enabled'] = false,
        ['python.linting.ruffEnabled'] = true,
        ['python.formatting.provider'] = 'ruff',
        ['python.linting.mypyEnabled'] = false,

        ['pyright.inlayHints.functionReturnTypes'] = false,
        ['pyright.inlayHints.variableTypes'] = false,
        ['pyright.inlayHints.parameterTypes'] = false,
        ['pyright.disableOrganizeImports'] = true,
        ["pyright.inlayHints.strictParameterNoneValue"] = true,
        ["pyright.inlayHints.reportMissingModuleSource"] = false,
        ["pyright.inlayHints.reportMissingImports"] = true,
        ["pyright.inlayHints.reportUndefinedVariable"] = true,
        ["pyright.inlayHints.reportUnboundVariable"] = true,

        ['ruff.enable'] = true,
        ['ruff.nativeServer'] = true,
        ['ruff.useDetectRuffCommand'] = true,
        ['ruff.autoFixOnSave'] = true,
        ['ruff.nativeBinaryPath'] = '',
        ['ruff.organizeImports'] = true,
        ['ruff.fixAll'] = true,
        ['ruff.args'] = '--select=F401',

        ['lua.enable'] = true,
        ['lua.format.enable'] = true,
        ['Lua.completion.callSnippet'] = 'Replace',
        ['Lua.workspace.checkThirdParty'] = false,
        ['Lua.workspace.library'] = {
          [vim.fn.expand('$VIMRUNTIME/lua')] = true,
          [vim.fn.stdpath('config') .. '/lua'] = true,
        },

        ['languageserver'] = {
          ['bash'] = {
            ['command'] = 'bash-language-server',
            ['args'] = { 'start' },
            ['filetypes'] = { 'sh', 'bash' },
            ['ignoredRootPaths'] = { '~' },
          },
        },

        ['json.format.enable'] = true,
        ['json.schemas'] = {},

        ['toml.formatter.reorderKeys'] = true,

        ['suggest.completionItemKindLabels'] = {
          ['class'] = '📦',
          ['color'] = '🎨',
          ['constant'] = '🔒',
          ['constructor'] = '🔧',
          ['enum'] = '🔢',
          ['enumMember'] = '🔢',
          ['event'] = '🎉',
          ['field'] = '🏷️',
          ['file'] = '📄',
          ['folder'] = '📁',
          ['function'] = '🛠️',
          ['interface'] = '🔌',
          ['keyword'] = '🔑',
          ['method'] = '🛠️',
          ['module'] = '📦',
          ['operator'] = '➕',
          ['property'] = '🏷️',
          ['reference'] = '📎',
          ['snippet'] = '✂️',
          ['struct'] = '🏗️',
          ['text'] = '📝',
          ['typeParameter'] = '🔧',
          ['unit'] = '🔬',
          ['value'] = '💯',
          ['variable'] = '🔧',
        },
        ['suggest.floatConfig'] = {
          ['border'] = true,
          ['rounded'] = true,
          ['borderhighlight'] = 'FloatBorder',
          ['shadow'] = false,
          ['bordersize'] = 1,
        },
      }

      -- Запись настроек в файл
      local coc_settings_path = vim.fn.stdpath 'config' .. '/coc-settings.json'
      local coc_settings_file = io.open(coc_settings_path, 'w')
      if coc_settings_file then
        coc_settings_file:write(vim.fn.json_encode(coc_settings))
        coc_settings_file:close()
      end

      -- Функция для форматирования и организации импортов
      local function format_and_organize_imports()
        vim.fn.CocAction 'format'
        if vim.bo.filetype == 'python' then
          vim.fn.CocAction('runCommand', 'ruff.executeAutofix')
        end
      end

      -- Автокоманда для форматирования и организации импортов при сохранении
      vim.api.nvim_create_autocmd('BufWritePre', {
        pattern = { '*.py', '*.sh', '*.bash', '*.json', '*.toml', '*.lua' },
        callback = function()
          format_and_organize_imports()
        end,
      })
    end,
  },
}
