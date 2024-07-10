return {
  "nvim-neotest/neotest",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-treesitter/nvim-treesitter",
    "antoinemadec/FixCursorHold.nvim",
    "nvim-neotest/neotest-python",
    "nvim-neotest/nvim-nio"
  },
  config = function()
    require("neotest").setup({
      adapters = {
        require("neotest-python")({
          dap = { justMyCode = false },
          args = { "--verbose" },
          runner = "pytest",
        }),
      },
      discovery = {
        enabled = true,
      },
      output = {
        open_on_run = true,
      },
      summary = {
        mappings = {
          attach = "a",
          expand = "l",
          expand_all = "L",
          jumpto = "gf",
          output = "o",
          run = "r",
          short = "O",
          stop = "u",
        },
      },
    })

    -- Существующие клавиатурные сокращения
    vim.keymap.set("n", "<leader>tt", function()
      require("neotest").run.run()
    end, { desc = "Run nearest test" })

    vim.keymap.set("n", "<leader>tf", function()
      require("neotest").run.run(vim.fn.expand("%"))
    end, { desc = "Run current file" })

    vim.keymap.set("n", "<leader>ts", function()
      require("neotest").summary.toggle()
    end, { desc = "Toggle test summary" })

    vim.keymap.set("n", "<leader>tl", function()
      require("neotest").run.run_last()
    end, { desc = "Run last test" })

    -- Новые клавиатурные сокращения для просмотра вывода и навигации по ошибкам
    vim.keymap.set("n", "<leader>to", function()
      require("neotest").output.open({ enter = true })
    end, { desc = "Open test output" })

    vim.keymap.set("n", "<leader>tO", function()
      require("neotest").output_panel.toggle()
    end, { desc = "Toggle output panel" })

    vim.keymap.set("n", "[t", function()
      require("neotest").jump.prev({ status = "failed" })
    end, { desc = "Jump to previous failed test" })

    vim.keymap.set("n", "]t", function()
      require("neotest").jump.next({ status = "failed" })
    end, { desc = "Jump to next failed test" })
  end,
}
