-- lua/plugins/lsp/lspsaga.lua
return {
  "nvimdev/lspsaga.nvim",
  event = "LspAttach",
  config = function()
    local icons = require("core.icons")

    require("lspsaga").setup({
      ui = {
        border = "rounded",
        winblend = 0,
        expand = "",
        collapse = "",
        code_action = "💡",
        incoming = " ",
        outgoing = " ",
        hover = " ",
        kind = icons.kind,
      },

      -- Hover configuration
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
        max_show_width = 0.9,
        max_show_height = 0.6,
        text_hl_follow = true,
        border_follow = true,
        wrap_long_lines = true,
        keys = {
          exec_action = "o",
          quit = "q",
          toggle_or_jump = "<CR>",
          quit_in_show = { "q", "<ESC>" },
        },
      },

      -- Code action configuration
      code_action = {
        num_shortcut = true,
        show_server_name = false,
        extend_gitsigns = true,
        keys = {
          quit = "q",
          exec = "<CR>",
        },
      },

      -- Lightbulb configuration
      lightbulb = {
        enable = true,
        enable_in_insert = false,
        sign = false,
        sign_priority = 40,
        virtual_text = true,
      },

      -- Finder configuration
      finder = {
        max_height = 0.5,
        left_width = 0.4,
        right_width = 0.6,
        methods = {},
        default = "ref+imp",
        layout = "float",
        silent = false,
        filter = {},
        fname_sub = nil,
        sp_inexist = false,
        sp_global = false,
        ly_botright = false,
        keys = {
          jump_to = "p",
          expand_or_jump = "o",
          vsplit = "s",
          split = "i",
          tabe = "t",
          tabnew = "r",
          quit = { "q", "<ESC>" },
          close_in_preview = "<ESC>",
        },
      },

      -- Definition configuration
      definition = {
        edit = "<C-c>o",
        vsplit = "<C-c>v",
        split = "<C-c>i",
        tabe = "<C-c>t",
        quit = "q",
        close = "<Esc>",
      },

      -- Rename configuration
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
        win_with = "",
        win_width = 30,
        preview_width = 0.4,
        show_detail = true,
        auto_preview = true,
        auto_refresh = true,
        auto_close = true,
        auto_resize = false,
        custom_sort = nil,
        keys = {
          expand_or_jump = "o",
          quit = "q",
        },
      },

      -- Callhierarchy configuration
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
        respect_root = false,
        color_mode = true,
      },

      -- Beacon for jump
      beacon = {
        enable = true,
        frequency = 7,
      },

      -- Request timeout
      request_timeout = 2000,
    })
  end,

  -- Enhanced keymaps with your [x]word [y]word format
  init = function()
    local map = vim.keymap.set
    local opts = { silent = true, noremap = true }

    -- LSP Saga specific navigation (enhanced UI)
    map("n", "gh", "<cmd>Lspsaga finder<CR>", vim.tbl_extend("force", opts, { desc = "[g]o [h]ere (LSP finder)" }))
    map("n", "gp", "<cmd>Lspsaga peek_definition<CR>", vim.tbl_extend("force", opts, { desc = "[g]o [p]eek definition" }))
    map("n", "gP", "<cmd>Lspsaga peek_type_definition<CR>", vim.tbl_extend("force", opts, { desc = "[g]o [P]eek type definition" }))

    -- Diagnostics with enhanced UI
    map("n", "gl", "<cmd>Lspsaga show_line_diagnostics<CR>", vim.tbl_extend("force", opts, { desc = "[g]o [l]ine diagnostics" }))
    map("n", "[e", "<cmd>Lspsaga diagnostic_jump_prev<CR>", vim.tbl_extend("force", opts, { desc = "diagnostic pr[e]vious" }))
    map("n", "]e", "<cmd>Lspsaga diagnostic_jump_next<CR>", vim.tbl_extend("force", opts, { desc = "diagnostic n[e]xt" }))

    -- Enhanced code actions
    map("n", "<leader>ca", "<cmd>Lspsaga code_action<CR>", vim.tbl_extend("force", opts, { desc = "[c]ode [a]ction (saga)" }))
    map("v", "<leader>ca", "<cmd>Lspsaga code_action<CR>", vim.tbl_extend("force", opts, { desc = "[c]ode [a]ction (saga)" }))

    -- Enhanced rename
    map("n", "<leader>cr", "<cmd>Lspsaga rename<CR>", vim.tbl_extend("force", opts, { desc = "[c]ode [r]ename (saga)" }))
    map("n", "<leader>cR", "<cmd>Lspsaga rename ++project<CR>", vim.tbl_extend("force", opts, { desc = "[c]ode [R]ename project-wide" }))

    -- Outline and navigation
    map("n", "<leader>co", "<cmd>Lspsaga outline<CR>", vim.tbl_extend("force", opts, { desc = "[c]ode [o]utline" }))

    -- Call hierarchy
    map("n", "<leader>ci", "<cmd>Lspsaga incoming_calls<CR>", vim.tbl_extend("force", opts, { desc = "[c]ode [i]ncoming calls" }))
    map("n", "<leader>cO", "<cmd>Lspsaga outgoing_calls<CR>", vim.tbl_extend("force", opts, { desc = "[c]ode [O]utgoing calls" }))

    -- Hover with enhanced UI (overrides default K)
    map("n", "<leader>K", "<cmd>Lspsaga hover_doc<CR>", vim.tbl_extend("force", opts, { desc = "hover [K]nowledge (saga)" }))
    map("n", "<leader>ck", "<cmd>Lspsaga hover_doc ++keep<CR>", vim.tbl_extend("force", opts, { desc = "[c]ode hover [k]eep" }))

    -- Terminal integration
    map("n", "<leader>ct", "<cmd>Lspsaga term_toggle<CR>", vim.tbl_extend("force", opts, { desc = "[c]ode [t]erminal toggle" }))
    map("t", "<leader>ct", "<cmd>Lspsaga term_toggle<CR>", vim.tbl_extend("force", opts, { desc = "[c]ode [t]erminal toggle" }))
  end,

  dependencies = {
    "nvim-treesitter/nvim-treesitter",
    "echasnovski/mini.icons",
    -- Ensure catppuccin is loaded for theme integration
    "catppuccin/nvim",
  },
}
