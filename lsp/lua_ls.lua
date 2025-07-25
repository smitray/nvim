-- ~/.config/nvim/lsp/lua_ls.lua
-- Configuration for the Lua language server (lua_ls)

return {
  cmd = { "lua-language-server" },
  filetypes = { "lua" },
  root_markers = { ".luarc.json", ".luarc.jsonc", ".git" },
  -- This is the crucial part that binds the LSP server to the completion engine.
  -- We will create the blink.cmp configuration later.
  -- capabilities = require("blink.cmp").get_lsp_capabilities(),
  settings = {
    Lua = {
      -- Configure runtime environment for Neovim
      runtime = {
        version = "LuaJIT",
      },
      -- Set up diagnostics with Neovim globals
      diagnostics = {
        globals = { "vim" },
      },
      -- Configure workspace settings
      workspace = {
        library = vim.api.nvim_get_runtime_file("", true),
        checkThirdParty = false,
      },
      -- Enable inlay hints for better code readability
      hint = {
        enable = true,
      },
    },
  },
}
