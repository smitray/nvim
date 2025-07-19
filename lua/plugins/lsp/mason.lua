return {
  "williamboman/mason.nvim",
  build = ":MasonUpdate",
  cmd = { "Mason", "MasonInstall", "MasonUninstall", "MasonUpdate" },
  keys = {
    { "<leader>cm", "<cmd>Mason<cr>", desc = "[c]ode [m]ason" },
  },
  dependencies = {
    "williamboman/mason-lspconfig.nvim",
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    {
      "j-hui/fidget.nvim",
      opts = {
        notification = { window = { winblend = 0, border = "rounded" } },
      },
    },
    {
      "folke/lazydev.nvim",
      ft = "lua",
      opts = {
        library = {
          { path = "lazy.nvim", words = { "lazy" } },
          { path = "snacks.nvim", words = { "snacks" } },
        },
      },
    },
  },
  config = function()
    require("mason").setup({
      ui = { border = "rounded", width = 0.8, height = 0.8 },
    })

    require("mason-lspconfig").setup({
      ensure_installed = {
        "lua_ls",
        "pyright",
        "ruff",
        "vtsls",
        "eslint",
        "biome",
        "vue-language-server",
        "svelte",
        "astro",
        "html",
        "cssls",
        "emmet_ls",
        "jsonls",
        "yamlls",
        "taplo",
        "bashls",
        "marksman",
      },
      automatic_installation = true,
    })

    require("mason-tool-installer").setup({
      ensure_installed = { "stylua", "black", "isort", "prettier", "shfmt" },
      auto_update = false,
      run_on_start = true,
    })
  end,
}
