return {
  "frankroeder/parrot.nvim",
  lazy = false,
  dependencies = { "ibhagwan/fzf-lua", "nvim-lua/plenary.nvim" },
  config = function()
    require("parrot").setup {
      providers = {
        anthropic = {
          api_key = io.open(vim.fn.expand "$HOME" .. "/anthropic_api_key.txt"):read("*all"):gsub("\n", ""),
          endpoint = "https://api.anthropic.com/v1/messages",
          topic_prompt = "Вы отвечаете только 3-4 словами, резюмируя прошедший разговор.",
          topic = {
            model = "claude-3-5-sonnet-20240620",
            params = { max_tokens = 32 },
          },
          params = {
            chat = { max_tokens = 4096 },
            command = { max_tokens = 4096 },
          },
        },
      },
      system_prompt = {
        chat = "Python3.10+ syntax, ruff formatter",
      },
      -- the prefix used for all commands
      cmd_prefix = "Prt",

      -- optional parameters for curl
      curl_params = {},

      -- The directory to store persisted state information like the
      -- current provider and the selected models
      state_dir = vim.fn.stdpath("data"):gsub("/$", "") .. "/parrot/persisted",

      -- The directory to store the chats (searched with PrtChatFinder)
      chat_dir = vim.fn.stdpath("data"):gsub("/$", "") .. "/parrot/chats",

      -- Chat user prompt prefix
      chat_user_prefix = "🗨:",

      -- llm prompt prefix
      llm_prefix = "🦜:",

      -- Explicitly confirm deletion of a chat file
      chat_confirm_delete = true,

      -- When available, call API for model selection
      online_model_selection = false,

      -- Local chat buffer shortcuts
      chat_shortcut_respond = { modes = { "n", "i", "v", "x" }, shortcut = "<C-g><C-g>" },
      chat_shortcut_delete = { modes = { "n", "i", "v", "x" }, shortcut = "<C-g>d" },
      chat_shortcut_stop = { modes = { "n", "i", "v", "x" }, shortcut = "<C-g>s" },
      chat_shortcut_new = { modes = { "n", "i", "v", "x" }, shortcut = "<C-g>c" },

      -- Option to move the cursor to the end of the file after finished respond
      chat_free_cursor = false,

      -- use prompt buftype for chats (:h prompt-buffer)
      chat_prompt_buf_type = false,

      -- Default target for  PrtChatToggle, PrtChatNew, PrtContext and the chats opened from the ChatFinder
      -- values: popup / split / vsplit / tabnew
      toggle_target = "popup",

      user_input_ui = "native",

      -- Popup window layout
      -- border: "single", "double", "rounded", "solid", "shadow", "none"
      style_popup_border = "single",

      -- margins are number of characters or lines
      style_popup_margin_bottom = 8,
      style_popup_margin_left = 1,
      style_popup_margin_right = 2,
      style_popup_margin_top = 2,
      style_popup_max_width = 160,

      command_prompt_prefix_template = "🤖 {{llm}} ~ ",
      command_auto_select_response = true,
      fzf_lua_opts = {
        ["--ansi"] = true,
        ["--sort"] = "",
        ["--info"] = "inline",
        ["--layout"] = "reverse",
        ["--preview-window"] = "nohidden:right:75%",
      },

      enable_spinner = true,
      -- Available options: "dots", "line", "star", "bouncing_bar", "bouncing_ball"
      spinner_type = "dots",
    }
  end,
}
