-- ~/.config/nvim/lua/plugins/ui/lualine.lua

return {
	"nvim-lualine/lualine.nvim",
	event = "VeryLazy",
	dependencies = { "echasnovski/mini.icons" },
	config = function()
		-- Get icons and Catppuccin mocha palette
		local icons = require("core.icons")
		local mocha = require("catppuccin.palettes").get_palette("mocha")

		require("lualine").setup({
			options = {
				theme = "catppuccin",
				always_divide_middle = false,
				globalstatus = true,
				transparent = true,
				icons_enabled = true,
				component_separators = { left = icons.ui.PowerlineArrowLeft, right = icons.ui.PowerlineArrowRight },
				section_separators = { left = icons.ui.PowerlineLeftRound, right = icons.ui.PowerlineRightRound },
				disabled_filetypes = {
					statusline = { "snacks_dashboard", "alpha", "lazy" },
					winbar = {},
				},
				refresh = {
					statusline = 1000,
					tabline = 1000,
					winbar = 1000,
				},
			},

			sections = {
				lualine_a = {
					{
						function()
							local utils = require("core.utils")
							local mode = vim.fn.mode()
							return utils.get_mode_icon(mode)
						end,
						color = function()
							local utils = require("core.utils")
							local mode = vim.fn.mode()
							return utils.get_mode_color(mode)
						end,
						padding = { left = 1, right = 1 },
						separator = { right = icons.ui.PowerlineLeftRound },
					},
					{
						function()
							local current_buf = vim.api.nvim_get_current_buf()
							local buffers = vim.tbl_filter(function(buf)
								return vim.api.nvim_buf_is_valid(buf) and vim.bo[buf].buflisted
							end, vim.api.nvim_list_bufs())
							table.sort(buffers)

							local current_pos = 0
							for i, buf in ipairs(buffers) do
								if buf == current_buf then
									current_pos = i
									break
								end
							end

							if current_pos > 0 then
								return string.format("%s %d/%d", icons.ui.List, current_pos, #buffers)
							end
							return ""
						end,
						color = function()
							local is_modified = vim.bo[vim.api.nvim_get_current_buf()].modified
							return {
								fg = mocha.base,
								bg = is_modified and mocha.red or mocha.peach,
							}
						end,
						separator = { right = icons.ui.PowerlineLeftRound },
					},
				},

				lualine_b = {
					{
						function()
							local file = vim.fn.expand("%:p")
							local cwd = vim.fn.getcwd()
							file = vim.fn.fnamemodify(file, ":.")
							cwd = cwd:gsub("/+$", "")

							local rel = vim.fn.fnamemodify(file, ":~:.")
							local segments = vim.split(rel, "/")

							local path
							if #segments >= 2 then
								path = table.concat({ segments[#segments - 1], segments[#segments] }, "/")
							else
								path = rel
							end

							return icons.documents.File .. " " .. path
						end,
						color = {
							fg = mocha.base,
							bg = mocha.flamingo,
						},
						padding = { left = 1, right = 1 },
						separator = { right = icons.ui.PowerlineLeftRound },
					},
				},

				lualine_c = {
					{
						-- LSP diagnostics
						"diagnostics",
						sources = { "nvim_diagnostic" },
						symbols = {
							error = icons.diagnostics.Error,
							warn = icons.diagnostics.Warning,
							info = icons.diagnostics.Information,
							hint = icons.diagnostics.Hint,
						},
						diagnostics_color = {
							error = { fg = mocha.red },
							warn = { fg = mocha.yellow },
							info = { fg = mocha.sky },
							hint = { fg = mocha.teal },
						},
						colored = true,
						update_in_insert = false,
						always_visible = false,
						padding = { left = 1, right = 1 },
					},
					{
						-- Show recording macro
						function()
							local recording = vim.fn.reg_recording()
							if recording ~= "" then
								return icons.ui.Music .. " Recording @" .. recording
							end
							return ""
						end,
						color = { fg = mocha.red, bg = mocha.surface0 },
						padding = { left = 1, right = 1 },
					},
				},

				lualine_x = {
					{
						-- Noice command/search mode indicator
						function()
							local ok, noice = pcall(require, "noice")
							if ok then
								local mode = noice.api.status.mode.get()
								if mode then
									return mode
								end
							end
							return ""
						end,
						cond = function()
							local ok, noice = pcall(require, "noice")
							return ok and noice.api.status.mode.has()
						end,
						color = { fg = mocha.yellow, bg = mocha.surface0 },
						padding = { left = 1, right = 1 },
					},
					{
						-- Show search count (enhanced for flash integration)
						function()
							-- Check if flash is active first
							local ok_flash, flash = pcall(require, "flash")
							if ok_flash and flash.has_jump and flash.has_jump() then
								return icons.ui.Electric .. " Flash Active"
							end

							-- Regular search count
							if vim.v.hlsearch == 0 then
								return ""
							end
							local ok, search = pcall(vim.fn.searchcount)
							if not ok or search.total == 0 then
								return ""
							end
							if search.incomplete == 1 then
								return "?/?"
							end
							return string.format("%s %d/%d", icons.ui.Search, search.current, search.total)
						end,
						color = function()
							local ok_flash, flash = pcall(require, "flash")
							if ok_flash and flash.has_jump and flash.has_jump() then
								return { fg = mocha.red, bg = mocha.surface0 }
							end
							return { fg = mocha.yellow }
						end,
						padding = { left = 1, right = 1 },
					},
					{
						-- Show LSP status
						function()
							local clients = vim.lsp.get_clients({ bufnr = 0 })
							if #clients == 0 then
								return ""
							end

							local client_names = {}
							for _, client in pairs(clients) do
								table.insert(client_names, client.name)
							end

							return icons.ui.Gear .. " " .. table.concat(client_names, ", ")
						end,
						color = { fg = mocha.green },
						padding = { left = 1, right = 1 },
					},
				},

				lualine_y = {
					{
						-- Encoding (only show if not utf-8)
						function()
							local encoding = vim.bo.fileencoding or vim.go.encoding
							if encoding ~= "utf-8" then
								return icons.ui.Code .. " " .. encoding:upper()
							end
							return ""
						end,
						color = { fg = mocha.surface2 },
						padding = { left = 1, right = 1 },
					},
					{
						-- File format (only show if not unix)
						function()
							local format = vim.bo.fileformat
							if format ~= "unix" then
								local format_icons = {
									unix = icons.ui.Terminal,
									dos = icons.ui.Windows,
									mac = icons.ui.Circle,
								}
								return format_icons[format] .. " " .. format:upper()
							end
							return ""
						end,
						color = { fg = mocha.surface2 },
						padding = { left = 1, right = 1 },
					},
					{
						-- Filetype with icon
						function()
							local ft = vim.bo.filetype
							if ft ~= "" then
								-- Safely get icon from mini.icons
								local icon = ""
								local ok, mini_icons = pcall(require, "mini.icons")
								if ok then
									icon = mini_icons.get("filetype", ft) or ""
								end

								-- Use utils function for consistent abbreviation
								local utils = require("core.utils")
								local label = utils.abbreviate_filetype(ft)

								return icons.ui.SeparatorLight .. icon .. " " .. label .. " " .. icons.ui.SeparatorLight
							end
							return ""
						end,
						color = {
							fg = mocha.base,
							bg = mocha.flamingo,
						},
						padding = { left = 1, right = 1 },
						separator = { left = icons.ui.PowerlineRightRound },
					},
				},

				lualine_z = {
					{
						"progress",
						icon = icons.ui.Progress,
						color = { fg = mocha.base, bg = mocha.peach },
						padding = { left = 1, right = 1 },
					},
					{
						function()
							return icons.ui.Line .. " " .. vim.fn.line(".")
						end,
						padding = { left = 1, right = 1 },
						separator = { left = icons.ui.PowerlineRightRound },
					},
				},
			},

			-- Optional: Inactive sections for split windows
			inactive_sections = {
				lualine_a = {},
				lualine_b = {},
				lualine_c = {
					{
						"filename",
						color = { fg = mocha.surface2 },
						padding = { left = 1, right = 1 },
					},
				},
				lualine_x = {},
				lualine_y = {},
				lualine_z = {},
			},

			-- Extensions for special filetypes
			extensions = {
				"lazy",
				"mason",
				"trouble",
			},
		})
	end,
}

