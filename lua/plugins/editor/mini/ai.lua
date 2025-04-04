return {
	"echasnovski/mini.ai",
	event = "VeryLazy",
	opts = function()
		return {
			n_lines = 500,
			custom_textobjects = {
				-- Treesitter-powered textobjects
				f = require("mini.ai").gen_spec.treesitter({ a = "@function.outer", i = "@function.inner" }),
				c = require("mini.ai").gen_spec.treesitter({ a = "@class.outer", i = "@class.inner" }),
				-- Add more as needed
			},
		}
	end,
}
