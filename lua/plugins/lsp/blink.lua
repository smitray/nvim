-- lua/plugins/lsp/blink.lua
return {
  "saghen/blink.cmp",
  dependencies = {
    "rafamadriz/friendly-snippets", -- Collection of snippets for various languages
  },
  version = "*",
  event = { "InsertEnter", "CmdlineEnter" },

  opts = {
    keymap = {
      preset = "default",
      -- Custom keymaps following your format
      ["<C-y>"] = { "accept", "fallback" },
      ["<Tab>"] = { "accept", "fallback" },
      ["<C-n>"] = { "select_next", "fallback" },
      ["<C-p>"] = { "select_prev", "fallback" },
      ["<Down>"] = { "select_next", "fallback" },
      ["<Up>"] = { "select_prev", "fallback" },
      ["<C-d>"] = { "scroll_documentation_down", "fallback" },
      ["<C-u>"] = { "scroll_documentation_up", "fallback" },
      ["<C-Space>"] = { "show", "show_documentation", "hide_documentation" },
      ["<C-e>"] = { "hide", "fallback" },
    },

    appearance = {
      -- Use catppuccin styling
      use_nvim_cmp_as_default = true,
      nerd_font_variant = "mono",

      -- Use shared kind icons
      kind_icons = require("core.icons").kind,
    },

    sources = {
      default = { "lsp", "path", "snippets", "buffer" },

      -- Enhanced source configuration
      providers = {
        lsp = {
          name = "LSP",
          module = "blink.cmp.sources.lsp",
          enabled = true,
          -- Transform LSP items for better sorting
          transform_items = function(_, items)
            for _, item in ipairs(items) do
              -- Boost snippet and function priority
              if item.kind == 15 then -- Snippet
                item.priority = item.priority + 2
              elseif item.kind == 3 or item.kind == 2 then -- Function or Method
                item.priority = item.priority + 1
              end
            end
            return items
          end,
        },

        path = {
          name = "Path",
          module = "blink.cmp.sources.path",
          enabled = true,
          opts = {
            trailing_slash = false,
            label_trailing_slash = true,
            get_cwd = function(context)
              return vim.fn.expand(("#%d:p:h"):format(context.bufnr))
            end,
          },
        },

        snippets = {
          name = "Snippets",
          module = "blink.cmp.sources.snippets",
          enabled = true,
          score_offset = 80, -- High priority for snippets
          opts = {
            friendly_snippets = true,
            search_paths = { vim.fn.stdpath("data") .. "/lazy/friendly-snippets" },
            global_snippets = { "all" },
            extended_filetypes = {
              javascript = { "javascript", "typescript" },
              typescript = { "typescript", "javascript" },
              vue = { "vue", "html", "css", "javascript", "typescript" },
              svelte = { "svelte", "html", "css", "javascript" },
              astro = { "astro", "html", "css", "javascript", "typescript" },
              html = { "html", "css" },
              css = { "css", "scss" },
              scss = { "scss", "css" },
              python = { "python", "django" },
            },
          },
        },

        buffer = {
          name = "Buffer",
          module = "blink.cmp.sources.buffer",
          enabled = true,
          opts = {
            get_bufnrs = function()
              local buffers = {}
              -- Get all visible buffers for completion
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
      trigger = {
        signature_help = {
          enabled = true,
        },
        show_in_snippet = true,
        show_on_keyword = true,
        show_on_trigger_character = true,
      },

      accept = {
        auto_brackets = {
          enabled = true
        }
      },

      menu = {
        border = "rounded",
        max_height = 10,
        scrollbar = true,
        auto_show = true,
        selection = "preselect",

        draw = {
          treesitter = { "lsp" },
          columns = {
            { "kind_icon", "label", gap = 1 },
            { "label_description" },
          },
        },
      },

      documentation = {
        auto_show = true,
        auto_show_delay_ms = 200,
        window = {
          border = "rounded",
          scrollbar = true,
          max_width = 80,
          max_height = 20,
        },
      },

      ghost_text = {
        enabled = true,
      },
    },

    signature = {
      enabled = true,
      trigger = {
        blocked_trigger_characters = {},
        blocked_retrigger_characters = {},
        show_on_insert_on_trigger_character = true,
      },
      window = {
        border = "rounded",
        scrollbar = false,
        direction_priority = {
          cursor_above = { "s", "n" },
          cursor_below = { "n", "s" },
        },
      },
    },
  },

  opts_extend = { "sources.default" },

  config = function(_, opts)
    require("blink.cmp").setup(opts)

    -- Additional keymaps for snippet navigation
    local map = vim.keymap.set

    -- Enhanced snippet navigation with fallbacks
    map({ "i", "s" }, "<C-l>", function()
      if vim.snippet and vim.snippet.active({ direction = 1 }) then
        vim.snippet.jump(1)
      end
    end, { silent = true, desc = "[s]nippet [l]eap forward" })

    map({ "i", "s" }, "<C-h>", function()
      if vim.snippet and vim.snippet.active({ direction = -1 }) then
        vim.snippet.jump(-1)
      end
    end, { silent = true, desc = "[s]nippet [h]op backward" })

    -- Optional: Custom snippet loading from config directory
    vim.defer_fn(function()
      local snippet_path = vim.fn.stdpath("config") .. "/snippets"
      if vim.fn.isdirectory(snippet_path) == 1 then
        vim.notify("Loading custom snippets from " .. snippet_path, vim.log.levels.INFO)
        -- Add any custom snippet loading logic here if needed
      end
    end, 100)
  end,
}
