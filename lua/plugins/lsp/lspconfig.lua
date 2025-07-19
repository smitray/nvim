-- lua/plugins/lsp/lspconfig.lua
-- Main LSP setup that loads individual server configs

return {
	"neovim/nvim-lspconfig",
	event = { "BufReadPre", "BufNewFile" },
	dependencies = {
		"williamboman/mason-lspconfig.nvim",
		"b0o/schemastore.nvim",
	},
	config = function()
		local lspconfig = require("lspconfig")
		local opts = require("core.lsp-opts")
		local icons = require("core.icons")

		-- Diagnostic setup
		for type, icon in pairs(icons.diagnostics) do
			local hl = "DiagnosticSign" .. type
			vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
		end

		vim.diagnostic.config({
			virtual_text = { spacing = 4, source = "if_many", prefix = "●" },
			float = { border = "rounded", source = true },
			signs = true,
			underline = true,
			severity_sort = true,
		})

		-- Setup servers using individual configs
		local mason_lspconfig = require("mason-lspconfig")
		local installed_servers = mason_lspconfig.get_installed_servers()

		for _, server in ipairs(installed_servers) do
			local ok, server_config = pcall(require, "plugins.lsp.servers." .. server)
			if ok then
				local setup_config = vim.tbl_deep_extend("force", {
					on_attach = opts.on_attach,
					capabilities = opts.capabilities(),
				}, server_config)
				lspconfig[server].setup(setup_config)
			else
				-- Fallback for servers without custom config
				lspconfig[server].setup({
					on_attach = opts.on_attach,
					capabilities = opts.capabilities(),
				})
			end
		end
	end,
}
