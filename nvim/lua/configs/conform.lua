local slow_format_filetypes = {}
require("conform").setup {
  formatters_by_ft = {
    css = { "prettierd", "prettier" },
    toml = { "taplo" },
    lua = { "stylua" },
    typst = { "prettypst_formatter" },
    json = { "fixjson" },
  },
  formatters = {
    prettypst_formatter = {
      command = "prettypst",
      args = { "--use-std-in", "--use-std-out" },
      stdin = true,
      cwd = require("conform.util").root_file { ".editorconfig", "prettypst.toml" },
    },
  },

  format_on_save = function(bufnr)
    -- Disable with a global or buffer-local variable
    if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
      return
    end

    if slow_format_filetypes[vim.bo[bufnr].filetype] then
      return
    end

    local function on_format(err)
      if err and err:match "timeout$" then
        slow_format_filetypes[vim.bo[bufnr].filetype] = true
      end
    end

    return {
      timeout_ms = 5000,
      async = false,
      lsp_fallback = true,
    }, on_format
  end,

  format_after_save = function(bufnr)
    if not slow_format_filetypes[vim.bo[bufnr].filetype] then
      return
    end
    return { lsp_fallback = true }
  end,
}
