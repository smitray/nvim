-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
	local lazyrepo = "https://github.com/folke/lazy.nvim.git"
	local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
	if vim.v.shell_error ~= 0 then
		vim.api.nvim_echo({
			{ "Failed to clone lazy.nvim:\n", "ErrorMsg" },
			{ out, "WarningMsg" },
			{ "\nPress any key to exit..." },
		}, true, {})
		vim.fn.getchar()
		os.exit(1)
	end
end
vim.opt.rtp:prepend(lazypath)

require('lazy').setup("plugins", {
   install = { colorscheme = { "catppuccin" } },
   ui = {
      -- a number <1 is a percentage., >1 is a fixed size
      size = { width = 0.8, height = 0.8 },
      wrap = true, -- wrap the lines in the ui
      -- The border to use for the UI window. Accepts same border values as |nvim_open_win()|.
      border = "rounded",
      title = " 󰒲  Lazy ", ---@type string only works when border is not "none"
      title_pos = "center", ---@type "center" | "left" | "right"
      -- Show pills on top of the Lazy window
      pills = true, ---@type boolean
      icons = {
         cmd        = " ",
         config     = " ",
         event      = "",
         ft         = " ",
         init       = " ",
         import     = " ",
         keys       = " ",
         lazy       = "󰒲 ",
         loaded     = "●",
         not_loaded = "○",
         plugin     = " ",
         runtime    = " ",
         require    = "󰢱 ",
         source     = " ",
         start      = "",
         task       = "✔ ",
         list       = {
            "●",
            "➜",
            "★",
            "‒",
         },
      }
   }
})
