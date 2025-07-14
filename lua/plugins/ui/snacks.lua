-- ~/.config/nvim/lua/plugins/ui/snacks.lua
return {
  "folke/snacks.nvim",
  opts = {
    animate = {
      enabled = true,
      duration = 20,
      easing = "linear",
    },

    picker = {
      enabled = true,
      debounce = 10,
      throttle = 20,
      icons = {
        enabled = true,
        default = "󰈙",
        file = "󰈙",
        folder = "󰉋",
        git = "󰊢",
      },
      win = {
        backdrop = false,
      },
      previewers = {
        builtin = {
          extensions = {
            ["png"] = false,
            ["jpg"] = false,
            ["jpeg"] = false,
            ["gif"] = false,
            ["webp"] = false,
          },
        },
      },
      sources = {
        keymaps = {
          layout = "ivy_split",
        },
        explorer = {
          auto_close = true,
          layout = { layout = { position = "right" } },
        },
      },
    },

    explorer = {
      enabled = true,
      tree = false,
      auto_close = true,
      position = "right",
      width = 35,
      tree = {
        enabled = false,
        icons = {
          enabled = true,
          folder_closed = "󰉋",
          folder_open = "󰝰",
          file = "󰈙",
          git = {
            staged = "󰄬",
            unstaged = "󰄱",
            untracked = "󰋖",
            ignored = "󰈉",
          },
        },
        indent = {
          enabled = true,
          size = 2,
        },
      },
      actions = {
        files = {
          close_on_open = true,
        },
      },
    },

    bufdelete = {
      enabled = true,
      wipeout = false,
    },

    notifier = {
      enabled = true,
      timeout = 3000,
      width = { min = 40, max = 0.4 },
      height = { min = 1, max = 0.25 },
      margin = { top = 0, right = 1, bottom = 0 },
      padding = true,
      sort = { "level", "added" },
      level = vim.log.levels.INFO,
      icons = {
        error = "󰅚",
        warn = "󰀪",
        info = "󰋽",
        debug = "󰃤",
        trace = "󰻞",
      },
      style = "compact",
      top_down = true,
    },

    terminal = {
      enabled = true,
      bo = {
        filetype = "snacks_terminal",
      },
      wo = {},
      keys = {
        q = "hide",
        term_normal = { "<esc>", "<esc>", mode = "t", rhs = "<C-\\><C-n>", desc = "Double escape to normal mode" },
      },
    },

    scratch = {
      enabled = true,
      name = "scratch",
      ft = function()
        if vim.bo.buftype ~= "" then
          return vim.bo.filetype
        end
        return "markdown"
      end,
      icon = nil,
      root = vim.fn.stdpath("data") .. "/scratch",
      autowrite = true,
      filekey = {
        cwd = true,
        branch = true,
        count = true,
      },
      win = {
        width = 120,
        height = 40,
        bo = { bufhidden = "wipe" },
        minimal = false,
        noautocmd = false,
      },
    },

    rename = {
      enabled = true,
      notify = true,
    },

    lazygit = {
      enabled = true,
      configure = true,
      win = {
        width = 0.9,
        height = 0.9,
        border = "rounded",
      },
    },

    git = {
      enabled = true,
      blame = {
        enabled = true,
      },
      log = {
        enabled = true,
      },
    },

    words = {
      enabled = true,
      debounce = 100,
      notify_jump = false,
      foldopen = true,
      jumplist = true,
      modes = { "n", "v" },
    },

    zen = {
      enabled = true,
      toggles = {
        dim = true,
        git_signs = false,
        mini_diff = false,
        diagnostics = false,
        inlay_hints = false,
      },
      show = {
        statusline = false,
        tabline = false,
      },
      win = {
        width = 0.6,
        height = 0.8,
        options = {
          signcolumn = "no",
          number = false,
          relativenumber = false,
          cursorline = false,
          cursorcolumn = false,
          foldcolumn = "0",
          list = false,
        },
      },
    },

    dim = {
      enabled = true,
      animate = {
        enabled = true,
        duration = 100,
      },
      scope = {
        min_size = 5,
        max_size = 20,
        siblings = true,
      },
    },

    statuscolumn = {
      enabled = true,
      left = { "mark", "sign" },
      right = { "fold", "git" },
      folds = {
        open = false,
        git_hl = true,
      },
      git = {
        patterns = { "GitSigns", "MiniDiff" },
      },
    },

    indent = {
      enabled = true,
      indent = {
        enabled = true,
        char = "│",
        only_scope = false,
        only_current = false,
        hl = "SnacksIndent",
      },
      scope = {
        enabled = true,
        char = "│",
        underline = false,
        only_current = false,
        hl = "SnacksIndentScope",
      },
      chunk = {
        enabled = false,
      },
      blank = {
        enabled = false,
      },
    },

    quickfile = {
      enabled = true,
      exclude = { "gitsigns", "neo-tree" },
    },

    bigfile = {
      enabled = true,
      notify = true,
      size = 1.5 * 1024 * 1024,
      setup = function(ctx)
        vim.cmd("syntax off")
        vim.cmd("IlluminatePauseBuf") -- Remove if not using a plugin that provides this
        vim.opt_local.foldmethod = "manual"
        vim.opt_local.spell = false
        vim.opt_local.swapfile = false
        vim.opt_local.undofile = false
        vim.opt_local.breakindent = false
        vim.opt_local.colorcolumn = ""
        vim.opt_local.statuscolumn = ""
        vim.opt_local.signcolumn = "no"
        vim.schedule(function()
          vim.bo[ctx.buf].syntax = ctx.ft
        end)
      end,
    },

    toggle = {
      enabled = true,
      notify = true,
      which_key = true,
    },

    input = {
      enabled = true,
      win = {
        relative = "cursor",
        row = 1,
        col = 0,
        width = 60,
        height = 1,
        border = "rounded",
        title = " Input ",
        title_pos = "center",
        wo = {
          winhighlight = "Normal:SnacksInputNormal,FloatBorder:SnacksInputBorder,FloatTitle:SnacksInputTitle",
          cursorline = false,
        },
      },
    },
  },

  keys = {
    { "<leader>ds", function()
        local snacks = require("snacks")
        print("Snacks loaded:", snacks ~= nil)
        print("Picker available:", snacks.picker ~= nil)
        print("Explorer available:", snacks.explorer ~= nil)
      end, desc = "[d]ebug [s]nacks" },

    { "<leader><space>", function() require("snacks").picker.smart() end, desc = "Smart Find Files" },
    { "<leader>:", function() require("snacks").picker.command_history() end, desc = "Command History" },
    { "<leader>?", function() require("snacks").picker.search_history() end, desc = "Search History" },

    { "<leader>ff", function() require("snacks").picker.files() end, desc = "[f]ind [f]iles" },
    { "<leader>fg", function() require("snacks").picker.git_files() end, desc = "[f]ind [g]it files" },
    { "<leader>fr", function() require("snacks").picker.recent() end, desc = "[f]ind [r]ecent files" },
    { "<leader>fs", function() require("snacks").picker.smart() end, desc = "[f]ind [s]mart" },
    { "<leader>fp", function() require("snacks").picker.projects() end, desc = "[f]ind [p]rojects" },

    { "<leader>bl", function() require("snacks").picker.buffers() end, desc = "[b]uffer [l]ist" },
    { "<leader>bd", function() require("snacks").bufdelete() end, desc = "[b]uffer [d]elete" },
    { "<leader>bD", function() require("snacks").bufdelete.other() end, desc = "[b]uffer [D]elete others" },
    { "<leader>bw", function() require("snacks").bufdelete.wipeout() end, desc = "[b]uffer [w]ipeout" },

    { "<leader>sg", function() require("snacks").picker.grep() end, desc = "[s]earch [g]rep" },
    { "<leader>sw", function() require("snacks").picker.grep_word() end, desc = "[s]earch [w]ord under cursor", mode = { "n", "x" } },
    { "<leader>sb", function() require("snacks").picker.grep_buffers() end, desc = "[s]earch [b]uffers" },
    { "<leader>sl", function() require("snacks").picker.lines() end, desc = "[s]earch [l]ines" },
    { "<leader>sr", function() require("snacks").picker.resume() end, desc = "[s]earch [r]esume" },

    -- Explorer
    { "<leader>e", function() require("snacks").explorer() end, desc = "[e]xplorer toggle" },
    -- Consolidated: <leader>E now always opens to the project root
    { "<leader>E", function()
        local utils = require("core.utils") -- Explicitly require your utils module
        local project_root = utils.get_project_root()
        require("snacks").explorer({ cwd = project_root, focus = true })
      end, desc = "[E]xplorer project root" },

    -- Git Integration
    { "<leader>gd", function() require("snacks").picker.git_diff() end, desc = "[g]it [d]iff" },
    { "<leader>gs", function() require("snacks").picker.git_status() end, desc = "[g]it [s]tatus" },
    { "<leader>gl", function() require("snacks").picker.git_log_file() end, desc = "[g]it [l]og file" },
    { "<leader>gg", function() require("snacks").lazygit() end, desc = "[g]it lazy[g]it" },
    { "<leader>gB", function() require("snacks").gitbrowse() end, desc = "[g]it [B]rowse", mode = { "n", "v" } },

    -- LSP & Diagnostics
    { "gd", function() require("snacks").picker.lsp_definitions() end, desc = "Goto Definition" },
    { "gD", function() require("snacks").picker.lsp_declarations() end, desc = "Goto Declaration" },
    { "gr", function() require("snacks").picker.lsp_references() end, nowait = true, desc = "References" },
    { "gI", function() require("snacks").picker.lsp_implementations() end, desc = "Goto Implementation" },
    { "gy", function() require("snacks").picker.lsp_type_definitions() end, desc = "Goto T[y]pe Definition" },
    { "<leader>ld", function() require("snacks").picker.diagnostics() end, desc = "[l]sp [d]iagnostics" },
    { "<leader>lD", function() require("snacks").picker.diagnostics_buffer() end, desc = "[l]sp [D]iagnostics buffer" },
    { "<leader>ls", function() require("snacks").picker.lsp_symbols() end, desc = "[l]sp [s]ymbols" },
    { "<leader>lS", function() require("snacks").picker.lsp_workspace_symbols() end, desc = "[l]sp [S]ymbols workspace" },

    -- Terminal
    { "<leader>tt", function() require("snacks").terminal() end, desc = "[t]erminal [t]oggle float" },
    { "<leader>ts", function() require("snacks").terminal.toggle("split") end, desc = "[t]erminal [s]plit bottom" },
    { "<c-/>", function() require("snacks").terminal() end, desc = "Toggle Terminal" },
    { "<c-_>", function() require("snacks").terminal() end, desc = "which_key_ignore" },

    -- Commands
    { "<leader>uc", function() require("snacks").picker.commands() end, desc = "[u]tility [c]ommands" },
    { "<leader>uk", function() require("snacks").picker.keymaps() end, desc = "[u]tility [k]eymaps" },
    { "<leader>uh", function() require("snacks").picker.help() end, desc = "[u]tility [h]elp" },

    -- Utilities
    { "<leader>ur", function() require("snacks").picker.registers() end, desc = "[u]tility [r]egisters" },
    { "<leader>un", function() require("snacks").picker.notifications() end, desc = "[u]tility [n]otifications" },
    { "<leader>uu", function() require("snacks").picker.undo() end, desc = "[u]tility [u]ndo" },

    -- Notes
    { "<leader>ns", function() require("snacks").scratch() end, desc = "[n]otes [s]cratch" },
    { "<leader>nS", function() require("snacks").scratch.select() end, desc = "[n]otes [S]cratch select" },

    -- Word Navigation
    { "]]", function() require("snacks").words.jump(vim.v.count1) end, desc = "Next Reference", mode = { "n", "t" } },
    { "[[", function() require("snacks").words.jump(-vim.v.count1) end, desc = "Prev Reference", mode = { "n", "t" } },

    -- Zen Mode
    { "<leader>z", function() require("snacks").zen() end, desc = "[z]en mode" },
    { "<leader>Z", function() require("snacks").zen.zoom() end, desc = "[Z]en zoom" },

    -- Rename
    { "<leader>rn", function() require("snacks").rename.rename_file() end, desc = "[r]e[n]ame file" },

    -- Notification management
    { "<leader>nd", function() require("snacks").notifier.hide() end, desc = "[n]otification [d]ismiss" },
    { "<leader>nh", function() require("snacks").notifier.show_history() end, desc = "[n]otification [h]istory" },
  },

  config = function()
    local snacks = require("snacks")

    snacks.toggle.option("spell", { name = "Spelling" }):map("<leader>ts")
    snacks.toggle.option("wrap", { name = "Wrap" }):map("<leader>tw")
    snacks.toggle.option("relativenumber", { name = "Relative Number" }):map("<leader>tL")
    snacks.toggle.diagnostics():map("<leader>td")
    snacks.toggle.line_number():map("<leader>tl")
    snacks.toggle.option("conceallevel", { off = 0, on = vim.o.conceallevel > 0 and vim.o.conceallevel or 2 }):map("<leader>tc")
    snacks.toggle.treesitter():map("<leader>tT")
    snacks.toggle.option("background", { off = "light", on = "dark", name = "Dark Background" }):map("<leader>tb")
    snacks.toggle.inlay_hints():map("<leader>th")
    snacks.toggle.indent():map("<leader>ti")
    snacks.toggle.dim():map("<leader>tD")
    snacks.toggle.words():map("<leader>tW")

    vim.api.nvim_create_autocmd("ColorScheme", {
      callback = function()
        vim.api.nvim_set_hl(0, "SnacksIndent", { fg = "#45475a" })
        vim.api.nvim_set_hl(0, "SnacksIndentScope", { fg = "#89b4fa", bold = true })
        vim.api.nvim_set_hl(0, "SnacksInputNormal", { link = "NormalFloat" })
        vim.api.nvim_set_hl(0, "SnacksInputBorder", { link = "FloatBorder" })
        vim.api.nvim_set_hl(0, "SnacksInputTitle", { link = "Title" })
      end,
    })
    vim.cmd("doautocmd ColorScheme")
  end,
}
