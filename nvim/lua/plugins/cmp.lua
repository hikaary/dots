return {
  "hrsh7th/nvim-cmp",
  opts = function()
    local config = require "nvchad.configs.cmp"
    -- config.sources[-1] = { name = "codeium", priority = 100 }
    return config
  end,
}
