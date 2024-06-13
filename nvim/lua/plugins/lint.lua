return {
  {
    "dense-analysis/ale",
    config = function()
      require "configs.lint"
    end,
    lazy = false,
  },
}
