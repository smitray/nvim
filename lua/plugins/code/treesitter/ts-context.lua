return {
	{
		"nvim-treesitter/nvim-treesitter-context",
		dependencies = { "nvim-treesitter/nvim-treesitter" },
		event = { "BufReadPost", "BufNewFile" },
		config = function()
			require("treesitter-context").setup({
				enable = true,
				max_lines = 0,           -- How many lines the window should span. Values <= 0 mean no limit.
				min_window_height = 0,   -- Minimum editor window height to enable context. Values <= 0 mean no limit.
				line_numbers = true,
				multiline_threshold = 20, -- Maximum number of lines to show for a single context
				trim_scope = 'outer',    -- Which context lines to discard if `max_lines` is exceeded. Choices: 'inner', 'outer'
				mode = 'cursor',         -- Line used to calculate context. Choices: 'cursor', 'topline'
				separator = nil,
				zindex = 20,             -- The Z-index of the context window
				on_attach = nil,         -- (fun(buf: integer): boolean) return false to disable attaching
			})

			-- Add keymaps to navigate context
			vim.keymap.set("n", "[c", function()
				require("treesitter-context").go_to_context()
			end, { silent = true, desc = "Go to context (parent function/class)" })

			-- Optionally add highlight customization
			vim.api.nvim_set_hl(0, "TreesitterContext", { link = "CursorLine" })
			vim.api.nvim_set_hl(0, "TreesitterContextLineNumber", { link = "CursorLineNr" })
		end,
	},
}
