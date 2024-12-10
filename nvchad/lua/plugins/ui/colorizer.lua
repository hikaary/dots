return {
  "NvChad/nvim-colorizer.lua",
  lazy = false,
  opts = {
    filetypes = {
      "*", -- all filetypes
      "!sass", -- исключить sass
      "!scss", -- исключить scss
    },
    user_default_options = {
      RRGGBBAA = true,
      rgb_fn = true,
      hsl_fn = true,
      css = true,
      css_fn = true,
      sass = { enable = true, parsers = { "css" } },
      mode = "virtualtext",
      virtualtext = "󱓻",
    },
  },
}
