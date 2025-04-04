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
    end,
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

-- Enter insert mode automatically when opening a terminal
autocmd("TermOpen", {
    group = GeneralGroup,
    pattern = "*",
    command = "startinsert",
})

-- Close terminal buffers automatically when they exit
autocmd("TermClose", {
    group = GeneralGroup,
    pattern = "*",
    command = "bd!",
})

-- =============================================
-- Miscellaneous
-- =============================================

-- Reload Neovim whenever `lua` config files are edited
autocmd("BufWritePost", {
    group = GeneralGroup,
    pattern = { "*.lua" },
    command = "source <afile>",
})
