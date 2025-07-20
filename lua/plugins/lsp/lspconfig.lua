-- lua/plugins/lsp/lspconfig.lua

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

		-- Diagnostic signs
		for type, icon in pairs(icons.diagnostics) do
			local hl = "DiagnosticSign" .. type
			if hl:match("^[%w_]+$") then
				vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
			end
		end

		vim.diagnostic.config({
			virtual_text = { spacing = 4, source = "if_many", prefix = "●" },
			float = { border = "rounded", source = true },
			signs = true,
			underline = true,
			severity_sort = true,
		})

		local handlers = require("vim.lsp.handlers")
		handlers["textDocument/hover"] = function(_, result, ctx, config)
			config = vim.tbl_deep_extend("force", config or {}, { border = "rounded" })
			return handlers.hover(_, result, ctx, config)
		end
		handlers["textDocument/signatureHelp"] = function(_, result, ctx, config)
			config = vim.tbl_deep_extend("force", config or {}, { border = "rounded" })
			return handlers.signature_help(_, result, ctx, config)
		end

		local mason_lspconfig = require("mason-lspconfig")
		mason_lspconfig.setup({
			ensure_installed = {
				"lua_ls",
				"vtsls",
				"eslint",
				"biome",
				"html",
				"cssls",
				"jsonls",
				"yamlls",
				"bashls",
				"marksman",
				"svelte",
				"vue_ls",
				"astro",
				"emmet_ls",
				"taplo",
				"pyright",
				"ruff",
			},
			automatic_installation = true,
		})

		local installed_servers = mason_lspconfig.get_installed_servers()
		for _, server in ipairs(installed_servers) do
			local ok, server_opts = pcall(require, "plugins.lsp.servers." .. server)
			local merged_opts = vim.tbl_deep_extend("force", {
				on_attach = opts.on_attach,
				capabilities = opts.capabilities,
			}, ok and server_opts or {})

			if lspconfig[server] and type(lspconfig[server].setup) == "function" then
				lspconfig[server].setup(merged_opts)
			else
				vim.notify("LSP server not supported by lspconfig: " .. server, vim.log.levels.WARN)
			end
		end
	end,
}
