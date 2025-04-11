-- Main entry file for Neovim configuration
-- ~/.config/nvim/init.lua

-- Measure startup time (toggle on/off)
local track_startup_time = true
if track_startup_time then
	vim.g.startuptime = vim.loop.hrtime()
end

-- Set leader key early
vim.g.mapleader = " "  -- Space as leader key
vim.g.maplocalleader = ","

-- Load core configurations
require("core.options")     -- General settings
require("core.globalfn")
require("core.keymaps")     -- Keybindings
require("core.autocmds") -- Autocommands

-- Load plugin manager (lazy.nvim)
require("core.lazy")

-- Measure and print startup time
if track_startup_time then
	local elapsed = (vim.loop.hrtime() - vim.g.startuptime) / 1e6  -- Convert to milliseconds
	vim.notify("Neovim loaded in " .. string.format("%.2f", elapsed) .. "ms", vim.log.levels.INFO)
end

vim.cmd.colorscheme "catppuccin"
