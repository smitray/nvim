-- core/autocommands.lua - Neovim Autocommands
local autocmd = vim.api.nvim_create_autocmd
local augroup = vim.api.nvim_create_augroup

-- Create a custom group for managing autocommands
local GeneralGroup = augroup("GeneralAutocommands", { clear = true })

-- =============================================
-- UI Enhancements & Behavior
-- =============================================
-- Highlight text when yanking
autocmd("TextYankPost", {
	group = GeneralGroup,
	pattern = "*",
	callback = function()
		vim.highlight.on_yank({ higroup = "IncSearch", timeout = 150 })
	end,
})

-- Remove trailing whitespace on save
autocmd("BufWritePre", {
	group = GeneralGroup,
	pattern = "*",
	command = [[%s/\s\+$//e]],
})

-- Disable auto-comment when opening new lines
autocmd("BufEnter", {
	group = GeneralGroup,
	pattern = "*",
	command = "set formatoptions-=cro",
})

-- Automatically close `nvim-tree` or `oil.nvim` when it's the last window
autocmd("BufEnter", {
	group = GeneralGroup,
	pattern = "*",
	callback = function()
		local buffers = vim.api.nvim_list_bufs()
		if #buffers == 1 and vim.bo.buftype == "nofile" then
			vim.cmd("quit")
		end
	end
})

-- =============================================
-- LSP & Filetype-Based Settings
-- =============================================
-- Auto-format on save (if LSP supports it)
autocmd("BufWritePre", {
	group = GeneralGroup,
	pattern = { "*.js", "*.jsx", "*.ts", "*.tsx", "*.vue", "*.svelte", "*.lua", "*.json", "*.yaml", "*.toml" },
	callback = function()
		vim.lsp.buf.format({ async = false })
	end,
})

-- Set filetypes for specific patterns
autocmd({ "BufNewFile", "BufRead" }, {
	group = GeneralGroup,
	pattern = { "*.mdx" },
	command = "set filetype=markdown",
})

-- =============================================
-- Terminal Behavior
-- =============================================
-- Exit terminal mode with Escape in terminal mode
-- vim.api.nvim_set_keymap('t', '<Esc>', [[<C-\><C-n>]], {noremap = true})
--
-- -- Close terminal window with q after exiting terminal mode
-- autocmd("TermOpen", {
--     group = GeneralGroup,
--     callback = function()
--         vim.api.nvim_buf_set_keymap(0, 'n', 'q', ':q<CR>', {noremap = true})
--     end
-- })

vim.api.nvim_create_autocmd("TermOpen", {
	group = GeneralGroup,
	callback = function()
		-- First Escape goes to zsh vi mode, second Escape exits to Neovim normal mode
		vim.api.nvim_buf_set_keymap(0, 't', '<Esc>', [[<C-\><C-n>]], {noremap = true})

		-- Then in normal mode, Escape sends clear and exit commands, then closes the terminal
		vim.api.nvim_buf_set_keymap(0, 'n', '<Esc>', [[:call chansend(b:terminal_job_id, "clear && exit\n")<CR>:q<CR>]], {noremap = true})
	end
})


-- =============================================
-- Miscellaneous
-- =============================================
autocmd("BufWritePost", {
    group = GeneralGroup,
    pattern = { "*.lua" },
    callback = function()
        vim.cmd("source " .. vim.fn.expand("<afile>"))
        vim.notify("Sourced: " .. vim.fn.expand("<afile>"), vim.log.levels.INFO)
    end,
})-- Reload Neovim whenever `lua` config files are edited
