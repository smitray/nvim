-- plugins/ui/mini-icons.lua

return {
	"echasnovski/mini.icons",
	lazy = true,
	init = function()
		package.preload["nvim-web-devicons"] = function()
			require("mini.icons").mock_nvim_web_devicons()
			return package.loaded["nvim-web-devicons"]
		end
	end,
	dependencies = {
		{ "nvim-tree/nvim-web-devicons", enabled = false },
	},
}
