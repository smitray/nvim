-- core/options.lua - General Neovim settings

local opt = vim.opt

-- Disable netrw (using alternative file explorers)
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- Indentation & Tabs
opt.expandtab = false       -- Use tabs instead of spaces
opt.tabstop = 4            -- Number of spaces tabs count for
opt.shiftwidth = 4         -- Number of spaces for autoindent
opt.softtabstop = 4        -- Number of spaces for <BS> and <Tab>
opt.smartindent = true     -- Enable smart indenting
opt.autoindent = true      -- Maintain indentation from previous line
opt.breakindent = true     -- Indentation for wrapped lines

-- UI Enhancements
opt.termguicolors = true   -- Enable true colors
opt.cursorline = false     -- Disable cursorline
opt.number = true          -- Show line numbers
opt.relativenumber = true  -- Relative line numbers
opt.numberwidth = 4        -- Width for line numbers
opt.signcolumn = "yes"     -- Always show the sign column
opt.wrap = false           -- Disable line wrapping
opt.scrolloff = 8          -- Keep cursor 8 lines away from edges
opt.sidescrolloff = 8      -- Keep cursor 8 columns away from edges
opt.showmode = false       -- Hide mode message (redundant)
opt.showcmd = false        -- Hide command preview
opt.ruler = false          -- Hide ruler
opt.fillchars = { eob = " " } -- Remove `~` from empty buffer lines
opt.mouse = "a"            -- Enable mouse support (comment out if you don't use mouse)
opt.laststatus = 3         -- Global statusline
opt.showtabline = 0        -- Disable tabline (using buffers instead)
opt.guifont = "monospace:h17" -- GUI font (not applicable in Kitty)
opt.title = false          -- Disable title (not needed in Kitty on Hyprland)
opt.list = true            -- Enable listchars
opt.listchars = { trail = '', tab = '', nbsp = '_', extends = '>', precedes = '<' }

-- Performance
-- opt.lazyredraw = true      -- Optimize performance by preventing redraw during macros
opt.updatetime = 100       -- Faster UI updates
opt.timeoutlen = 500       -- Reduce mapped sequence wait time

-- Backup & Undo
opt.swapfile = false       -- Disable swap files
opt.backup = false         -- Disable backup files
opt.writebackup = false    -- Prevents file overwrites
opt.undofile = true        -- Enable persistent undo
opt.undodir = vim.fn.stdpath("data") .. "/undo"

-- Search
opt.ignorecase = true      -- Ignore case in searches
opt.smartcase = true       -- Override ignorecase if search contains uppercase
opt.incsearch = true       -- Show search matches as you type
opt.hlsearch = true        -- Highlight search results

-- Clipboard
opt.clipboard = "unnamedplus" -- Use system clipboard

-- Split Window Behavior
opt.splitbelow = true      -- Split new windows below
opt.splitright = true      -- Split new windows to the right

-- File Encoding & Type Handling
opt.fileencoding = "utf-8" -- UTF-8 encoding
vim.filetype.add({
  extension = { env = "dotenv" },
  filename = { [".env"] = "dotenv", ["env"] = "dotenv" },
  pattern = { ["[jt]sconfig.*.json"] = "jsonc", ["%.env%.[%w_.-]+"] = "dotenv" },
})

-- Miscellaneous
opt.confirm = true -- Prompt before exiting unsaved files
opt.cmdheight = 1  -- Command-line height
opt.completeopt = { "menu", "menuone", "noselect" } -- Optimized completion
opt.pumheight = 10 -- Popup menu height

