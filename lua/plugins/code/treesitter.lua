-- plugins/code/treesitter.lua

return {
	"nvim-treesitter/nvim-treesitter",
	build = ":TSUpdate",
	event = { "BufReadPost", "BufNewFile", "BufWritePre", "VeryLazy" },
	cmd = {
		"TSInstall", "TSUninstall", "TSUpdate", "TSUpdateSync",
		"TSInstallInfo", "TSInstallSync", "TSInstallFromGrammar",
		"TSUninstallSync", "TSBufEnable", "TSBufDisable", "TSBufToggle",
		"TSEnable", "TSDisable", "TSToggle", "TSModuleInfo", "TSConfigInfo",
		"TSEditQuery", "TSEditQueryUserAfter",
	},
	dependencies = {
		{
			"windwp/nvim-ts-autotag",
			config = function()
				require("nvim-ts-autotag").setup({
					opts = {
						enable_close = true,
						enable_rename = true,
						enable_close_on_slash = false,
					},
				})
			end,
		},
		"folke/ts-comments.nvim",
		{
			"nvim-treesitter/nvim-treesitter-textobjects",
			init = function()
				vim.g.ts_textobject_move_no_default_keymaps = true
			end,
		},
		{
			"nvim-treesitter/nvim-treesitter-context",
			keys = {
				{ "<leader>oc", "<cmd>TSContextToggle<cr>", desc = "[o]ptions [c]ontext toggle" },
				{
					"[c",
					function() require("treesitter-context").go_to_context(vim.v.count1) end,
					desc = "[c]ontext | jump to parent",
				},
			},
			opts = {
				enable = true,
				max_lines = 3,
				min_window_height = 10,
				line_numbers = true,
				multiline_threshold = 20,
				trim_scope = "outer",
				mode = "cursor",
				separator = "─",
				zindex = 20,
			},
		},
		{
			"nvim-treesitter/playground",
			cmd = {
				"TSPlaygroundToggle",
				"TSHighlightCapturesUnderCursor",
				"TSNodeUnderCursor",
			},
			keys = {
				{ "<leader>tp", "<cmd>TSPlaygroundToggle<cr>", desc = "[t]reesitter [p]layground" },
				{ "<leader>th", "<cmd>TSHighlightCapturesUnderCursor<cr>", desc = "[t]reesitter [h]ighlight capture" },
				{ "<leader>tn", "<cmd>TSNodeUnderCursor<cr>", desc = "[t]reesitter [n]ode under cursor" },
			},
		},
	},
  config = function(_, opts)
    require("nvim-treesitter.configs").setup(opts)

    -- Setup treesitter-context autocmd
    vim.api.nvim_create_autocmd("BufEnter", {
      group = vim.api.nvim_create_augroup("TSContextToggle", { clear = true }),
      desc = "Enable/disable treesitter-context conditionally",
      callback = function(args)
        local buf = args.buf
        local ft = vim.bo[buf].filetype
        local excluded = {
          "NvimTree", "neo-tree", "nvim-tree", "Telescope", "lazy", "mason", "help",
          "markdown", "text", "txt", "man", "org", "norg", "terminal", "TelescopePrompt",
          "toggleterm", "snack", "fugitive", "git", "gitcommit", "diff", "dashboard",
          "alpha", "starter", "notify", "noice", "aerial", "quickfix", "prompt", "popup",
          "spectre", "fzf", "yaml", "toml", "json", "jsonc",
        }

        if vim.tbl_contains(excluded, ft) or vim.api.nvim_buf_line_count(buf) < 30 then
          pcall(function() require("treesitter-context").disable() end)
        else
          pcall(function() require("treesitter-context").enable() end)
        end
      end,
    })
  end,
	opts = {
		ensure_installed = {
			"lua", "vim", "vimdoc", "query",
			"typescript", "tsx", "javascript", "graphql",
			"html", "css", "scss", "astro", "vue", "svelte",
			"json", "jsonc", "yaml", "toml", "prisma",
			"dockerfile", "go", "jsdoc", "markdown", "markdown_inline",
			"php", "python", "regex", "sql", "bash",
		},
		auto_install = false,  -- Prevent conflicts with ensure_installed
		sync_install = false,
		highlight = {
			enable = true,
			additional_vim_regex_highlighting = { "markdown" },
			-- Removed redundant large file check - snacks.bigfile handles this
			disable = function(_, buf)
				-- Only disable for specific filetypes that cause issues
				local ft = vim.bo[buf].filetype
				local problematic_fts = { "latex" }  -- Add filetypes that have highlighting issues
				return vim.tbl_contains(problematic_fts, ft)
			end,
		},
		indent = {
			enable = true,
			disable = { "yaml" },
		},
		incremental_selection = {
			enable = true,
			keymaps = {
				init_selection = "<CR>",
				node_incremental = "<TAB>",
				scope_incremental = "<CR>",
				node_decremental = "<S-TAB>",
			},
		},
		playground = {
			enable = true,
			disable = {},
			updatetime = 25,
			persist_queries = false,
		},
		textobjects = {
			-- STREAMLINED: Removed overlapping textobjects that mini.ai handles better
			-- mini.ai handles: functions (f), classes (c), blocks (o), parameters (a)
			select = {
				enable = true,
				lookahead = true,
				keymaps = {
					-- Assignments (mini.ai doesn't provide these)
					["a="] = { query = "@assignment.outer", desc = "Select outer assignment" },
					["i="] = { query = "@assignment.inner", desc = "Select inner assignment" },
					["l="] = { query = "@assignment.lhs", desc = "Select assignment LHS" },
					["r="] = { query = "@assignment.rhs", desc = "Select assignment RHS" },

					-- Returns (mini.ai doesn't provide these)
					["ar"] = { query = "@return.outer", desc = "Select outer return" },
					["ir"] = { query = "@return.inner", desc = "Select return value" },

					-- Comments (mini.ai doesn't provide these)
					["aC"] = { query = "@comment.outer", desc = "Select outer comment" },
					["iC"] = { query = "@comment.inner", desc = "Select inner comment" },

					-- Statements (useful for line-based operations)
					["as"] = { query = "@statement.outer", desc = "Select statement" },
				},
				selection_modes = {
					["@assignment.outer"] = "v",
					["@return.outer"] = "v",
					["@statement.outer"] = "v",
				},
				include_surrounding_whitespace = false,  -- Changed to false for precision
			},

			-- MOVEMENT: Keep this - mini.ai doesn't provide movement
			move = {
				enable = true,
				set_jumps = true,
				goto_next_start = {
					["]f"] = { query = "@call.outer", desc = "Next function call start" },
					["]m"] = { query = "@function.outer", desc = "Next function start" },
					["]c"] = { query = "@class.outer", desc = "Next class start" },
					["]i"] = { query = "@conditional.outer", desc = "Next conditional start" },
					["]l"] = { query = "@loop.outer", desc = "Next loop start" },
					["]s"] = { query = "@scope", query_group = "locals", desc = "Next scope" },
					["]z"] = { query = "@fold", query_group = "folds", desc = "Next fold" },
				},
				goto_next_end = {
					["]F"] = { query = "@call.outer", desc = "Next function call end" },
					["]M"] = { query = "@function.outer", desc = "Next function end" },
					["]C"] = { query = "@class.outer", desc = "Next class end" },
					["]I"] = { query = "@conditional.outer", desc = "Next conditional end" },
					["]L"] = { query = "@loop.outer", desc = "Next loop end" },
				},
				goto_previous_start = {
					["[f"] = { query = "@call.outer", desc = "Prev function call start" },
					["[m"] = { query = "@function.outer", desc = "Prev function start" },
					["[c"] = { query = "@class.outer", desc = "Prev class start" },
					["[i"] = { query = "@conditional.outer", desc = "Prev conditional start" },
					["[l"] = { query = "@loop.outer", desc = "Prev loop start" },
				},
				goto_previous_end = {
					["[F"] = { query = "@call.outer", desc = "Prev function call end" },
					["[M"] = { query = "@function.outer", desc = "Prev function end" },
					["[C"] = { query = "@class.outer", desc = "Prev class end" },
					["[I"] = { query = "@conditional.outer", desc = "Prev conditional end" },
					["[L"] = { query = "@loop.outer", desc = "Prev loop end" },
				},
			},

			-- SWAPPING: Keep this - mini.ai doesn't provide swapping
			swap = {
				enable = true,
				swap_next = {
					["<leader>na"] = "@parameter.inner",
					["<leader>nk"] = "@property.outer",
					["<leader>nm"] = "@function.outer",
				},
				swap_previous = {
					["<leader>pa"] = "@parameter.inner",
					["<leader>pk"] = "@property.outer",
					["<leader>pm"] = "@function.outer",
				},
			},
		},
	},
}
