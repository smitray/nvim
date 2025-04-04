-- core/globalfn.lua - Global functions

--- Set keymaps easily with sensible defaults
---@param mode string|table Mode(s) for the keymap (e.g., "n", {"n", "v"})
---@param lhs string Left-hand side (keybinding)
---@param rhs string|function Right-hand side (command or function)
---@param opts table|nil Optional keymap settings (default: { silent = true, noremap = true })
_G.map = function(mode, lhs, rhs, opts)
    opts = vim.tbl_extend("force", { silent = true, noremap = true }, opts or {})
    vim.keymap.set(mode, lhs, rhs, opts)
end
