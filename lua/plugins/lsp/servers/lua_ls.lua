-- lua/plugins/lsp/servers/lua_ls.lua
-- Lua Language Server with Neovim runtime support

return {
  cmd = { "lua-language-server" },
  filetypes = { "lua" },
  root_dir = function(fname)
    local util = require("lspconfig.util")
    return util.root_pattern(
      ".luarc.json",
      ".luarc.jsonc",
      ".luacheckrc",
      ".stylua.toml",
      "stylua.toml",
      "selene.toml",
      "selene.yml",
      ".git"
    )(fname)
  end,
  on_init = function(client)
    if client.workspace_folders then
      local path = client.workspace_folders[1].name
      if
        path ~= vim.fn.stdpath("config")
        and (vim.uv.fs_stat(path .. "/.luarc.json") or vim.uv.fs_stat(path .. "/.luarc.jsonc"))
      then
        return
      end
    end

    client.config.settings.Lua = vim.tbl_deep_extend("force", client.config.settings.Lua, {
      runtime = {
        -- Tell the language server which version of Lua you're using
        version = "LuaJIT",
        -- Tell the language server how to find Lua modules
        path = {
          "lua/?.lua",
          "lua/?/init.lua",
        },
      },
      -- Make the server aware of Neovim runtime files
      workspace = {
        checkThirdParty = false,
        library = {
          vim.env.VIMRUNTIME,
          -- Add additional paths for common Lua libraries
          -- '${3rd}/luv/library',
          -- '${3rd}/busted/library',
        },
      },
    })
  end,
  on_attach = function(client, bufnr)
    -- Call the default on_attach
    require("core.lsp-opts").on_attach(client, bufnr)

    -- Disable lua_ls formatting in favor of stylua
    client.server_capabilities.documentFormattingProvider = false
    client.server_capabilities.documentRangeFormattingProvider = false

    -- Lua-specific commands
    vim.api.nvim_buf_create_user_command(bufnr, "LspLuaReload", function()
      client.stop()
      vim.defer_fn(function()
        vim.cmd("LspStart lua_ls")
      end, 500)
    end, { desc = "Restart Lua Language Server" })
  end,
  settings = {
    Lua = {
      semantic = { enable = false },
      hint = {
        enable = true,
        setType = false,
        paramType = true,
        paramName = "Disable",
        semicolon = "Disable",
        arrayIndex = "Disable",
      },
      diagnostics = {
        globals = {
          "vim",
          "describe",
          "it",
          "before_each",
          "after_each", -- busted
          "pending",
          "setup",
          "teardown", -- additional test globals
        },
        disable = { "missing-fields" },
      },
      telemetry = { enable = false },
      workspace = {
        checkThirdParty = false,
        maxPreload = 100000,
        preloadFileSize = 10000,
        library = {
          vim.env.VIMRUNTIME,
          "${3rd}/luv/library",
          "${3rd}/busted/library",
        },
      },
      completion = {
        callSnippet = "Replace",
      },
      format = {
        enable = false, -- Use stylua instead
      },
    },
  },
}
