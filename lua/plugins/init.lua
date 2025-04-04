-- plugins/init.lua - Loads all plugin categories

return {
	{ import = "plugins.ui" },          -- UI Plugins (includes theme)
	{ import = "plugins.code" },        -- Plugins for code, lsp, parser, linters and formatters
	{ import = "plugins.editor" },      -- Plugins for editing easily

	-- { import = "plugins.lsp" },         -- LSP & Completion
	-- { import = "plugins.treesitter" },  -- Treesitter & Syntax
	-- { import = "plugins.git" },         -- Git Plugins
	-- { import = "plugins.tools" },       -- Other Tools
}
