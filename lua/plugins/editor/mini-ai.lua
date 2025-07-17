-- plugins/editor/mini-ai.lua

return {
	"echasnovski/mini.ai",
	event = "VeryLazy",
	opts = function()
		local ai = require("mini.ai")
		return {
			n_lines = 500,
			custom_textobjects = {
				-- CORE TEXTOBJECTS: These override treesitter's basic ones with enhanced functionality
				-- Functions and methods
				f = ai.gen_spec.treesitter({
					a = "@function.outer",
					i = "@function.inner"
				}),

				-- Classes
				c = ai.gen_spec.treesitter({
					a = "@class.outer",
					i = "@class.inner"
				}),

				-- Blocks, conditionals, loops (comprehensive)
				o = ai.gen_spec.treesitter({
					a = { "@block.outer", "@conditional.outer", "@loop.outer" },
					i = { "@block.inner", "@conditional.inner", "@loop.inner" },
				}),

				-- Parameters/arguments
				a = ai.gen_spec.treesitter({
					a = "@parameter.outer",
					i = "@parameter.inner"
				}),

				-- ENHANCED TEXTOBJECTS: These add functionality treesitter doesn't provide
				-- HTML/XML tags
				t = {
					"<([%p%w]-)%f[^<%w][^<>]->.-</%1>",
					"^<.->().*()</[^/]->$"
				},

				-- Numbers/digits
				d = { "%f[%d]%d+" },

				-- Word variations (camelCase, snake_case, etc.)
				e = {
					{
						"%u[%l%d]+%f[^%l%d]",  -- CamelCase words
						"%f[%S][%l%d]+%f[^%l%d]",  -- snake_case words
						"%f[%P][%l%d]+%f[^%l%d]",  -- word_with_underscores
						"^[%l%d]+%f[^%l%d]"  -- start of line words
					},
					"^().*()$",
				},

				-- Function calls (any function call)
				u = ai.gen_spec.function_call(),

				-- Function calls (word characters only)
				U = ai.gen_spec.function_call({ name_pattern = "[%w_]+" }),

				-- ADDITIONAL USEFUL TEXTOBJECTS
				-- Properties/keys (for object literals, etc.)
				k = ai.gen_spec.treesitter({
					a = "@property.outer",
					i = "@property.inner"
				}),

				-- Conditionals (specific)
				i = ai.gen_spec.treesitter({
					a = "@conditional.outer",
					i = "@conditional.inner"
				}),

				-- Loops (specific)
				l = ai.gen_spec.treesitter({
					a = "@loop.outer",
					i = "@loop.inner"
				}),

				-- Method calls
				m = ai.gen_spec.treesitter({
					a = "@method.outer",
					i = "@method.inner"
				}),
			},
		}
	end,
	config = function(_, opts)
		require("mini.ai").setup(opts)

		-- Register additional patterns for specific filetypes
		local extra_patterns = {
			lua = {
				-- Lua-specific patterns
				["local_var"] = "local%s+([%w_]+)",
				["require_call"] = "require%s*%(.-%))",
			},
			javascript = {
				-- JS-specific patterns
				["arrow_func"] = "%(%s*[%w_,]*%s*%)%s*=>",
				["template_literal"] = "`[^`]*`",
			},
			typescript = {
				-- TS-specific patterns
				["type_annotation"] = ":%s*[%w<>%[%]]+",
				["interface"] = "interface%s+%w+",
			},
		}

		-- Auto-setup filetype specific patterns
		vim.api.nvim_create_autocmd("FileType", {
			group = vim.api.nvim_create_augroup("MiniAiFileType", { clear = true }),
			callback = function(args)
				local ft = args.match
				if extra_patterns[ft] then
					-- Could extend mini.ai with filetype-specific patterns here
					-- This is a placeholder for future enhancements
				end
			end,
		})
	end,
}
