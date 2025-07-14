-- ~/.config/nvim/lua/core/keymaps.lua
-- Global keymaps with descriptions

local map = vim.keymap.set
local opts = { silent = true, noremap = true }

-- Better up/down movement for wrapped lines
map({ "n", "x" }, "j", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })
map({ "n", "x" }, "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })

-- Window navigation handled by vim-tmux-navigator plugin
-- <C-hjkl> keymaps will be managed by vim-tmux-navigator

-- Resize window using <ctrl> arrow keys
map("n", "<C-Up>", "<cmd>resize +3<cr>", { desc = "[r]esize [u]p" })
map("n", "<C-Down>", "<cmd>resize -3<cr>", { desc = "[r]esize [d]own" })
map("n", "<C-Left>", "<cmd>vertical resize -3<cr>", { desc = "[r]esize [l]eft" })
map("n", "<C-Right>", "<cmd>vertical resize +3<cr>", { desc = "[r]esize [r]ight" })

-- Buffer navigation (no tabs)
map("n", "<S-h>", "<cmd>bprevious<cr>", { desc = "[p]rev [b]uffer" })
map("n", "<S-l>", "<cmd>bnext<cr>", { desc = "[n]ext [b]uffer" })
map("n", "<leader>bb", function() Utils.toggle_buffer() end, { desc = "[b]uffer toggle (last)" })
map("n", "<leader>bn", "<cmd>enew<cr>", { desc = "[b]uffer [n]ew" })

-- Buffer picker (will be handled by snacks.picker)
-- This keymap will be configured in plugins/files/ when snacks.nvim is set up
-- map("n", "<leader>fb", function() Snacks.picker.buffers() end, { desc = "[f]ind [b]uffers" })

-- Smart buffer management (will be handled by snacks.bufdelete)
-- These keymaps will be configured in plugins/files/ when snacks.nvim is set up
-- map("n", "<leader>bd", function() Snacks.bufdelete() end, { desc = "[b]uffer [d]elete (smart)" })
-- map("n", "<leader>bo", function() Snacks.bufdelete.other() end, { desc = "[b]uffer [o]nly (close others)" })
-- map("n", "<leader>ba", function() Snacks.bufdelete.all() end, { desc = "[b]uffer [a]ll (close all)" })

-- Clear search highlighting
map("n", "<Esc>", "<cmd>nohlsearch<cr>", { desc = "[c]lear [h]ighlight" })

-- Better indenting
map("v", "<", "<gv", opts)
map("v", ">", ">gv", opts)

-- Move lines up/down
map("n", "<A-j>", "<cmd>move .+1<cr>==", { desc = "[m]ove line [d]own" })
map("n", "<A-k>", "<cmd>move .-2<cr>==", { desc = "[m]ove line [u]p" })
map("v", "<A-j>", ":move '>+1<cr>gv=gv", { desc = "[m]ove selection [d]own" })
map("v", "<A-k>", ":move '<-2<cr>gv=gv", { desc = "[m]ove selection [u]p" })

-- Duplicate lines
map("n", "<leader>db", "yyp", { desc = "[d]uplicate line [b]elow" })
map("n", "<leader>da", "yyP", { desc = "[d]uplicate line [a]bove" })
map("v", "<leader>db", "y'>p", { desc = "[d]uplicate selection [b]elow" })
map("v", "<leader>da", "y'<P", { desc = "[d]uplicate selection [a]bove" })

-- Quick save and quit
map("n", "<leader>w", "<cmd>w<cr>", { desc = "[w]rite file" })
map("n", "<leader>q", "<cmd>q<cr>", { desc = "[q]uit" })
map("n", "<leader>Q", "<cmd>qa!<cr>", { desc = "[Q]uit all force" })
map("n", "<leader>x", "<cmd>wqa<cr>", { desc = "save and e[x]it all" })

-- Split management
map("n", "<leader>-", "<C-w>s", { desc = "[s]plit [h]orizontal" })
map("n", "<leader>|", "<C-w>v", { desc = "[s]plit [v]ertical" })
map("n", "<leader>sc", "<C-w>c", { desc = "[s]plit [c]lose" })

-- Command mode navigation
map("c", "<C-h>", "<Left>", opts)
map("c", "<C-j>", "<Down>", opts)
map("c", "<C-k>", "<Up>", opts)
map("c", "<C-l>", "<Right>", opts)

-- Insert mode navigation
map("i", "<C-h>", "<Left>", opts)
map("i", "<C-j>", "<Down>", opts)
map("i", "<C-k>", "<Up>", opts)
map("i", "<C-l>", "<Right>", opts)

-- Easy escape from insert mode
map("i", "jk", "<Esc>", { desc = "Exit insert mode" })
map("i", "jj", "<Esc>", { desc = "Exit insert mode (alt)" })

-- Text manipulation
map("n", "J", "mzJ`z", { desc = "[j]oin lines keep cursor" })
map("n", "<C-d>", "<C-d>zz", { desc = "[d]own half page center" })
map("n", "<C-u>", "<C-u>zz", { desc = "[u]p half page center" })
map("n", "n", "nzzzv", { desc = "[n]ext search center" })
map("n", "N", "Nzzzv", { desc = "[N] prev search center" })

-- Paste without losing register
map("x", "<leader>p", [["_dP]], { desc = "[p]aste keep register" })

-- Delete to void register
map({ "n", "v" }, "<leader>d", [["_d]], { desc = "[d]elete to void" })

-- Replace word under cursor
map("n", "<leader>s", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]],
  { desc = "[s]ubstitute word under cursor" })

-- Select all operations
map("n", "<C-a>", "ggVG", { desc = "Select [a]ll" })
map("n", "<leader>ya", "ggVGy<C-o>", { desc = "[y]ank [a]ll (copy)" })
map("n", "<leader>pa", "ggVGp", { desc = "[p]aste [a]ll (replace)" })

-- Make file executable
map("n", "<leader>cx", "<cmd>!chmod +x %<CR>", { desc = "[c]hmod e[x]ecutable" })

-- Terminal keymaps (vim-tmux-navigator handles <C-hjkl>)
-- Enhanced terminal exit for zsh vi-mode compatibility
map("t", "<Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })
map("t", "<C-[>", "<C-\\><C-n>", { desc = "Exit terminal mode (alt)" })
map("t", "jk", "<C-\\><C-n>", { desc = "Exit terminal mode (vi-style)" })

-- Terminal management (will be handled by snacks.terminal)
-- These keymaps will be configured in plugins/files/ when snacks.nvim is set up
-- map("n", "<leader>tt", function() Snacks.terminal() end, { desc = "[t]erminal [t]oggle" })
-- map("n", "<leader>tf", function() Snacks.terminal(nil, { win = { position = "float" } }) end, { desc = "[t]erminal [f]loat" })
-- map("n", "<leader>th", function() Snacks.terminal(nil, { win = { position = "bottom" } }) end, { desc = "[t]erminal [h]orizontal" })
-- map("n", "<leader>tv", function() Snacks.terminal(nil, { win = { position = "right" } }) end, { desc = "[t]erminal [v]ertical" })

-- Add empty lines
map("n", "gO", "<Cmd>call append(line('.') - 1, repeat([''], v:count1))<CR>",
  { desc = "Put empty line above" })
map("n", "go", "<Cmd>call append(line('.'), repeat([''], v:count1))<CR>",
  { desc = "Put empty line below" })
