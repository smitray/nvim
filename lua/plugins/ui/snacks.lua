-- ~/.config/nvim/lua/plugins/ui/snacks.lua
return {
  "folke/snacks.nvim",
  priority = 1000,
  lazy = false,

  ---@type snacks.Config
  opts = {
    picker = {
      enabled = true,
      sources = {
        explorer = {
          auto_close = true,
          layout = { layout = { position = "right" } },
        },
      },
    },
    explorer = {
      enabled = true,
      tree = false,
    },
    bufdelete = {
      enabled = true,
    },
    notifier = {
      enabled = true,
    },
    terminal = {
      enabled = true,

      -- Floating window configuration
      win = {
        style = "terminal",
        relative = "editor",
        position = "float",
        size = { width = 0.8, height = 0.8 },
        border = "rounded",
      },

      -- Buffer options
      bo = {
        filetype = "snacks_terminal",
      },

      -- Remove all keys - handle in autocmd like your original
      keys = {
        q = "hide",  -- Keep this as fallback
      },

      -- Terminal behavior
      interactive = true,  -- auto start insert mode
    },
    scratch = {
      enabled = true,
    },
  },

  keys = {
    -- File & Buffer Management (5 picker types)
    { "<leader><space>", function() require("snacks").picker.smart() end, desc = "Smart Find Files" },
    { "<leader>ff", function() require("snacks").picker.files() end, desc = "[f]ind [f]iles" },
    { "<leader>fr", function() require("snacks").picker.recent() end, desc = "[f]ind [r]ecent files" },
    { "<leader>bl", function() require("snacks").picker.buffers() end, desc = "[b]uffer [l]ist" },
    { "<leader>bd", function() require("snacks").bufdelete() end, desc = "[b]uffer [d]elete" },
    { "<leader>bD", function() require("snacks").bufdelete.other() end, desc = "[b]uffer [D]elete others" },
    { "<leader>bda", function() require("snacks").bufdelete.all() end, desc = "[b]uffer [d]elete [a]ll" },

    -- Search & Text (4 picker types)
    { "<leader>sg", function() require("snacks").picker.grep() end, desc = "[s]earch [g]rep" },
    { "<leader>sw", function() require("snacks").picker.grep_word() end, desc = "[s]earch [w]ord under cursor", mode = { "n", "x" } },
    { "<leader>sb", function() require("snacks").picker.grep_buffers() end, desc = "[s]earch [b]uffers" },
    { "<leader>sl", function() require("snacks").picker.lines() end, desc = "[s]earch [l]ines" },

    -- Project Navigation (1 picker type)
    { "<leader>fp", function() require("snacks").picker.projects() end, desc = "[f]ind [p]rojects" },

    -- Git Integration (6 picker types)
    { "<leader>gf", function() require("snacks").picker.git_files() end, desc = "[g]it [f]iles" },
    { "<leader>gd", function() require("snacks").picker.git_diff() end, desc = "[g]it [d]iff" },
    { "<leader>gs", function() require("snacks").picker.git_status() end, desc = "[g]it [s]tatus" },
    { "<leader>gl", function() require("snacks").picker.git_log_file() end, desc = "[g]it [l]og file" },
    { "<leader>gb", function() require("snacks").picker.git_branches() end, desc = "[g]it [b]ranches" },
    { "<leader>gc", function() require("snacks").picker.git_commits() end, desc = "[g]it [c]ommits" },

    -- Commands & Help (4 picker types)
    { "<leader>:", function() require("snacks").picker.command_history() end, desc = "Command History" },
    { "<leader>?", function() require("snacks").picker.search_history() end, desc = "Search History" },
    { "<leader>uc", function() require("snacks").picker.commands() end, desc = "[u]tility [c]ommands" },
    { "<leader>uk", function() require("snacks").picker.keymaps() end, desc = "[u]tility [k]eymaps" },
    { "<leader>uh", function() require("snacks").picker.help() end, desc = "[u]tility [h]elp" },

    -- LSP Integration (7 picker types)
    { "gd", function() require("snacks").picker.lsp_definitions() end, desc = "Goto Definition" },
    { "gD", function() require("snacks").picker.lsp_declarations() end, desc = "Goto Declaration" },
    { "gr", function() require("snacks").picker.lsp_references() end, nowait = true, desc = "References" },
    { "gI", function() require("snacks").picker.lsp_implementations() end, desc = "Goto Implementation" },
    { "gy", function() require("snacks").picker.lsp_type_definitions() end, desc = "Goto T[y]pe Definition" },
    { "<leader>ld", function() require("snacks").picker.diagnostics() end, desc = "[l]sp [d]iagnostics" },
    { "<leader>lD", function() require("snacks").picker.diagnostics_buffer() end, desc = "[l]sp [D]iagnostics buffer" },
    { "<leader>ls", function() require("snacks").picker.lsp_symbols() end, desc = "[l]sp [s]ymbols" },
    { "<leader>lS", function() require("snacks").picker.lsp_workspace_symbols() end, desc = "[l]sp [S]ymbols workspace" },

    -- Utilities (8 picker types)
    { "<leader>ur", function() require("snacks").picker.registers() end, desc = "[u]tility [r]egisters" },
    { "<leader>uu", function() require("snacks").picker.undo() end, desc = "[u]tility [u]ndo" },
    { "<leader>sr", function() require("snacks").picker.resume() end, desc = "[s]earch [r]esume" },
    { "<leader>un", function() require("snacks").picker.notifications() end, desc = "[u]tility [n]otifications" },
    { "<leader>uj", function() require("snacks").picker.jumps() end, desc = "[u]tility [j]umps" },
    { "<leader>uH", function() require("snacks").picker.highlights() end, desc = "[u]tility [H]ighlights" },
    { "<leader>ua", function() require("snacks").picker.autocmds() end, desc = "[u]tility [a]utocmds" },
    { "z=", function() require("snacks").picker.spelling() end, desc = "Spelling suggestions" },

    -- Notifications
    { "<leader>nd", function() require("snacks").notifier.hide() end, desc = "[n]otification [d]ismiss" },
    { "<leader>nh", function() require("snacks").notifier.show_history() end, desc = "[n]otification [h]istory" },

    -- Terminal (toggle with double ESC to close)
    { "<leader>tt", function() require("snacks").terminal.toggle() end, desc = "[t]erminal [t]oggle" },

    -- Scratch Notes (project-scoped journal with ESC to save & close)
    { "<leader>ns", function()
        -- Use existing utils function
        local utils = require("core.utils")
        local project_root = utils.get_project_root()
        local journal_path = project_root .. "/journal.md"
        vim.notify("Journal path: " .. journal_path, vim.log.levels.INFO)


        -- Debug: Print the paths to see what's happening
        print("Project root:", project_root)
        print("Journal path:", journal_path)

        -- Check if buffer already exists for this file
        local buf = vim.fn.bufnr(journal_path)

        if buf == -1 then
          -- Buffer doesn't exist, create it
          buf = vim.fn.bufadd(journal_path)
          vim.fn.bufload(buf)
        end

        -- Create floating window with the buffer
        local width = 120
        local height = 40
        local win_width = vim.o.columns
        local win_height = vim.o.lines
        local row = math.ceil((win_height - height) / 2)
        local col = math.ceil((win_width - width) / 2)

        local win = vim.api.nvim_open_win(buf, true, {
          relative = "editor",
          width = width,
          height = height,
          row = row,
          col = col,
          style = "minimal",
          border = "rounded",
          title = " Project Journal ",
          title_pos = "center",
        })

        -- Set up the buffer
        vim.bo[buf].filetype = "markdown"
        vim.opt_local.spell = true
        vim.opt_local.spelllang = "en_us"
      end, desc = "[n]otes [s]cratch journal" },

    -- Explorer
    { "<leader>e", function() require("snacks").explorer() end, desc = "[e]xplorer toggle" },
    { "<leader>E", function()
        local utils = require("core.utils")
        local project_root = utils.get_project_root()
        require("snacks").explorer({ cwd = project_root })
      end, desc = "[E]xplorer project root" },
  },

  init = function()

  -- Terminal ESC handling with autocmd (your original working method)
    vim.api.nvim_create_autocmd("TermOpen", {
      pattern = "*",
      callback = function(ev)
        local buf = ev.buf
        -- Check if it's a snacks terminal
        if vim.bo[buf].filetype == "snacks_terminal" then
          -- Double ESC: works with zsh vi-mode (first ESC goes to zsh, second to nvim)
          vim.keymap.set("t", "<esc><esc>", function()
            vim.cmd("close")
          end, { buffer = buf, desc = "Close terminal (double ESC)" })

          -- Alternative: Ctrl+q for instant close
          vim.keymap.set("t", "<c-q>", function()
            vim.cmd("close")
          end, { buffer = buf, desc = "Close terminal (Ctrl+q)" })
        end
      end,
    })
    -- Custom autocmds for project journal
    vim.api.nvim_create_autocmd("BufEnter", {
      pattern = "*journal.md",
      callback = function(ev)
        -- ESC to save and close journal (smart close)
        vim.keymap.set("n", "<esc>", function()
          -- Save if modified
          if vim.bo[ev.buf].modified then
            vim.cmd("write")
          end

          -- Close the window
          vim.cmd("close")
        end, { buffer = ev.buf, desc = "Save and close journal" })

        -- Enable spellcheck for better writing
        vim.opt_local.spell = true
        vim.opt_local.spelllang = "en_us"
      end,
    })
  end,
}
