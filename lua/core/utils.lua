-- core/utils.lua - Helper functions

local M = {}

function M.HandleBuffer()
	vim.cmd("enew") -- Create a new empty buffer
	local filename = vim.fn.input("Save as: ", vim.fn.getcwd() .. "/", "file")
	if filename ~= "" then
		vim.cmd("write " .. vim.fn.fnameescape(filename))
	end
end

return M
