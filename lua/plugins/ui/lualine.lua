return {
	{
		"nvim-lualine/lualine.nvim",
		event = "VeryLazy",
		dependencies = { "echasnovski/mini.icons" },
		config = function()
			-- Get Catppuccin mocha palette
			local mocha = require("catppuccin.palettes").get_palette "mocha"

      ---@diagnostic disable-next-line
			require("lualine").setup({
				options = {
					theme = 'catppuccin',
					always_divide_middle = false,
					globalstatus = true,
					transparent = true,
					icons_enabled = true,
					component_separators = { left = '', right = '' },
					section_separators = { left = '', right = '' },
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
								local mode_icons = {
									['n'] = "󰋘", ['i'] = "󰏫", ['v'] = "󰩭",
									['\22'] = "󰕢", ['V'] = "󰩭", ['c'] = "󰞷",
									['R'] = "󰬳", ['s'] = "󰩬", ['S'] = "󱐁",
									['t'] = "󰙀", ['no'] = "󰘳", ['ic'] = "󰏘",
									['Rv'] = "󰬵", ['cv'] = "󰞷", ['ce'] = "󰞷",
									['r'] = "󰘥", ['rm'] = "󰜷", ['r?'] = "󰋗", ['!'] = "󱆃",
								}
								local mode = vim.fn.mode()
								return mode_icons[mode] or mode
							end,
							color = function()
								local mode = vim.fn.mode()
								local mode_bg_colors = {
									['n'] = mocha.blue, ['i'] = mocha.green, ['v'] = mocha.mauve,
									['\22'] = mocha.mauve, ['V'] = mocha.mauve, ['c'] = mocha.yellow,
									['R'] = mocha.red, ['s'] = mocha.peach, ['S'] = mocha.peach,
									['t'] = mocha.teal, ['no'] = mocha.mauve, ['ic'] = mocha.mauve,
									['Rv'] = mocha.red, ['cv'] = mocha.flamingo, ['ce'] = mocha.flamingo,
									['r'] = mocha.sky, ['rm'] = mocha.sky, ['r?'] = mocha.sky,
									['!'] = mocha.maroon,
								}
								local bg_color = mode_bg_colors[mode] or mocha.surface0
								return { fg = mocha.base, bg = bg_color }
							end,
							padding = { left = 1, right = 1 },
							separator = { right = '' },
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
									return string.format(" %d/%d", current_pos, #buffers)
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
							separator = { right = "" },
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

								return "󰓡 " .. path
							end,
							color = {
								fg = mocha.base,
								bg = mocha.flamingo,
							},
							padding = { left = 1, right = 1 },
							separator = { right = "" },
						},
					},

					lualine_c = {
						{
							-- LSP diagnostics
							"diagnostics",
							sources = { "nvim_diagnostic" },
							symbols = {
								error = " ",
								warn = " ",
								info = " ",
								hint = "󰌶 ",
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
									return "󰑊 Recording @" .. recording
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
									return " Flash Active"
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
								return string.format("󰍉 %d/%d", search.current, search.total)
							end,
							icon = "󰍉",
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

								return "󱐋 " .. table.concat(client_names, ", ")
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
									return "󰉿 " .. encoding:upper()
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
										unix = "",
										dos = "",
										mac = "",
									}
									return " " .. (format_icons[format] or format:upper())
								end
								return ""
							end,
							color = { fg = mocha.surface2 },
							padding = { left = 1, right = 1 },
						},
						-- Filetype component (your existing one)
						(function()
							-- Define the common abbreviations table
							local common_abbrevs = {
								-- Web development
								javascript = "JS",
								typescript = "TS",
								typescriptreact = "TSX",
								javascriptreact = "JSX",
								vue = "Vue",
								svelte = "Svelte",
								html = "HTML",
								css = "CSS",
								scss = "SCSS",
								sass = "Sass",

								-- Data formats
								json = "JSON",
								yaml = "YAML",
								yml = "YML",
								toml = "TOML",
								xml = "XML",

								-- Markup & Documentation
								markdown = "MD",
								mdx = "MDX",
								rst = "RST",

								-- Configuration & DevOps
								dockerfile = "Docker",
								docker = "Docker",
								["docker-compose"] = "Compose",
								prisma = "Prisma",
								terraform = "TF",

								-- Programming languages
								lua = "Lua",
								python = "Py",
								rust = "Rust",
								go = "Go",
								php = "PHP",

								-- Shell
								sh = "SH",
								bash = "Bash",
								zsh = "ZSH",
								fish = "Fish",

								-- VIM
								vim = "Vim",
								nvim = "Nvim",
								vimdoc = "VimDoc",
							}

							-- Cache for dynamic abbreviations
							local abbrev_cache = {}

							-- Function to create dynamic abbreviation
							local function create_dynamic_abbrev(ft)
								-- Check cache first
								if abbrev_cache[ft] then
									return abbrev_cache[ft]
								end

								local label

								-- Special cases for compound filetypes
								if ft:find("typescript") and ft:find("react") then
									label = "TSX"
								elseif ft:find("javascript") and ft:find("react") then
									label = "JSX"
								else
									-- For other filetypes, create abbreviations by:
									-- 1. Using uppercase for single-word filetypes up to 3 chars
									if #ft <= 3 then
										label = ft:upper()
										-- 2. Using first letter uppercase for longer single-word filetypes
									elseif not ft:find("[^%a]") then
										-- No special characters, likely a single word
										if #ft <= 6 then
											-- Short enough to display as is with first letter capitalized
											label = ft:sub(1,1):upper() .. ft:sub(2)
										else
											-- Longer filetype, use first letter and last few letters
											label = ft:sub(1,1):upper() .. ft:sub(-3)
										end
									else
										-- Otherwise, leave as is
										label = ft
									end
								end

								-- Cache the result
								abbrev_cache[ft] = label
								return label
							end

							-- Return the actual component
							return {
								function()
									local ft = vim.bo.filetype
									if ft ~= "" then
										-- Get icon for the filetype (mini.icons handles its own caching)
										local icon = require("mini.icons").get("filetype", ft) or ""

										-- Use predefined abbreviation if available, otherwise get dynamic one
										local label = common_abbrevs[ft] or create_dynamic_abbrev(ft)

										return " " .. icon .. " " .. label .. " "
									end
									return ""
								end,
								color = {
									fg = mocha.base,
									bg = mocha.flamingo,
								},
								padding = { left = 1, right = 1 },
								separator = { left = '' },
							}
						end)(),
					},

					lualine_z = {
						{
							"progress",
							icon = "󱞇",
							color = { fg = mocha.base, bg = mocha.peach },
							padding = { left = 1, right = 1 },
						},
						{
							function()
								return "󰍟 " .. vim.fn.line(".")
							end,
							padding = { left = 1, right = 1 },
							separator = { left = '' },
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
					"oil",
					"trouble",
					"noice",  -- Add noice extension
				},
			})
		end,
	},
}
