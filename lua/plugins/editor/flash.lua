-- plugins/editor/flash.lua

return {
	"folke/flash.nvim",
	event = "VeryLazy",
	opts = {
		-- Optimized label sequence for home row efficiency
		labels = "asdfghjklqwertyuiopzxcvbnm",

		search = {
			-- Search/jump in all windows for better workflow
			multi_window = true,
			-- Search direction
			forward = true,
			-- Wrap around when reaching end
			wrap = true,
			-- Exact match mode for precision (can be changed to "fuzzy" if preferred)
			mode = "exact",
			-- Behave like incsearch for real-time feedback
			incremental = true,
			-- Excluded filetypes and custom window filters
			exclude = {
				"notify",
				"noice",
				"cmp_menu",
				"snacks",  -- Added for snacks.nvim compatibility
				"lazy",
				"mason",
				"help",
				function(win)
					-- Exclude non-focusable windows
					return not vim.api.nvim_win_get_config(win).focusable
				end,
			},
			-- No trigger character needed
			trigger = "",
		},

		jump = {
			-- Save location in jumplist for easy return
			jumplist = true,
			-- Jump to start of match
			pos = "start",
			-- Don't add to search history (reduces clutter)
			history = false,
			-- Don't add to search register
			register = false,
			-- Clear highlights after jump for clean interface
			nohlsearch = true,
			-- Don't auto-jump when only one match (gives user control)
			autojump = false,
		},

		modes = {
			-- Enhanced search mode with flash
			search = {
				enabled = true,
				highlight = { backdrop = true },
				jump = {
					history = true,  -- Enable history for search mode
					register = true,  -- Enable register for search mode
					nohlsearch = true
				},
			},

			-- ENHANCED f/F/t/T motions (your preferred approach)
			char = {
				enabled = true,
				-- Enhanced character motions with multi-line support
				keys = { "f", "F", "t", "T", ",", ";" },
				search = { wrap = false },  -- Keep line-local behavior option
				highlight = { backdrop = true },
				jump = { register = false },
				-- Show jump labels for multiple matches
				jump_labels = true,
				-- Multi-line character search (main enhancement)
				multi_line = true,
			},

			-- Treesitter-aware search
			treesitter = {
				labels = "abcdefghijklmnopqrstuvwxyz",
				jump = { pos = "range" },
				highlight = {
					backdrop = false,
					matches = true,
				},
			},

			-- Remote operations (for operator-pending mode)
			remote = {
				remote_op = { restore = true, motion = true },
			},
		},

		-- Prompt configuration
		prompt = {
			enabled = true,
			prefix = { { "⚡", "FlashPromptIcon" } },
		},

		-- Label appearance
		label = {
			-- Show labels before the match
			before = true,
			-- Show labels after the match
			after = true,
			-- Label style
			style = "overlay",
			-- Reuse labels across multiple windows
			reuse = "lowercase",
			-- Distance-based label priority
			distance = true,
		},

		-- Highlight groups
		highlight = {
			-- Backdrop dim
			backdrop = true,
			-- Match highlighting
			matches = true,
			-- Priority for highlights
			priority = 5000,
		},

		-- Remove the problematic action configuration
		-- The action field should contain function callbacks, not config options

		-- Continue flash after first jump (useful for complex navigation)
		continue = false,
	},

	-- Key mappings
	keys = {
		-- Main flash jump (replaces easymotion-style plugins)
		{
			"s",
			mode = { "n", "x", "o" },
			function() require("flash").jump() end,
			desc = "[s]earch | flash jump"
		},

		-- Treesitter-aware selection/jumping
		{
			"S",
			mode = { "n", "o", "x" },
			function() require("flash").treesitter() end,
			desc = "[S]elect | flash treesitter"
		},

		-- Remote flash (for operator-pending mode)
		{
			"r",
			mode = "o",
			function() require("flash").remote() end,
			desc = "[r]emote | flash remote"
		},

		-- Treesitter search (visual/operator-pending)
		{
			"R",
			mode = { "o", "x" },
			function() require("flash").treesitter_search() end,
			desc = "[R]emote | flash treesitter search"
		},

		-- Toggle flash in command mode
		{
			"<c-s>",
			mode = { "c" },
			function() require("flash").toggle() end,
			desc = "Toggle flash search"
		},
	},
}
