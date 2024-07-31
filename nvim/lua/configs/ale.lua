vim.g.ale_enabled = 1
vim.g.ale_linters_explicit = 1
vim.g.ale_use_neovim_diagnostics_api = 1
vim.g.ale_fix_on_save = 1

vim.g.ale_linters = {
  python = { "ruff", "mypy" },
}
vim.g.ale_fixers = {
  python = { "ruff_format", "ruff" },
}

vim.g.ale_python_mypy_use_global = 0
vim.g.ale_python_mypy_auto_pipenv = 1
vim.g.ale_python_mypy_auto_poetry = 1

vim.g.ale_sign_error = "E"
vim.g.ale_sign_warning = "W"
vim.g.ale_set_highlights = 1
vim.g.ale_set_signs = 1

vim.g.ale_python_ruff_options = "--config ~/.config/nvim/ruff.toml"

--   local venv_path = vim.env.VIRTUAL_ENV
--   if not venv_path then
--     callback(tool_name)
--     return
--   end
--   local tool_path = venv_path .. "/bin/" .. tool_name
--   if vim.fn.executable(tool_path) == 1 then
--     callback(tool_path)
--   else
--     local handle
--     local stdout = vim.loop.new_pipe(false)
--     local stderr = vim.loop.new_pipe(false)
--     handle = vim.loop.spawn("pip", {
--       args = { "install", tool_name },
--       stdio = { nil, stdout, stderr },
--     }, function(code, _)
--       stdout:close()
--       stderr:close()
--       handle:close()
--       vim.schedule(function()
--         if code ~= 0 then
--           vim.notify("Failed to install " .. tool_name .. " in the virtual environment", vim.log.levels.ERROR)
--           callback(tool_name)
--         else
--           callback(tool_path)
--           vim.cmd "ALEToggle"
--           vim.cmd "ALEToggle"
--         end
--       end)
--     end)
--     vim.loop.read_start(stdout, function(err, _)
--       if err then
--         vim.schedule(function()
--           vim.notify("Error: " .. err, vim.log.levels.ERROR)
--         end)
--       end
--     end)
--     vim.loop.read_start(stderr, function(err, _)
--       if err then
--         vim.schedule(function()
--           vim.notify("Error: " .. err, vim.log.levels.ERROR)
--         end)
--       end
--     end)
--   end
-- end
