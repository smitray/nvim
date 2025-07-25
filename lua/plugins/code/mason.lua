-- ~/.config/nvim/lua/plugins/code/mason.lua
-- Mason configuration for LSP, DAP, linter, and formatter installation

return {
  "williamboman/mason.nvim",
  -- Load Mason on the "VeryLazy" event. This is a good default for plugins
  -- that need to be available early on, but not immediately on startup.
  event = "VeryLazy",
  cmd = "Mason",
  keys = { { "<leader>cm", "<cmd>Mason<cr>", desc = "[C]ode [M]ason" } },
  build = ":MasonUpdate", -- Run MasonUpdate on build to keep tools updated
  opts = {
    -- A list of packages to automatically install if they are not already installed.
    -- This is handled automatically by mason.nvim.
    ensure_installed = {
      -- LSP Servers
      "lua-language-server",

      -- Formatters
      "stylua",
    },
    -- UI settings for the Mason window.
    ui = {
      border = vim.g.border_enabled and "rounded" or "none",
      check_outdated_packages_on_open = false,
      icons = {
        package_pending = " ",
        package_installed = " ",
        package_uninstalled = " ",
      },
    },
  },
  -- The config function is optional if you only need to pass options to the setup function.
  -- lazy.nvim will automatically call require("mason").setup(opts) for you.
  -- We include it here for clarity and potential future additions.
  config = function(_, opts)
    require("mason").setup(opts)
  end,
}