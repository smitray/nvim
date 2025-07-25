-- ~/.config/nvim/lua/core/init.lua
-- Core configuration loader

-- Load core modules in order
require("core.options")
require("core.keymaps")
require("core.autocmd")
require("core.utils")
require("core.lsp") -- Load the new LSP module
require("core.lazy")
