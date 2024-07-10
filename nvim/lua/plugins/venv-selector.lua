return {
  {
    'AckslD/swenv.nvim',
    dependencies = { 'nvim-lua/plenary.nvim' },
    config = function()
      require('swenv').setup {
        venvs_path = vim.fn.expand '~/.cache/pypoetry/virtualenvs/',
        post_set_venv = function()
          vim.cmd 'CocRestart'
        end,
      }

      -- Функция для автоматического выбора venv из pyproject.toml
      local function auto_select_venv()
        local pyproject_path = vim.fn.findfile('pyproject.toml', vim.fn.getcwd() .. ';')
        if pyproject_path ~= '' then
          local pyproject_content = vim.fn.readfile(pyproject_path)
          for _, line in ipairs(pyproject_content) do
            if line:match '^name%s*=%s*"(.+)"' then
              local venv_name = line:match '^name%s*=%s*"(.+)"'
              require('swenv.api').set_venv(venv_name)
              break
            end
          end
        else
          require('swenv.api').auto_venv()
        end
      end

      -- Автокоманда для выбора venv при открытии Python файла
      vim.api.nvim_create_autocmd('FileType', {
        pattern = 'python',
        callback = function()
          vim.schedule(auto_select_venv)
        end,
      })
    end,
  },
}
-- return {
--
--   {
--     enabled = false,
--     'linux-cultist/venv-selector.nvim',
--     branch = 'regexp',
--     dependencies = { 'neovim/nvim-lspconfig', 'nvim-telescope/telescope.nvim' },
--     opts = {
--       poetry_path = '~/.cache/pypoetry/virtualenvs/',
--       auto_refresh = true,
--       notify_user_on_activate = true,
--     },
--
--     config = function()
--       require('venv-selector').setup()
--       vim.api.nvim_create_autocmd('VimEnter', {
--         desc = 'Auto select virtualenv Nvim open',
--         pattern = '*',
--         callback = function()
--           local venv = vim.fn.findfile('pyproject.toml', vim.fn.getcwd() .. ';')
--           if venv ~= '' then
--             require('venv-selector').retrieve_from_cache()
--           end
--         end,
--         once = true,
--       })
--
--       vim.api.nvim_create_autocmd('User', {
--         pattern = 'VenvSelectActivated',
--         callback = function()
--           vim.cmd 'COQstop'
--           vim.defer_fn(function()
--             vim.cmd 'COQnow -s'
--           end, 100)
--         end,
--       })
--     end,
--     event = 'VeryLazy',
--   },
-- }
--
