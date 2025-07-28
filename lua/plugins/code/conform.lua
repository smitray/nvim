-- ~/.config/nvim/lua/plugins/code/conform.lua
-- Smart formatting with intelligent project detection

return {
	"stevearc/conform.nvim",
	event = { "BufWritePre", "BufNewFile" },
	cmd = { "ConformInfo" },
	keys = {
		{
			"<leader>lf",
			function()
				require("conform").format({
					lsp_format = "fallback", -- Use LSP if no conform formatter available
					async = false,
					timeout_ms = 2000,
				})
			end,
			mode = { "n", "v" },
			desc = "[l]sp [f]ormat buffer",
		},
	},
	opts = {
		-- Simple formatters by filetype
		formatters_by_ft = {
			lua = { "stylua" },
		},

		-- Format on save: only if conform has a formatter, otherwise let LSP handle
		format_on_save = function(bufnr)
			local filetype = vim.bo[bufnr].filetype
			local formatters = require("conform").list_formatters(bufnr)

			if #formatters > 0 then
				return {
					timeout_ms = 2000,
					lsp_format = "never", -- Use conform only if we have formatters
				}
			else
				return {
					timeout_ms = 2000,
					lsp_format = "prefer", -- Let LSP handle it (Biome, etc.)
				}
			end
		end,

		-- Notification settings
		notify_on_error = false, -- Don't spam errors when no formatter
		notify_no_formatters = false,
	},

	config = function(_, opts)
		require("conform").setup(opts)

		-- Add smart JavaScript/TypeScript detection after setup
		local conform = require("conform")

		-- Override formatters for web languages with smart detection
		local function get_js_formatters(bufnr)
			local prettier_configs = {
				".prettierrc",
				".prettierrc.json",
				".prettierrc.js",
				".prettierrc.yaml",
				".prettierrc.yml",
				"prettier.config.js",
				"prettier.config.mjs",
				".prettierrc.toml",
				".prettierrc.cjs",
			}

			local found = vim.fs.find(prettier_configs, {
				path = vim.api.nvim_buf_get_name(bufnr),
				upward = true,
			})

			if #found > 0 then
				return { "prettierd", "prettier" }
			end
			return {} -- Let LSP handle it
		end

		-- Set up the smart detection for web languages
		local web_filetypes = {
			"javascript",
			"typescript",
			"javascriptreact",
			"typescriptreact",
			"vue",
			"svelte",
			"astro",
		}

		for _, ft in ipairs(web_filetypes) do
			opts.formatters_by_ft[ft] = get_js_formatters
		end

		-- Re-setup with updated config
		conform.setup(opts)
	end,
}
