-- ~/.config/nvim/lua/core/options.lua
-- Optimized Neovim settings combining performance with modern features

local opt = vim.opt
local g = vim.g

-- =============================================================================
-- LEADER KEYS
-- =============================================================================
g.mapleader = " "
g.maplocalleader = " "

-- =============================================================================
-- PERFORMANCE OPTIMIZATIONS
-- =============================================================================
opt.updatetime = 200       -- Faster completion (was 250 default)
opt.timeoutlen = 500       -- Faster which-key (balanced)
opt.lazyredraw = false     -- Don't redraw during macros (better performance)
opt.undolevels = 1000      -- Reasonable undo history (not 10000)

-- =============================================================================
-- UI & VISUAL SETTINGS
-- =============================================================================
opt.number = true
opt.relativenumber = true  -- Relative numbers for efficient navigation
opt.cursorline = true
opt.termguicolors = true
opt.background = "dark"
opt.signcolumn = "yes:1"   -- Fixed width to prevent jumping
opt.cmdheight = 1
opt.scrolloff = 4          -- Reasonable context (not too much)
opt.sidescrolloff = 8
opt.pumheight = 10
opt.pumblend = 10          -- Popup transparency
opt.winblend = 0           -- Window transparency for Hyprland
opt.laststatus = 3         -- Global statusline
opt.showmode = false       -- Hide mode (shown in statusline)
opt.showcmd = true         -- Show command in bottom right
opt.showmatch = true       -- Highlight matching brackets

-- Better visual indicators
opt.list = true
opt.listchars = {
  tab = ">>>",
  trail = "·",
  extends = "→",
  precedes = "←",
  nbsp = "␣",
}

opt.fillchars = {
  diff = "╱",
  eob = " ",            -- Hide end of buffer ~
}

-- =============================================================================
-- SEARCH SETTINGS
-- =============================================================================
opt.hlsearch = true
opt.incsearch = true
opt.ignorecase = true
opt.smartcase = true
opt.wrapscan = true
opt.inccommand = "nosplit"  -- Live preview for substitute
opt.grepformat = "%f:%l:%c:%m"
opt.grepprg = "rg --vimgrep"

-- =============================================================================
-- INDENTATION & FORMATTING
-- =============================================================================
opt.expandtab = true
opt.shiftwidth = 2
opt.tabstop = 2
opt.softtabstop = 2
opt.smartindent = true
opt.autoindent = true
opt.shiftround = true       -- Round indent to multiple of shiftwidth
opt.joinspaces = false      -- No double spaces after punctuation
opt.formatoptions = "jcroqlnt" -- Improved text formatting

-- =============================================================================
-- TEXT WRAPPING & LAYOUT
-- =============================================================================
opt.wrap = false           -- No line wrapping (as requested)
opt.linebreak = true       -- Break at word boundaries when wrapping
opt.breakindent = true     -- Preserve indentation in wrapped text

-- =============================================================================
-- WINDOW & SPLIT BEHAVIOR
-- =============================================================================
opt.splitbelow = true
opt.splitright = true
opt.splitkeep = "screen"   -- Keep layout stable during splits
opt.winminwidth = 5        -- Minimum window width

-- =============================================================================
-- FILE HANDLING
-- =============================================================================
opt.backup = false
opt.writebackup = false
opt.swapfile = false
opt.undofile = true        -- Persistent undo (keep this)
opt.undodir = vim.fn.stdpath("data") .. "/undo"
opt.autowrite = true       -- Auto-save when switching buffers
opt.confirm = true         -- Confirm before exiting modified buffer
opt.hidden = true          -- Allow hidden buffers
opt.fileencoding = "utf-8"
opt.fileformat = "unix"

-- =============================================================================
-- COMPLETION & INPUT
-- =============================================================================
opt.completeopt = { "menu", "menuone", "noselect" }
opt.shortmess:append({ W = true, I = true, c = true, C = true })
opt.wildmode = "longest:full,full"
opt.mouse = "a"
opt.clipboard = "unnamedplus"

-- =============================================================================
-- TABS & BUFFERS (Buffer-only workflow)
-- =============================================================================
opt.showtabline = 0        -- Never show tabs (buffer-only workflow)

-- =============================================================================
-- FOLDING (DISABLED as requested)
-- =============================================================================
opt.foldenable = false     -- No folding
opt.foldmethod = "manual"
opt.foldlevel = 99

-- =============================================================================
-- SEARCH & REPLACE
-- =============================================================================
opt.virtualedit = "block"  -- Allow cursor beyond text in visual block

-- =============================================================================
-- SESSION MANAGEMENT
-- =============================================================================
opt.sessionoptions = {
  "buffers",
  "curdir",
  "tabpages",
  "winsize",
  "help",
  "globals",
  "skiprtp"
}

-- =============================================================================
-- DISABLE BUILT-IN PLUGINS FOR PERFORMANCE
-- =============================================================================
local disabled_built_ins = {
  "2html_plugin",
  "getscript",
  "getscriptPlugin",
  "gzip",
  "logipat",
  "matchit",
  "tar",
  "tarPlugin",
  "rrhelper",
  "spellfile_plugin",
  "vimball",
  "vimballPlugin",
  "zip",
  "zipPlugin",
  "tutor",
  "rplugin",
  "syntax",
  "synmenu",
  "optwin",
  "compiler",
  "bugreport",
  "ftplugin",
}

for _, plugin in pairs(disabled_built_ins) do
  g["loaded_" .. plugin] = 1
end

-- =============================================================================
-- DISABLE NETRW (using snacks.explorer or oil.nvim)
-- =============================================================================
g.loaded_netrw = 1
g.loaded_netrwPlugin = 1

-- =============================================================================
-- GLOBAL SETTINGS
-- =============================================================================
g.autoformat = true        -- Enable auto-formatting
