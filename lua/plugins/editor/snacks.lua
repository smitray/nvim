-- config/plugins/snacks.lua
return {
	"folke/snacks.nvim",
	lazy = false,  -- Ensure snacks.nvim is not lazy-loaded
	priority = 1000, -- Load early to avoid setup warnings
	opts = {
		indent = { enabled = true },
		notifier = { enabled = true },
		picker = {
			sources = {
				explorer = {
					auto_close = true,
					layout = { layout = { position = "right" } },
				},
			},
		},
		explorer = {
			enabled = true,
			tree = false
		},
		statuscolumn = {
			enabled = true,
			left = { "mark", "sign" }, -- priority of signs on the left (high to low)
		}
	}
}

