-- lua/plugins/lsp/lspconfig.lua
return {
  "neovim/nvim-lspconfig",
  event = { "BufReadPre", "BufNewFile" },
  dependencies = {
    "williamboman/mason-lspconfig.nvim",
    "b0o/schemastore.nvim", -- JSON/YAML schemas
  },
  config = function()
    local lspconfig = require("lspconfig")
    local mason_lspconfig = require("mason-lspconfig")
    local opts = require("core.lsp-opts")

    -- Enhanced diagnostic signs with shared icons
    local icons = require("core.icons")
    local signs = {
      Error = icons.diagnostics.Error,
      Warn = icons.diagnostics.Warning,
      Hint = icons.diagnostics.Hint,
      Info = icons.diagnostics.Information,
    }

    for type, icon in pairs(signs) do
      local hl = "DiagnosticSign" .. type
      vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
    end

    -- Enhanced diagnostic configuration
    vim.diagnostic.config({
      underline = true,
      update_in_insert = false,
      severity_sort = true,
      virtual_text = {
        spacing = 4,
        source = "if_many",
        prefix = "●",
        severity = { min = vim.diagnostic.severity.HINT },
        format = function(diagnostic)
          -- Limit virtual text length for readability
          local message = diagnostic.message
          if #message > 50 then
            return message:sub(1, 47) .. "..."
          end
          return message
        end,
      },
      float = {
        border = "rounded",
        source = "always",
        header = "",
        prefix = "",
        focusable = false,
        max_width = 80,
        max_height = 20,
        wrap = true,
        close_events = { "BufLeave", "CursorMoved", "InsertEnter", "FocusLost" },
      },
      signs = {
        severity = { min = vim.diagnostic.severity.HINT },
      },
    })

    -- Configure LSP handlers for better UI
    vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
      border = "rounded",
      max_width = 80,
      max_height = 20,
      focusable = true,
      close_events = { "BufLeave", "CursorMoved", "InsertEnter" },
    })

    vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, {
      border = "rounded",
      max_width = 80,
      max_height = 15,
      focusable = false,
      close_events = { "CursorMoved", "InsertEnter" },
    })

    -- Enhanced progress handler integration with fidget
    local function progress_handler(_, result, ctx)
      local client_id = ctx.client_id
      local val = result.value

      if not val.kind then
        return
      end

      local client = vim.lsp.get_client_by_id(client_id)
      if not client then
        return
      end

      -- Let fidget handle the progress display
      vim.lsp.handlers["$/progress"](_, result, ctx)

      -- Optional: Add custom handling for specific progress events
      if val.kind == "end" and val.message then
        vim.defer_fn(function()
          vim.notify(string.format("%s: %s", client.name, val.message), vim.log.levels.INFO, { title = "LSP Complete" })
        end, 500)
      end
    end

    vim.lsp.handlers["$/progress"] = progress_handler

    -- Enhanced LSP setup with better error handling and logging
    mason_lspconfig.setup_handlers({
      -- Default handler for all servers
      function(server_name)
        local server_config = {}

        -- Try to load server-specific configuration
        local ok, server_opts = pcall(require, "plugins.lsp.servers." .. server_name)
        if ok then
          server_config = server_opts
          vim.notify(
            string.format("Loaded custom config for %s", server_name),
            vim.log.levels.DEBUG,
            { title = "LSP Config" }
          )
        else
          vim.notify(
            string.format("Using default config for %s", server_name),
            vim.log.levels.DEBUG,
            { title = "LSP Config" }
          )
        end

        -- Merge with default options
        local setup_opts = vim.tbl_deep_extend("force", {
          on_attach = opts.on_attach,
          capabilities = opts.capabilities,
          flags = {
            debounce_text_changes = 150,
          },
        }, server_config)

        -- Additional server-specific configurations
        if server_name == "lua_ls" then
          -- Enhanced Lua setup for Neovim development
          setup_opts.on_init = function(client)
            local path = client.workspace_folders[1].name
            if not vim.uv.fs_stat(path .. "/.luarc.json") and not vim.uv.fs_stat(path .. "/.luarc.jsonc") then
              client.config.settings = vim.tbl_deep_extend("force", client.config.settings, {
                Lua = {
                  runtime = { version = "LuaJIT" },
                  workspace = {
                    checkThirdParty = false,
                    library = { vim.env.VIMRUNTIME },
                  },
                },
              })
              client.notify("workspace/didChangeConfiguration", { settings = client.config.settings })
            end
            return true
          end
        end

        -- Attempt to setup the server
        local lsp_ok, err = pcall(lspconfig[server_name].setup, setup_opts)
        if not lsp_ok then
          vim.notify(
            string.format("Failed to setup %s: %s", server_name, tostring(err)),
            vim.log.levels.ERROR,
            { title = "LSP Error" }
          )
        else
          vim.notify(
            string.format("Successfully configured %s", server_name),
            vim.log.levels.INFO,
            { title = "LSP Setup" }
          )
        end
      end,

      -- Special handlers for specific servers that need extra care
      ["tsserver"] = function()
        -- TypeScript server with enhanced configuration
        local server_opts = {}
        local ok, custom_opts = pcall(require, "plugins.lsp.servers.tsserver")
        if ok then
          server_opts = custom_opts
        end

        lspconfig.tsserver.setup(vim.tbl_deep_extend("force", {
          on_attach = function(client, bufnr)
            -- Disable tsserver formatting in favor of prettier/biome
            client.server_capabilities.documentFormattingProvider = false
            client.server_capabilities.documentRangeFormattingProvider = false

            opts.on_attach(client, bufnr)
          end,
          capabilities = opts.capabilities,
          init_options = {
            preferences = {
              disableSuggestions = true,
            },
          },
        }, server_opts))
      end,

      ["eslint"] = function()
        -- ESLint with flat config support
        local server_opts = {}
        local ok, custom_opts = pcall(require, "plugins.lsp.servers.eslint")
        if ok then
          server_opts = custom_opts
        end

        lspconfig.eslint.setup(vim.tbl_deep_extend("force", {
          on_attach = function(client, bufnr)
            opts.on_attach(client, bufnr)

            -- Auto-fix on save
            vim.api.nvim_create_autocmd("BufWritePre", {
              buffer = bufnr,
              command = "EslintFixAll",
            })
          end,
          capabilities = opts.capabilities,
        }, server_opts))
      end,
    })

    -- LSP-related autocommands
    local lsp_group = vim.api.nvim_create_augroup("LspConfig", { clear = true })

    -- Show LSP status in command line
    vim.api.nvim_create_autocmd("LspAttach", {
      group = lsp_group,
      callback = function(args)
        local client = vim.lsp.get_client_by_id(args.data.client_id)
        if client then
          vim.notify(
            string.format("LSP %s attached to %s", client.name, vim.api.nvim_buf_get_name(args.buf)),
            vim.log.levels.DEBUG,
            { title = "LSP Attach" }
          )
        end
      end,
    })

    -- Clean up when LSP detaches
    vim.api.nvim_create_autocmd("LspDetach", {
      group = lsp_group,
      callback = function(args)
        local client = vim.lsp.get_client_by_id(args.data.client_id)
        if client then
          vim.notify(
            string.format("LSP %s detached from %s", client.name, vim.api.nvim_buf_get_name(args.buf)),
            vim.log.levels.DEBUG,
            { title = "LSP Detach" }
          )
        end
      end,
    })

    -- Auto-restart LSP servers if they crash
    vim.api.nvim_create_autocmd("LspDetach", {
      group = lsp_group,
      callback = function(args)
        local client = vim.lsp.get_client_by_id(args.data.client_id)
        if client and client.is_stopped() then
          vim.defer_fn(function()
            vim.notify(
              string.format("Attempting to restart %s", client.name),
              vim.log.levels.WARN,
              { title = "LSP Restart" }
            )
            vim.cmd("LspRestart")
          end, 1000)
        end
      end,
    })
  end,
}
