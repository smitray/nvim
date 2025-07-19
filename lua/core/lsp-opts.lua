-- lua/plugins/lsp/opts.lua
-- Shared LSP capabilities and keymaps
-- THIS IS A UTILITY MODULE, NOT A PLUGIN SPEC

local M = {}

-- Enhanced on_attach function with snacks integration
M.on_attach = function(client, bufnr)
  local map = function(mode, lhs, rhs, desc)
    vim.keymap.set(mode, lhs, rhs, {
      buffer = bufnr,
      desc = desc,
      silent = true,
      noremap = true,
    })
  end

  -- LSP navigation using snacks.picker (clean, no fallbacks)
  map("n", "gd", function()
    require("snacks").picker.lsp_definitions()
  end, "[g]oto [d]efinition")
  map("n", "gD", function()
    require("snacks").picker.lsp_declarations()
  end, "[g]oto [D]eclaration")
  map("n", "gi", function()
    require("snacks").picker.lsp_implementations()
  end, "[g]oto [i]mplementation")
  map("n", "gy", function()
    require("snacks").picker.lsp_type_definitions()
  end, "[g]oto t[y]pe definition")
  map("n", "gr", function()
    require("snacks").picker.lsp_references()
  end, "[g]oto [r]eferences")

  -- Hover and signature help
  map("n", "K", vim.lsp.buf.hover, "[K] hover documentation")
  map("n", "<C-k>", vim.lsp.buf.signature_help, "signature [k]ey help")
  map("i", "<C-k>", vim.lsp.buf.signature_help, "signature [k]ey help")

  -- Code actions and refactoring
  map("n", "<leader>ca", vim.lsp.buf.code_action, "[c]ode [a]ction")
  map("x", "<leader>ca", vim.lsp.buf.code_action, "[c]ode [a]ction")
  map("n", "<leader>cr", vim.lsp.buf.rename, "[c]ode [r]ename")

  -- Note: <leader>cf formatting is handled by conform.nvim plugin

  -- Diagnostics with snacks integration
  map("n", "<leader>cd", function()
    vim.diagnostic.open_float({
      border = "rounded",
      source = "always",
      prefix = function(diagnostic, i, total)
        local level = vim.diagnostic.severity[diagnostic.severity]
        local prefix = string.format("%d. ", i)
        return prefix, "DiagnosticSign" .. level
      end,
    })
  end, "[c]ode [d]iagnostics")

  map("n", "[d", function()
    vim.diagnostic.goto_prev({ float = false })
    vim.cmd("normal! zz") -- Center the screen
  end, "[d]iagnostic previous")

  map("n", "]d", function()
    vim.diagnostic.goto_next({ float = false })
    vim.cmd("normal! zz") -- Center the screen
  end, "[d]iagnostic next")

  map("n", "<leader>cq", vim.diagnostic.setloclist, "[c]ode diagnostic [q]uickfix")

  -- Workspace management
  map("n", "<leader>wa", vim.lsp.buf.add_workspace_folder, "[w]orkspace [a]dd folder")
  map("n", "<leader>wr", vim.lsp.buf.remove_workspace_folder, "[w]orkspace [r]emove folder")
  map("n", "<leader>wl", function()
    local folders = vim.lsp.buf.list_workspace_folders()
    if #folders == 0 then
      vim.notify("No workspace folders", vim.log.levels.INFO)
    else
      vim.notify("Workspace folders:\n" .. table.concat(folders, "\n"), vim.log.levels.INFO)
    end
  end, "[w]orkspace [l]ist folders")

  -- Client info
  map("n", "<leader>cl", function()
    local clients = vim.lsp.get_active_clients({ bufnr = bufnr })
    if #clients == 0 then
      vim.notify("No LSP clients active", vim.log.levels.WARN)
      return
    end

    local client_info = {}
    for _, client in ipairs(clients) do
      table.insert(client_info, string.format("• %s (id: %d)", client.name, client.id))
    end

    vim.notify("Active LSP clients:\n" .. table.concat(client_info, "\n"), vim.log.levels.INFO)
  end, "[c]ode [l]sp clients")

  -- Toggle inlay hints (if supported)
  if client.supports_method("textDocument/inlayHint") then
    map("n", "<leader>ch", function()
      local current_setting = vim.lsp.inlay_hint.is_enabled({ bufnr = bufnr })
      vim.lsp.inlay_hint.enable(not current_setting, { bufnr = bufnr })
      local status = not current_setting and "enabled" or "disabled"
      vim.notify("Inlay hints " .. status, vim.log.levels.INFO)
    end, "[c]ode [h]ints toggle")
  end

  -- Document symbols using snacks.picker
  map("n", "<leader>cs", function()
    require("snacks").picker.lsp_symbols()
  end, "[c]ode [s]ymbols")
  map("n", "<leader>cS", function()
    require("snacks").picker.lsp_workspace_symbols()
  end, "[c]ode [S]ymbols workspace")

  -- Auto-commands for LSP
  local group = vim.api.nvim_create_augroup("LspAttach_" .. bufnr, { clear = true })

  -- Highlight symbol under cursor
  if client.supports_method("textDocument/documentHighlight") then
    vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
      buffer = bufnr,
      group = group,
      callback = vim.lsp.buf.document_highlight,
    })
    vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
      buffer = bufnr,
      group = group,
      callback = vim.lsp.buf.clear_references,
    })
  end

  -- Show diagnostic on hover (if no floating window is open)
  vim.api.nvim_create_autocmd("CursorHold", {
    buffer = bufnr,
    group = group,
    callback = function()
      -- Only show diagnostic if no floating window is currently open
      for _, win in ipairs(vim.api.nvim_list_wins()) do
        local config = vim.api.nvim_win_get_config(win)
        if config.relative ~= "" then
          return
        end
      end

      vim.diagnostic.open_float({
        focusable = false,
        close_events = { "BufLeave", "CursorMoved", "InsertEnter", "FocusLost" },
        border = "rounded",
        source = "always",
        prefix = " ",
        scope = "cursor",
      })
    end,
  })

  -- Notify when LSP client attaches
  vim.notify(
    string.format("LSP client '%s' attached to buffer %d", client.name, bufnr),
    vim.log.levels.INFO,
    { title = "LSP" }
  )
end

-- Enhanced capabilities with blink.cmp integration
M.capabilities = vim.tbl_deep_extend(
  "force",
  vim.lsp.protocol.make_client_capabilities(),
  -- Add blink.cmp capabilities if available, with fallback
  (function()
    local ok, blink = pcall(require, "blink.cmp")
    if ok and blink.get_lsp_capabilities then
      return blink.get_lsp_capabilities()
    else
      return {}
    end
  end)(),
  {
    textDocument = {
      completion = {
        completionItem = {
          snippetSupport = true,
          preselectSupport = true,
          insertReplaceSupport = true,
          labelDetailsSupport = true,
          deprecatedSupport = true,
          commitCharactersSupport = true,
          tagSupport = { valueSet = { 1 } },
          resolveSupport = {
            properties = {
              "documentation",
              "detail",
              "additionalTextEdits",
            },
          },
        },
      },
      foldingRange = {
        dynamicRegistration = false,
        lineFoldingOnly = true,
      },
      publishDiagnostics = {
        relatedInformation = true,
        versionSupport = false,
        tagSupport = {
          valueSet = { 1, 2 },
        },
        codeDescriptionSupport = true,
        dataSupport = true,
      },
    },
    workspace = {
      workspaceFolders = true,
      didChangeWatchedFiles = {
        dynamicRegistration = true,
      },
    },
  }
)

return M
