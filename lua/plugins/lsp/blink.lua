-- lua/plugins/lsp/blink.lua
-- Tab suggestions + enhanced completion

return {
  "saghen/blink.cmp",
  dependencies = "rafamadriz/friendly-snippets",
  version = "*",
  event = { "InsertEnter", "CmdlineEnter" },
  opts = {
    keymap = {
      preset = "default",

      -- Enhanced Tab behavior for suggestions
      ["<Tab>"] = { "accept", "fallback" },
      ["<S-Tab>"] = { "select_prev", "fallback" },
      ["<C-Space>"] = { "show", "show_documentation", "hide_documentation" },
      ["<C-j>"] = { "select_next", "fallback" },
      ["<C-k>"] = { "select_prev", "fallback" },
    },

    appearance = {
      use_nvim_cmp_as_default = true,
      nerd_font_variant = "mono",
      kind_icons = require("core.icons").kind,
    },

    sources = {
      default = { "lsp", "path", "snippets", "buffer" },
      providers = {
        lsp = {
          name = "LSP",
          module = "blink.cmp.sources.lsp",
          enabled = true,
          transform_items = function(_, items)
            -- Boost important completion types
            for _, item in ipairs(items) do
              if item.kind == vim.lsp.protocol.CompletionItemKind.Snippet then
                item.priority = item.priority + 3
              elseif
                item.kind == vim.lsp.protocol.CompletionItemKind.Function
                or item.kind == vim.lsp.protocol.CompletionItemKind.Method
              then
                item.priority = item.priority + 2
              end
            end
            return items
          end,
        },
        snippets = {
          name = "Snippets",
          module = "blink.cmp.sources.snippets",
          enabled = true,
          score_offset = 80, -- High priority
          opts = {
            friendly_snippets = true,
            search_paths = { vim.fn.stdpath("data") .. "/lazy/friendly-snippets" },
            global_snippets = { "all" },
            extended_filetypes = {
              javascript = { "javascript", "typescript", "jsdoc" },
              typescript = { "typescript", "javascript", "jsdoc" },
              vue = { "vue", "html", "css", "javascript", "typescript" },
              svelte = { "svelte", "html", "css", "javascript", "typescript" },
              astro = { "astro", "html", "css", "javascript", "typescript" },
              html = { "html", "css" },
              css = { "css", "scss" },
              scss = { "scss", "css" },
              python = { "python", "django" },
              lua = { "lua" },
              markdown = { "markdown" },
            },
          },
        },
        path = {
          name = "Path",
          module = "blink.cmp.sources.path",
          enabled = true,
          score_offset = -3,
          opts = {
            trailing_slash = false,
            label_trailing_slash = true,
            get_cwd = function(context)
              return vim.fn.expand(("#%d:p:h"):format(context.bufnr))
            end,
          },
        },
        buffer = {
          name = "Buffer",
          module = "blink.cmp.sources.buffer",
          enabled = true,
          score_offset = -5,
          opts = {
            get_bufnrs = function()
              local buffers = {}
              for _, winid in ipairs(vim.api.nvim_list_wins()) do
                local bufnr = vim.api.nvim_win_get_buf(winid)
                if vim.api.nvim_buf_is_valid(bufnr) and vim.bo[bufnr].buflisted then
                  table.insert(buffers, bufnr)
                end
              end
              return buffers
            end,
          },
        },
      },
    },

    completion = {
      accept = { auto_brackets = { enabled = true } },
      menu = { border = "rounded", auto_show = true },
      documentation = { auto_show = true, window = { border = "rounded" } },
      ghost_text = { enabled = true },
    },

    signature = { enabled = true, window = { border = "rounded" } },
  },
}
