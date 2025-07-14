-- ~/.config/nvim/lua/core/lazy.lua
-- lazy.nvim bootstrap and configuration

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

-- Bootstrap lazy.nvim if not installed
if not vim.loop.fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "--branch=stable",
    lazyrepo,
    lazypath,
  })
end

-- Add lazy.nvim to runtime path
vim.opt.rtp:prepend(lazypath)

-- Configure lazy.nvim
require("lazy").setup({
  spec = {
    { import = "plugins" },
  },
  defaults = {
    lazy = true, -- Enable lazy loading by default
    version = false, -- Don't use version tag
  },
  install = {
    colorscheme = { "catppuccin", "habamax" },
  },
  checker = {
    enabled = true, -- Check for plugin updates
    notify = false, -- Don't notify about updates
    frequency = 3600, -- Check every hour
  },
  change_detection = {
    enabled = true,
    notify = false,
  },
  performance = {
    cache = {
      enabled = true,
    },
    reset_packpath = true,
    rtp = {
      -- Disable some built-in plugins for better performance
      disabled_plugins = {
        "gzip",
        "matchit",
        "matchparen",
        "netrwPlugin",
        "tarPlugin",
        "tohtml",
        "tutor",
        "zipPlugin",
      },
    },
  },
  ui = {
    size = { width = 0.8, height = 0.8 },
    border = "rounded",
    backdrop = 60,
  },
  dev = {
    path = "~/projects", -- Path for local development
    patterns = {}, -- For local plugin development
    fallback = false,
  },
})

-- Lazy keymaps
vim.keymap.set("n", "<leader>l", "<cmd>Lazy<cr>", { desc = "[L]azy plugin manager" })

-- Measure startup time if in debug mode
if vim.env.NVIM_DEBUG then
  require("core.utils").measure_startup_time()
end
