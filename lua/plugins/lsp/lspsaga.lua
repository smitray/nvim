-- lua/plugins/lsp/lspsaga.lua
-- Enhanced LSP UI with refactoring capabilities

return {
  "nvimdev/lspsaga.nvim",
  event = "LspAttach",
  dependencies = {
    "nvim-treesitter/nvim-treesitter",
    "echasnovski/mini.icons",
  },

  config = function()
    local icons = require("core.icons")

    require("lspsaga").setup({
      ui = {
        border = "rounded",
        winblend = 0,
        expand = icons.ui.ArrowOpen,
        collapse = icons.ui.ArrowClosed,
        code_action = icons.ui.Ligthbulb,
        incoming = icons.ui.Incoming,
        outgoing = icons.ui.Outgoing,
        hover = icons.ui.Comment,
        kind = icons.kind,
      },

      -- Enhanced hover
      hover = {
        max_width = 0.6,
        max_height = 0.8,
        open_link = "gx",
        open_browser = "!open",
      },

      -- Diagnostic configuration
      diagnostic = {
        show_code_action = true,
        show_source = true,
        jump_num_shortcut = true,
        max_width = 0.7,
        max_height = 0.6,
        text_hl_follow = true,
        border_follow = true,
        keys = {
          exec_action = "o",
          quit = "q",
          expand_or_jump = "<CR>",
          quit_in_show = { "q", "<ESC>" },
        },
      },

      -- Enhanced code action with refactoring
      code_action = {
        num_shortcut = true,
        show_server_name = false,
        extend_gitsigns = true,
        keys = {
          quit = "q",
          exec = "<CR>",
        },
      },

      -- Lightbulb for code actions
      lightbulb = {
        enable = true,
        enable_in_insert = false,
        sign = false,
        sign_priority = 40,
        virtual_text = true,
      },

      -- Enhanced finder
      finder = {
        max_height = 0.5,
        left_width = 0.4,
        right_width = 0.6,
        default = "ref+imp",
        layout = "float",
        keys = {
          jump_to = "p",
          expand_or_jump = "o",
          vsplit = "s",
          split = "i",
          tabe = "t",
          quit = { "q", "<ESC>" },
        },
      },

      -- Enhanced rename with project-wide support
      rename = {
        quit = "<C-c>",
        exec = "<CR>",
        mark = "x",
        confirm = "<CR>",
        in_select = true,
        auto_save = false,
        project_max_width = 0.5,
        project_max_height = 0.5,
        keys = {
          quit = "<Esc>",
          exec = "<CR>",
        },
      },

      -- Outline configuration
      outline = {
        win_position = "right",
        win_width = 30,
        preview_width = 0.4,
        show_detail = true,
        auto_preview = true,
        auto_refresh = true,
        auto_close = true,
        keys = {
          expand_or_jump = "o",
          quit = "q",
        },
      },

      -- Call hierarchy for refactoring
      callhierarchy = {
        show_detail = false,
        keys = {
          edit = "e",
          vsplit = "s",
          split = "i",
          tabe = "t",
          jump = "o",
          quit = "q",
          expand_collapse = "u",
        },
      },

      -- Symbol in winbar
      symbol_in_winbar = {
        enable = true,
        separator = " › ",
        hide_keyword = true,
        show_file = true,
        folder_level = 2,
        color_mode = true,
      },

      -- Beacon for jump visualization
      beacon = {
        enable = true,
        frequency = 7,
      },

      request_timeout = 2000,
    })
  end,

  -- Enhanced keymaps for refactoring and navigation
  keys = {
    -- Enhanced LSP navigation with Saga UI
    { "gh", "<cmd>Lspsaga finder<CR>", desc = "[g]o [h]ere (LSP finder)" },
    { "gp", "<cmd>Lspsaga peek_definition<CR>", desc = "[g]o [p]eek definition" },
    { "gP", "<cmd>Lspsaga peek_type_definition<CR>", desc = "[g]o [P]eek type definition" },

    -- Enhanced diagnostics
    { "gl", "<cmd>Lspsaga show_line_diagnostics<CR>", desc = "[g]o [l]ine diagnostics" },
    { "[e", "<cmd>Lspsaga diagnostic_jump_prev<CR>", desc = "diagnostic pr[e]vious" },
    { "]e", "<cmd>Lspsaga diagnostic_jump_next<CR>", desc = "diagnostic n[e]xt" },
    {
      "[E",
      function()
        require("lspsaga.diagnostic"):goto_prev({ severity = vim.diagnostic.severity.ERROR })
      end,
      desc = "error pr[E]vious",
    },
    {
      "]E",
      function()
        require("lspsaga.diagnostic"):goto_next({ severity = vim.diagnostic.severity.ERROR })
      end,
      desc = "error n[E]xt",
    },

    -- Enhanced code actions with refactoring
    { "<leader>ca", "<cmd>Lspsaga code_action<CR>", desc = "[c]ode [a]ction", mode = { "n", "v" } },

    -- Enhanced rename operations
    { "<leader>cr", "<cmd>Lspsaga rename<CR>", desc = "[c]ode [r]ename" },
    { "<leader>cR", "<cmd>Lspsaga rename ++project<CR>", desc = "[c]ode [R]ename project-wide" },

    -- Outline and navigation
    { "<leader>co", "<cmd>Lspsaga outline<CR>", desc = "[c]ode [o]utline" },

    -- Call hierarchy for refactoring
    { "<leader>ci", "<cmd>Lspsaga incoming_calls<CR>", desc = "[c]ode [i]ncoming calls" },
    { "<leader>cO", "<cmd>Lspsaga outgoing_calls<CR>", desc = "[c]ode [O]utgoing calls" },

    -- Enhanced hover
    { "<leader>K", "<cmd>Lspsaga hover_doc<CR>", desc = "hover documentation (saga)" },
    { "<leader>ck", "<cmd>Lspsaga hover_doc ++keep<CR>", desc = "[c]ode hover [k]eep" },

    -- Terminal integration
    { "<leader>ct", "<cmd>Lspsaga term_toggle<CR>", desc = "[c]ode [t]erminal toggle" },
  },
}
