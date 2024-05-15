return {
  {
    "williamboman/mason-lspconfig.nvim",
    opts = {
      ensure_installed = { "basedpyright" },
    },
  },
  {
    "williamboman/mason.nvim",
    cmd = "Mason",
    keys = { { "<leader>cm", "<cmd>Mason<cr>", desc = "Mason" } },
    build = ":MasonUpdate",
    opts = function(_, opts)
      opts.ensure_installed = {
        "stylua",
        "ruff-lsp",
        "fixjson",
        "json-lsp",
      }
      if vim.g.lazyvim_python_lsp == "basedpyright" then
        opts.ensure_installed = opts.ensure_installed or {}
        table.insert(opts.ensure_installed, "basedpyright")
      end
    end,
    config = function(_, opts)
      require("mason").setup(opts)
      local mr = require "mason-registry"
      mr:on("package:install:success", function()
        vim.defer_fn(function()
          require("lazy.core.handler.event").trigger {
            event = "FileType",
            buf = vim.api.nvim_get_current_buf(),
          }
        end, 100)
      end)
      local function ensure_installed()
        for _, tool in ipairs(opts.ensure_installed) do
          local p = mr.get_package(tool)
          if not p:is_installed() then
            p:install()
          end
        end
      end
      if mr.refresh then
        mr.refresh(ensure_installed)
      else
        ensure_installed()
      end
    end,
  },
}
