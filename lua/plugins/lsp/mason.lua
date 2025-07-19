-- lua/plugins/lsp/mason.lua
return {
  "williamboman/mason.nvim",
  build = ":MasonUpdate",
  cmd = { "Mason", "MasonInstall", "MasonUninstall", "MasonUpdate" },
  keys = {
    { "<leader>cm", "<cmd>Mason<cr>", desc = "[c]ode [m]ason" },
  },
  config = function()
    require("mason").setup({
      ui = {
        border = "rounded",
        width = 0.8,
        height = 0.8,
        icons = {
          package_installed = "✓",
          package_pending = "➜",
          package_uninstalled = "✗"
        },
        keymaps = {
          toggle_package_expand = "<CR>",
          install_package = "i",
          update_package = "u",
          check_package_version = "c",
          update_all_packages = "U",
          check_outdated_packages = "C",
          uninstall_package = "X",
          cancel_installation = "<C-c>",
          apply_language_filter = "<C-f>",
        },
      },
      -- Increase timeout for slow networks
      install_root_dir = vim.fn.stdpath("data") .. "/mason",
      pip = {
        upgrade_pip = false,
      },
      log_level = vim.log.levels.INFO,
    })

    -- Enhanced mason-lspconfig setup
    require("mason-lspconfig").setup({
      ensure_installed = {
        -- Modern Vue + TypeScript setup (primary)
        "vtsls",                -- Modern TS server with Vue plugin
        "vue-language-server",  -- Vue SFC support

        -- Traditional TypeScript (fallback)
        "ts_ls",               -- Traditional typescript-language-server

        -- Core languages
        "lua_ls",              -- Lua
        "pyright",             -- Python type checking
        "ruff_lsp",            -- Python linting (fast)

        -- Web fundamentals
        "html",                -- HTML
        "cssls",               -- CSS/SCSS/Less
        "emmet_ls",            -- Emmet for HTML/CSS

        -- JavaScript/TypeScript ecosystem
        "eslint",              -- ESLint LSP server
        "biome",               -- Biome LSP server (modern alternative)

        -- Modern web frameworks
        "svelte",              -- Svelte/SvelteKit
        "astro",               -- Astro framework

        -- Configuration & data formats
        "jsonls",              -- JSON
        "yamlls",              -- YAML
        "taplo",               -- TOML

        -- System & utilities
        "bashls",              -- Bash scripting
        "marksman",            -- Markdown with wiki links
      },
      automatic_installation = true,
      handlers = nil, -- Will be set up in lspconfig.lua
    })

    -- Enhanced mason-tool-installer setup
    require("mason-tool-installer").setup({
      ensure_installed = {
        -- Lua ecosystem
        "stylua",           -- Lua formatter

        -- Python ecosystem
        "black",            -- Python formatter
        "isort",            -- Python import sorter

        -- Web & JavaScript ecosystem
        "prettierd",        -- Fast Prettier daemon

        -- Shell scripting
        "shfmt",            -- Shell script formatter

        -- Additional tools you might want
        -- "eslint_d",      -- Fast ESLint daemon
        -- "djlint",        -- Django/Jinja template linter
        -- "commitlint",    -- Commit message linter
      },
      auto_update = false,
      run_on_start = true,
      start_delay = 3000, -- 3 second delay after neovim starts
      debounce_hours = 5, -- Only attempt to install if tool not checked in last 5 hours
    })
  end,
  dependencies = {
    "williamboman/mason-lspconfig.nvim",
    "WhoIsSethDaniel/mason-tool-installer.nvim",

    -- Schema support for JSON/YAML
    "b0o/schemastore.nvim",

    -- LSP progress notifications (integrates with snacks)
    {
      "j-hui/fidget.nvim",
      opts = {
        notification = {
          window = {
            winblend = 0,
            border = "rounded",
          },
        },
        progress = {
          display = {
            render_limit = 16,
            done_ttl = 3,
            done_icon = "✓",
            done_style = "Constant",
            progress_ttl = math.huge,
            progress_icon = { pattern = "dots", period = 1 },
            progress_style = "WarningMsg",
            group_style = "Title",
            icon_style = "Question",
            priority = 30,
          },
          ignore_done_already = false,
          ignore_empty_message = false,
          clear_on_detach = function(client_id)
            local client = vim.lsp.get_client_by_id(client_id)
            return client and client.name or nil
          end,
          notification_group = function(msg)
            return msg.lsp_client_name
          end,
        },
      },
    },

    -- Enhanced Lua development with Neovim API
    {
      "folke/lazydev.nvim",
      ft = "lua",
      opts = {
        library = {
          -- Load lazy.nvim types when the `lazy` keyword is found
          { path = "lazy.nvim", words = { "lazy" } },
          -- Load snacks types when snacks keyword is found
          { path = "snacks.nvim", words = { "snacks" } },
        },
        enabled = function(root_dir)
          -- Only enable in your neovim config or plugin directories
          return vim.g.lazydev_enabled == nil and true
            or vim.g.lazydev_enabled
            or root_dir:find(vim.fn.stdpath("config"), 1, true)
            or root_dir:find(vim.fn.stdpath("data"), 1, true)
        end,
      },
    },
  },
}
