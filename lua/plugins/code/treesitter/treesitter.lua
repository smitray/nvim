return {
	{
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate",
		event = { "BufReadPost", "BufNewFile" },
		-- No dependencies needed here as other plugins depend on treesitter
		config = function()
			require("nvim-treesitter.configs").setup({
				ensure_installed = {
					"astro", "css", "csv", "dockerfile", "go", "html",
					"jsdoc", "json", "lua", "markdown", "markdown_inline", "php", "prisma",
					"python", "rasi", "regex", "scss", "svelte", "sql", "ssh_config",
					"toml", "tsx", "typescript", "vim", "vimdoc", "vue", "yaml", "bash"
				},
				ignore_install = { "javascript" }, -- TypeScript parser will handle JavaScript
				auto_install = true,

				highlight = {
					enable = true,
					additional_vim_regex_highlighting = { "markdown" },
					-- Disable for large files
					disable = function(lang, buf)
						local max_filesize = 100 * 1024 -- 100 KB
						local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
						if ok and stats and stats.size > max_filesize then
							return true
						end
					end,
				},

				indent = {
					enable = true,
				},

				-- Incremental selection
				incremental_selection = {
					enable = true,
					keymaps = {
						init_selection = "gnn",
						node_incremental = "grn",
						scope_incremental = "grc",
						node_decremental = "grm",
					},
				},
			})

			-- Set up folding
			vim.opt.foldmethod = "expr"
			vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
			vim.opt.foldenable = false -- Default to unfolded

			-- make zsh files recognized as sh for bash-ls & treesitter
			vim.filetype.add {
				extension = {
					zsh = "sh",
					sh = "sh", -- force sh-files with zsh-shebang to still get sh as filetype
				},
				filename = {
					[".zshrc"] = "sh",
					[".zshenv"] = "sh",
				},
			}
		end,
	},
}
