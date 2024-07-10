-- [[ Setting options ]]

vim.opt.number = true
vim.opt.relativenumber = true

-- Enable mouse mode, can be useful for resizing splits for example!
vim.opt.mouse = 'a'

-- Don't show the mode, since it's already in the status line
vim.opt.showmode = false

-- Sync clipboard between OS and Neovim.
--  Remove this option if you want your OS clipboard to remain independent.
--  See `:help 'clipboard'`
vim.opt.clipboard = 'unnamedplus'

-- Enable break indent
vim.opt.breakindent = true

-- Save undo history
vim.opt.undofile = true

-- Case-insensitive searching UNLESS \C or one or more capital letters in the search term
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- Keep signcolumn on by default
vim.opt.signcolumn = 'yes'

-- Decrease update time
vim.opt.updatetime = 250

-- Decrease mapped sequence wait time
-- Displays which-key popup sooner
vim.opt.timeoutlen = 300

-- Configure how new splits should be opened
vim.opt.splitright = true
vim.opt.splitbelow = true

-- Sets how neovim will display certain whitespace characters in the editor.
--  See `:help 'list'`
--  and `:help 'listchars'`
vim.opt.list = true
vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }

-- Preview substitutions live, as you type!
vim.opt.inccommand = 'split'

-- Show which line your cursor is on
vim.opt.cursorline = true

-- Minimal number of screen lines to keep above and below the cursor.
vim.opt.scrolloff = 8

-- Colum lina
vim.opt.colorcolumn = '80'

vim.opt.guicursor = {
  'n-v-c:block',                                  -- Normal, visual, command-line: block cursor
  'i-ci-ve:ver25',                                -- Insert, command-line insert, visual-exclude: vertical bar cursor with 25% width
  'r-cr:hor20',                                   -- Replace, command-line replace: horizontal bar cursor with 20% height
  'o:hor50',                                      -- Operator-pending: horizontal bar cursor with 50% height
  'a:blinkwait700-blinkoff400-blinkon250',        -- All modes: blinking settings
  'sm:block-blinkwait175-blinkoff150-blinkon175', -- Showmatch: block cursor with specific blinking settings
}
