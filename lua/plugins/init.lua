-- ~/.config/nvim/lua/plugins/init.lua

-- Plugin specification loader

return {

  -- Import all plugin configurations

  { import = "plugins.ui" },

  { import = "plugins.lsp" },

  { import = "plugins.editor" },

  { import = "plugins.code" },

}
