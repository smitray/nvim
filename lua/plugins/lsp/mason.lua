-- lua/plugins/lsp/mason.lua

return {
	"williamboman/mason.nvim",
	build = ":MasonUpdate",
	dependencies = {
		"williamboman/mason-lspconfig.nvim",
		"WhoIsSethDaniel/mason-tool-installer.nvim",
		"neovim/nvim-lspconfig",
		"b0o/schemastore.nvim",
		"folke/lazydev.nvim",
	},
	config = function()
		require("mason").setup({
			ui = {
				border = "rounded",
				width = 0.8,
				height = 0.8,
			},
		})

		-- LSPs are managed in lspconfig.lua
		require("mason-tool-installer").setup({
			ensure_installed = {
				"stylua",
				"black",
				"isort",
				"prettier",
				"shfmt",
			},
			run_on_start = true,
		})
	end,
}
