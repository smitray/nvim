-- core/keymaps.lua - Custom Keybindings

-- map is globally available, no need to define
-- local map = require("core.utils").map

-- =============================================
-- Escape from Insert Mode
-- =============================================
map("i", "jj", "<ESC>")
map("i", "jk", "<ESC>")
-- Select all text
map("n", "<C-a>", "ggVG")

-- =============================================
-- File Operations
-- =============================================
map("n", "<leader>w", ":w<CR>", { desc = "[w]rite file" })
map("n", "<leader>q", ":q<CR>", { desc = "[q]uit" })
map("n", "<leader>Q", ":q!<CR>", { desc = "[Q]uit without writing" })
map("n", "<leader>wq", ":wq<CR>", { desc = "[w]rite and [q]uit" })
map("n", "<leader>wa", ":wa<CR>", { desc = "[w]rite [a]ll buffers" })

-- =============================================
-- Buffer Management
-- =============================================
map("n", "<leader>bn", ":bnext<CR>", { desc = "[b]uffer [n]ext" })
map("n", "<leader>bp", ":bprevious<CR>", { desc = "[b]uffer [p]revious" })
map("n", "<leader>bd", ":bdelete<CR>", { desc = "[b]uffer [d]elete" })
map("n", "<leader>ba", "<cmd>lua require('core.utils').HandleBuffer()<CR>", { desc = "[b]uffer [a]dd with new file name" })
map("n", "<leader>bo", ":%bd|e#|bd#<CR>", { desc = "[b]uffer [o]thers close" })
map("n", "<leader>bl", ":lua Snacks.picker.buffers()<CR>", { desc = "[b]uffer [l]ist" })
map("n", "<leader>bc", ":%bd<CR>", { desc = "[b]uffer [c]lose all" })

-- =============================================
-- Navigation & Motion
-- =============================================
map("n", "<C-d>", "<C-d>zz", { desc = "scroll down and center" })
map("n", "<C-u>", "<C-u>zz", { desc = "scroll up and center" })
map("n", "n", "nzzzv", { desc = "search next match and center" })
map("n", "N", "Nzzzv", { desc = "search previous match and center" })
map("n", "*", "*zzv", { desc = "search current word and center" })
map("n", "#", "#zzv", { desc = "search backwards word and center" })
map("n", "g*", "g*zz", { desc = "search partial match and center" })
map("n", "g#", "g#zz", { desc = "search backwards partial match and center" })

-- Window splitting
map("n", "<leader>sv", ":vsplit<CR>", { desc = "[s]plit [v]ertical" })
map("n", "<leader>sh", ":split<CR>", { desc = "[s]plit [h]orizontal" })

-- Resize windows (keeping arrow keys for less frequent operations)
map("n", "<C-Up>", ":resize +2<CR>", { desc = "increase window height" })
map("n", "<C-Down>", ":resize -2<CR>", { desc = "decrease window height" })
map("n", "<C-Left>", ":vertical resize -2<CR>", { desc = "decrease window width" })
map("n", "<C-Right>", ":vertical resize +2<CR>", { desc = "increase window width" })

-- =============================================
-- Text Manipulation
-- =============================================
map("n", "<leader>db", "yyp", { desc = "[d]uplicate line [b]elow" })
map("n", "<leader>da", "yyP", { desc = "[d]uplicate line [a]bove" })
map("n", "<leader>=", "gg=G", { desc = "auto-indent entire file" })
map("v", "=", "=", { desc = "auto-indent selected lines" })

-- Move lines up and down
map("v", "J", ":m '>+1<CR>gv=gv", { desc = "move line down" })
map("v", "K", ":m '<-2<CR>gv=gv", { desc = "move line up" })
-- Also add normal mode line moving
map("n", "<A-j>", ":m .+1<CR>==", { desc = "move line down" })
map("n", "<A-k>", ":m .-2<CR>==", { desc = "move line up" })


-- Paste without yanking
-- The "_dP sequence:
-- "_ specifies the black hole register (deleted text goes nowhere)
-- d deletes the selected text (without yanking)
-- P pastes the previously yanked text in place of the selection
map("v", "p", '"_dP', { desc = "[p]aste without losing clipboard" })
map("v", "P", '"_dP', { desc = "[p]aste backwards without losing clipboard" })

-- Block text movement in visual mode
map("v", "J", ":m '>+1<CR>gv=gv", { desc = "move selected block down" })
map("v", "K", ":m '<-2<CR>gv=gv", { desc = "move selected block up" })

-- Stay in visual mode when indenting
map("v", ">", ">gv", { desc = "indent right and stay in visual mode" })
map("v", "<", "<gv", { desc = "indent left and stay in visual mode" })

-- =============================================
-- Search & Replace
-- =============================================
map("n", "<leader>rw", ":%s/<C-r><C-w>//gI<Left><Left><Left>", { desc = "[r]eplace [w]ord under cursor" })
map("v", "<leader>rs", '"hy:%s/<C-r>h//g<Left><Left>', { desc = "[r]eplace [s]election" })
map("n", "<Esc>", ":noh<CR>", { desc = "clear search highlighting" })

-- =============================================
-- Miscellaneous
-- =============================================
map("n", "<leader>tw", ":set wrap!<CR>", { desc = "[t]oggle [w]ord wrap" })
map("n", "<leader>ts", ":set spell!<CR>", { desc = "[t]oggle [s]pell check" })
map("n", "<leader>tn", ":set number!<CR>", { desc = "[t]oggle [n]umbers" })
map("n", "<leader>tr", ":set relativenumber!<CR>", { desc = "[t]oggle [r]elative numbers" })
map("n", "<leader>tc", ":ColorizerToggle<CR>", { desc = "[t]oggle [c]olorizer" })

-- Execute current file
map("n", "<leader>xf", ":!chmod +x %<CR>", { desc = "[x]make [f]ile executable" })
map("n", "<leader>xr", ":!%:p<CR>", { desc = "[x]execute [r]un file" })

-- Terminal operations
map("n", "<leader>tt", ":terminal<CR>", { desc = "[t]erminal open" })
map("t", "<Esc><Esc>", "<C-\\><C-n>", { desc = "terminal exit mode" })
map("t", "<leader>tq", "<C-\\><C-n>:q<CR>", { desc = "terminal exit and close" })
map("n", "<leader>tq", ":bdelete!<CR>", { desc = "force close terminal buffer" })
-- Removing window navigation from terminal mode since you're using vim-tmux-navigator

-- File explorer
map("n", "<leader>e", ":lua Snacks.explorer()<CR>", { desc = "Toggle file explorer" })

-- Better join lines (keeps cursor position)
-- The standard J joins the current line with the next line
-- This mapping (mzJ`z) sets a mark 'z', performs the join, and returns to the mark
-- This maintains your cursor position instead of moving it to the join point
map("n", "J", "mzJ`z", { desc = "join lines and keep cursor position" })

-- =============================================
-- LSP Keybindings (if LSP is available)
-- =============================================
-- These will only take effect when an LSP is attached to a buffer
-- map("n", "gd", "<cmd>lua vim.lsp.buf.definition()<CR>", { desc = "[g]oto [d]efinition" })
-- map("n", "gD", "<cmd>lua vim.lsp.buf.declaration()<CR>", { desc = "[g]oto [D]eclaration" })
-- map("n", "gr", "<cmd>lua vim.lsp.buf.references()<CR>", { desc = "[g]oto [r]eferences" })
-- map("n", "gi", "<cmd>lua vim.lsp.buf.implementation()<CR>", { desc = "[g]oto [i]mplementation" })
-- map("n", "K", "<cmd>lua vim.lsp.buf.hover()<CR>", { desc = "Show documentation" })
-- map("n", "<leader>ca", "<cmd>lua vim.lsp.buf.code_action()<CR>", { desc = "[c]ode [a]ction" })
-- map("n", "<leader>rn", "<cmd>lua vim.lsp.buf.rename()<CR>", { desc = "[r]e[n]ame" })
-- map("n", "<leader>D", "<cmd>lua vim.lsp.buf.type_definition()<CR>", { desc = "Type [D]efinition" })
-- map("n", "<leader>f", "<cmd>lua vim.lsp.buf.format({ async = true })<CR>", { desc = "[f]ormat document" })


map("n", "<leader>nm", function()
  print(require("noice").api.status.mode.get())
end, { desc = "Print Noice Mode" })
