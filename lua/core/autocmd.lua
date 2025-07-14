-- ~/.config/nvim/lua/core/autocmd.lua
-- Autocommand setup

local autocmd = vim.api.nvim_create_autocmd
local augroup = vim.api.nvim_create_augroup

-- General settings augroup
local general = augroup("General", { clear = true })

-- Highlight text on yank
autocmd("TextYankPost", {
  group = general,
  pattern = "*",
  callback = function()
    vim.highlight.on_yank({ higroup = "IncSearch", timeout = 200 })
  end,
})

-- Remove whitespace on save
autocmd("BufWritePre", {
  group = general,
  pattern = "*",
  command = [[%s/\s\+$//e]],
})

-- Don't auto commenting new lines
autocmd("BufEnter", {
  group = general,
  pattern = "*",
  command = "set fo-=c fo-=r fo-=o",
})

-- Restore cursor position
autocmd("BufReadPost", {
  group = general,
  callback = function()
    local mark = vim.api.nvim_buf_get_mark(0, '"')
    if mark[1] > 1 and mark[1] <= vim.api.nvim_buf_line_count(0) then
      vim.api.nvim_win_set_cursor(0, mark)
    end
  end,
})

-- Close certain filetypes with <q>
autocmd("FileType", {
  group = general,
  pattern = {
    "help",
    "man",
    "lspinfo",
    "checkhealth",
    "qf",
    "query",
    "git",
    -- 'snacks_terminal' is handled by snacks.nvim itself, no need to add here.
  },
  callback = function(event)
    vim.bo[event.buf].buflisted = false
    vim.keymap.set("n", "q", "<cmd>close<cr>", { buffer = event.buf, silent = true })
  end,
})

-- Auto resize panes when resizing nvim window
autocmd("VimResized", {
  group = general,
  pattern = "*",
  command = "tabdo wincmd =",
})

-- Check if we need to reload the file when it changed
autocmd({ "FocusGained", "TermClose", "TermLeave" }, {
  group = general,
  callback = function()
    if vim.o.buftype ~= "nofile" then
      vim.cmd("checktime")
    end
  end,
})

-- Auto-create directories when saving files
autocmd("BufWritePre", {
  group = general,
  callback = function(event)
    -- Skip if it's a remote file path (e.g., netrw, scp)
    if event.match:match("^%w%w+://") then
      return
    end
    local file = vim.loop.fs_realpath(event.match) or event.match
    vim.fn.mkdir(vim.fn.fnamemodify(file, ":p:h"), "p")
  end,
})

-- Toggle cursorline in insert mode for cleaner typing
autocmd("InsertEnter", {
  group = general,
  command = "set nocursorline",
  desc = "Disable cursorline in insert mode"
})
autocmd("InsertLeave", {
  group = general,
  command = "set cursorline",
  desc = "Enable cursorline on leaving insert mode"
})


-- File type specific settings
local filetype_settings = augroup("FileTypeSettings", { clear = true })

-- Git commit messages
autocmd("FileType", {
  group = filetype_settings,
  pattern = "gitcommit",
  callback = function()
    vim.opt_local.wrap = true
    vim.opt_local.spell = true
  end,
})

-- Markdown files
autocmd("FileType", {
  group = filetype_settings,
  pattern = { "markdown", "text" },
  callback = function()
    vim.opt_local.wrap = true
    vim.opt_local.spell = true
    vim.opt_local.conceallevel = 2
  end,
})

-- JSON files
autocmd("FileType", {
  group = filetype_settings,
  pattern = "json",
  callback = function()
    vim.opt_local.conceallevel = 0
  end,
})

-- NO LONGER PRESENT: The 'Terminal' augroup and its autocmds
-- have been removed as snacks.nvim now handles these concerns.

-- Export utility functions (assuming core.utils is in the same directory)
local M = require("core.utils")
return M
