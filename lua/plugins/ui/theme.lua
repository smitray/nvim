-- plugins/ui/theme.lua - Catppuccin Theme Configuration

return {
	"catppuccin/nvim",
	name = "catppuccin",
	config = function()
		require("catppuccin").setup({
			flavour = "mocha",
			background = { light = "latte", dark = "mocha" },
			transparent_background = true,
			integrations = {
				noice = true,
				snacks = true,
				which_key = true,
				flash = true,
				mini = true,
				notify = true,
				treesitter = true,
				treesitter_context = true,
			},
		})
	end,
}
