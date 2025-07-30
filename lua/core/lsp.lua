-- ~/.config/nvim/lua/core/lsp.lua
-- Core LSP configuration for Neovim 0.11+
local icons = require("core.icons")

-- Configure diagnostics for a cleaner UI
vim.diagnostic.config({
	virtual_text = false, -- Disable virtual text diagnostics
	virtual_lines = {
		enabled = true,
		-- Only show virtual line diagnostics for the current cursor line
		cursor_line_only = true,
	},
	signs = {
		text = {
			[vim.diagnostic.severity.ERROR] = icons.diagnostics.Error,
			[vim.diagnostic.severity.WARN] = icons.diagnostics.Warning,
			[vim.diagnostic.severity.HINT] = icons.diagnostics.Hint,
			[vim.diagnostic.severity.INFO] = icons.diagnostics.Information,
		},
	},
	underline = true,
	update_in_insert = false,
	severity_sort = true,
	float = {
		focusable = false,
		style = "minimal",
		border = "rounded",
		header = "",
		prefix = "",
	},
})

-- Helper to check method support (compatible with both 0.10 and 0.11+)
local function client_supports_method(client, method, bufnr)
	if vim.fn.has("nvim-0.11") == 1 then
		return client:supports_method(method, bufnr)
	else
		return client.supports_method and client.supports_method(method, { bufnr = bufnr })
	end
end

-- Setup on LspAttach
vim.api.nvim_create_autocmd("LspAttach", {
	group = vim.api.nvim_create_augroup("lsp-attach-group", { clear = true }),
	callback = function(event)
		local client = vim.lsp.get_client_by_id(event.data.client_id)
		local bufnr = event.buf

		-- Ensure client exists
		if not client then
			return
		end

		local map = function(keys, func, desc, mode)
			mode = mode or "n"
			vim.keymap.set(mode, keys, func, { buffer = bufnr, desc = "LSP: " .. desc })
		end

		-- Core navigation keymaps
		map("K", vim.lsp.buf.hover, "Hover Documentation")
		map("gD", vim.lsp.buf.declaration, "Goto Declaration")
		map("gd", vim.lsp.buf.definition, "Goto Definition")
		map("gi", vim.lsp.buf.implementation, "Goto Implementation")
		map("gr", vim.lsp.buf.references, "Goto References")
		map("gs", vim.lsp.buf.signature_help, "Signature Help")
		map("<leader>v", "<cmd>vsplit | lua vim.lsp.buf.definition()<cr>", "Goto Definition in Vertical Split")

		-- Diagnostic navigation
		map("gl", vim.diagnostic.open_float, "Open Diagnostic Float")
		map("[d", function()
			require("trouble").previous({ skip_groups = true, jump = true })
		end, "Previous Diagnostic")
		map("]d", function()
			require("trouble").next({ skip_groups = true, jump = true })
		end, "Next Diagnostic")

		-- Check if which-key is available for better keymap organization
		local wk_ok, wk = pcall(require, "which-key")
		if wk_ok then
			wk.add({
				{
					"<leader>la",
					vim.lsp.buf.code_action,
					desc = "Code Action",
					buffer = bufnr,
				},
				{
					"<leader>lA",
					vim.lsp.buf.code_action,
					desc = "Range Code Actions",
					buffer = bufnr,
					mode = "v",
				},
				{
					"<leader>ls",
					vim.lsp.buf.signature_help,
					desc = "Display Signature Information",
					buffer = bufnr,
				},
				{
					"<leader>lr",
					vim.lsp.buf.rename,
					desc = "Rename all references",
					buffer = bufnr,
				},
				{
					"<leader>lf",
					function()
						vim.lsp.buf.format()
					end,
					desc = "Format",
					buffer = bufnr,
				},
				{
					"<leader>lF",
					function()
						vim.lsp.buf.format()
					end,
					desc = "Format Range",
					buffer = bufnr,
					mode = "v",
				},
				{
					"<leader>Wa",
					vim.lsp.buf.add_workspace_folder,
					desc = "Workspace Add Folder",
					buffer = bufnr,
				},
				{
					"<leader>Wr",
					vim.lsp.buf.remove_workspace_folder,
					desc = "Workspace Remove Folder",
					buffer = bufnr,
				},
				{
					"<leader>Wl",
					function()
						vim.notify(
							vim.inspect(vim.lsp.buf.list_workspace_folders()),
							vim.log.levels.INFO,
							{ title = "Workspace Folders" }
						)
					end,
					desc = "Workspace List Folders",
					buffer = bufnr,
				},
			})
		else
			-- Fallback keymaps without which-key
			map("<leader>la", vim.lsp.buf.code_action, "Code Action")
			map("<leader>ls", vim.lsp.buf.signature_help, "Display Signature Information")
			map("<leader>lr", vim.lsp.buf.rename, "Rename all references")
			map("<leader>lf", function()
				vim.lsp.buf.format()
			end, "Format")
			map("<leader>Wa", vim.lsp.buf.add_workspace_folder, "Workspace Add Folder")
			map("<leader>Wr", vim.lsp.buf.remove_workspace_folder, "Workspace Remove Folder")
			map("<leader>Wl", function()
				vim.notify(
					vim.inspect(vim.lsp.buf.list_workspace_folders()),
					vim.log.levels.INFO,
					{ title = "Workspace Folders" }
				)
			end, "Workspace List Folders")

			-- Visual mode keymaps
			map("<leader>lA", vim.lsp.buf.code_action, "Range Code Actions", "v")
			map("<leader>lF", function()
				vim.lsp.buf.format()
			end, "Format Range", "v")
		end

		-- Native completion setup for Neovim 0.11+ (only if blink.cmp is not available)
		if client_supports_method(client, vim.lsp.protocol.Methods.textDocument_completion, bufnr) then
			-- Check if blink.cmp is available
			local blink_ok = pcall(require, "blink.cmp")
			if not blink_ok then
				-- Setup native completion only if blink.cmp is not available
				vim.opt_local.completeopt = { "menu", "menuone", "noinsert", "fuzzy", "popup" }

				-- Enable native LSP completion if available (Neovim 0.11+)
				if vim.lsp.completion and vim.lsp.completion.enable then
					vim.lsp.completion.enable(true, client.id, bufnr, { autotrigger = true })

					map("<C-Space>", function()
						vim.lsp.completion.trigger()
					end, "Trigger Completion", "i")
				end
			end
		end

		-- Document highlighting setup
		if client_supports_method(client, vim.lsp.protocol.Methods.textDocument_documentHighlight, bufnr) then
			local highlight_augroup = vim.api.nvim_create_augroup("lsp-highlight-" .. bufnr, { clear = true })

			vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
				buffer = bufnr,
				group = highlight_augroup,
				callback = vim.lsp.buf.document_highlight,
			})

			vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
				buffer = bufnr,
				group = highlight_augroup,
				callback = vim.lsp.buf.clear_references,
			})

			-- Critical: LspDetach cleanup to prevent memory leaks
			vim.api.nvim_create_autocmd("LspDetach", {
				buffer = bufnr,
				callback = function(detach_event)
					if detach_event.data.client_id == client.id then
						vim.lsp.buf.clear_references()
						vim.api.nvim_clear_autocmds({ group = highlight_augroup })
					end
				end,
			})
		end

		-- Inlay hints toggle (Neovim 0.10+)
		if client_supports_method(client, vim.lsp.protocol.Methods.textDocument_inlayHint, bufnr) then
			map("<leader>th", function()
				local enabled = vim.lsp.inlay_hint.is_enabled({ bufnr = bufnr })
				vim.lsp.inlay_hint.enable(not enabled, { bufnr = bufnr })
				vim.notify("Inlay hints " .. (enabled and "disabled" or "enabled"), vim.log.levels.INFO)
			end, "Toggle Inlay Hints")
		end

		-- Set omnifunc for fallback completion
		vim.bo[bufnr].omnifunc = "v:lua.vim.lsp.omnifunc"
	end,
})

-- Enable only Lua LSP for now
vim.lsp.enable({ "lua_ls" })

