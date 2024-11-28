local function get_plugin_opts(plugin)
  local lazy_config_avail, lazy_config = pcall(require, "lazy.core.config")
  local lazy_plugin_avail, lazy_plugin = pcall(require, "lazy.core.plugin")
  local opts = {}
  if lazy_config_avail and lazy_plugin_avail then
    local spec = lazy_config.spec.plugins[plugin]
    if spec then
      opts = lazy_plugin.values(spec, "opts")
    end
  end
  return opts
end

return {
  "hrsh7th/nvim-cmp",
  enabled = false,
  opts = function()
    local config = require "nvchad.configs.cmp"
    local cmp = require "cmp"
    local lspkind_loaded, lspkind = pcall(require, "lspkind")

    config.formatting = {
      fields = { "kind", "abbr", "menu" },
      format = (lspkind_loaded and lspkind.cmp_format(get_plugin_opts "lspkind.nvim")) or nil,
    }
    config.mapping = {
      ["<Tab>"] = cmp.config.disable,
      ["<S-Tab>"] = cmp.config.disable,

      ["<C-j>"] = cmp.mapping.select_next_item(),
      ["<C-k>"] = cmp.mapping.select_prev_item(),

      ["<C-d>"] = cmp.mapping.scroll_docs(-4),
      ["<C-f>"] = cmp.mapping.scroll_docs(4),
      ["<C-Space>"] = cmp.mapping.complete(),
      ["<C-e>"] = cmp.mapping.close(),
      ["<CR>"] = cmp.mapping.confirm {
        behavior = cmp.ConfirmBehavior.Replace,
        select = true,
      },
    }

    return config
  end,
}
