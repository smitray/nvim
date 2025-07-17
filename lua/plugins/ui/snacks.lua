-- ~/.config/nvim/lua/plugins/ui/snacks.lua
return {
  "folke/snacks.nvim",
  priority = 1000,
  lazy = false,

  ---@type snacks.Config
  opts = {
    -- Performance & File Handling
    bigfile = {},
    quickfile = {},

    -- UI & Visual
    explorer = {
      tree = false,
    },
    indent = {},
    statuscolumn = {},
    scroll = {},
    words = {},
    zen = {
      toggles = {
        git_signs = false,
        mini_diff_signs = false,
      },
      show = {
        statusline = false, -- hide statusline in zen mode
        tabline = false,    -- hide tabline in zen mode
      },
      win = {
        style = "zen"
      },
      -- Zoom mode configuration (for <leader>zx)
      zoom = {
        show = {
          statusline = true, -- show statusline in zoom mode
          tabline = true,    -- show tabline in zoom mode
        },
        toggles = {},
      },
    },

    -- Core Functionality
    picker = {
      layout = {
        preset = "default",
        preview = false,  -- disable preview split
      },
      sources = {
        explorer = {
          auto_close = true,
          layout = { layout = { position = "right" } },
        },
        command_history = {
          layout = {
            preset = "default",
            preview = false,
          },
        },
        search_history = {
          layout = {
            preset = "default",
            preview = false,
          },
        },
      },
    },
    bufdelete = {},
    input = {},
    notifier = {
      timeout = 3000,
    },
    scope = {},
    toggle = {},

    -- Git & Development
    rename = {},
    lazygit = {},
    git = {},

    -- Terminal Configuration
    terminal = {
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

      -- Keep it simple - reliable keys only
      keys = {
        q = "hide",  -- This works reliably
      },

      -- Terminal behavior
      interactive = true,  -- auto start insert mode
    },

    -- Scratch Configuration
    scratch = {
      name = "Project Journal",
      ft = "markdown",
      icon = "",
      autowrite = true,
      win = {
        style = "scratch",
        width = 120,
        height = 40,
        keys = {
          q = function(self)
            -- Save if modified, then close
            if vim.bo[self.buf].modified then
              vim.cmd("write")
            end
            self:close()
          end,
        },
      },
    },
  },

  keys = {
    -- File & Buffer Management
    { "<leader><space>", function() require("snacks").picker.smart() end, desc = "Smart Find Files" },
    { "<leader>ff", function() require("snacks").picker.files() end, desc = "[f]ind [f]iles" },
    { "<leader>fr", function() require("snacks").picker.recent() end, desc = "[f]ind [r]ecent files" },
    { "<leader>fp", function() require("snacks").picker.projects() end, desc = "[f]ind [p]rojects" },
    { "<leader>bl", function() require("snacks").picker.buffers() end, desc = "[b]uffer [l]ist" },
    { "<leader>bd", function() require("snacks").bufdelete() end, desc = "[b]uffer [d]elete" },
    { "<leader>bD", function() require("snacks").bufdelete.other() end, desc = "[b]uffer [D]elete others" },
    { "<leader>bda", function() require("snacks").bufdelete.all() end, desc = "[b]uffer [d]elete [a]ll" },
    { "<leader>rn", function() require("snacks").rename.rename_file() end, desc = "[r]e[n]ame file" },

    -- Search & Text
    { "<leader>sg", function() require("snacks").picker.grep() end, desc = "[s]earch [g]rep" },
    { "<leader>sw", function() require("snacks").picker.grep_word() end, desc = "[s]earch [w]ord under cursor", mode = { "n", "x" } },
    { "<leader>sb", function() require("snacks").picker.grep_buffers() end, desc = "[s]earch [b]uffers" },
    { "<leader>sl", function() require("snacks").picker.lines() end, desc = "[s]earch [l]ines" },
    { "<leader>sr", function() require("snacks").picker.resume() end, desc = "[s]earch [r]esume" },

    -- Git Integration (Picker/UI)
    { "<leader>gf", function() require("snacks").picker.git_files() end, desc = "[g]it [f]iles" },
    { "<leader>gd", function() require("snacks").picker.git_diff() end, desc = "[g]it [d]iff" },
    { "<leader>gs", function() require("snacks").picker.git_status() end, desc = "[g]it [s]tatus" },
    { "<leader>gl", function() require("snacks").picker.git_log_file() end, desc = "[g]it [l]og file" },
    { "<leader>gb", function() require("snacks").picker.git_branches() end, desc = "[g]it [b]ranches" },
    { "<leader>gc", function() require("snacks").picker.git_commits() end, desc = "[g]it [c]ommits" },
    { "<leader>gB", function() require("snacks").git.blame_line() end, desc = "[g]it [B]lame line" },
    { "<leader>gg", function() require("snacks").lazygit() end, desc = "[g]it laz[g]it" },

    -- Git Workflow (using your aliases)
    { "<leader>gaa", function() require("snacks").terminal("gaa && echo 'All changes added' && echo 'Press enter...'; read") end, desc = "[g]it [a]dd [a]ll" },
    { "<leader>gp", function() require("snacks").terminal("gp && echo 'Push completed' && echo 'Press enter...'; read") end, desc = "[g]it [p]ush" },
    { "<leader>gup", function() require("snacks").terminal("gup && echo 'Pull rebase completed' && echo 'Press enter...'; read") end, desc = "[g]it p[u]ll rebase" },
    { "<leader>gst", function() require("snacks").terminal("gst && echo 'Press enter...'; read") end, desc = "[g]it [st]atus terminal" },

    -- Complete Git Workflows
    { "<leader>gap", function()
        vim.ui.input({ prompt = "Commit message: " }, function(commit_msg)
          if commit_msg and commit_msg ~= "" then
            require("snacks").terminal("gaa && gcmsg '" .. commit_msg .. "' && gp && echo 'Add, commit, and push completed' && echo 'Press enter...'; read")
          else
            vim.notify("Commit message is required", vim.log.levels.WARN)
          end
        end)
      end, desc = "[g]it [a]dd commit [p]ush" },

    { "<leader>gac", function() require("snacks").terminal("gaa && gc") end, desc = "[g]it [a]dd [c]ommit (interactive)" },
    { "<leader>gacp", function() require("snacks").terminal("gaa && gc && gp") end, desc = "[g]it [a]dd [c]ommit [p]ush (interactive)" },

    -- Branch Operations
    { "<leader>gcm", function() require("snacks").terminal("gcm && echo 'Switched to main branch' && echo 'Press enter...'; read") end, desc = "[g]it checkout [m]ain" },
    { "<leader>gcd", function() require("snacks").terminal("gcd && echo 'Switched to develop branch' && echo 'Press enter...'; read") end, desc = "[g]it checkout [d]evelop" },
    { "<leader>gcb", function()
        vim.ui.input({ prompt = "New branch name: " }, function(branch_name)
          if branch_name and branch_name ~= "" then
            require("snacks").terminal("gcb " .. branch_name .. " && echo 'Created and switched to branch: " .. branch_name .. "' && echo 'Press enter...'; read")
          else
            vim.notify("Branch name is required", vim.log.levels.WARN)
          end
        end)
      end, desc = "[g]it [c]reate [b]ranch" },

    -- GitHub CLI Integration
    { "<leader>gpr", function() require("snacks").terminal("gh pr list && echo 'Press enter...'; read") end, desc = "[g]it [pr] list" },
    { "<leader>gprc", function() require("snacks").terminal("gh pr create") end, desc = "[g]it [pr] [c]reate" },
    { "<leader>gprm", function() require("snacks").terminal("gh pr ready && gh pr merge") end, desc = "[g]it [pr] [m]erge" },
    { "<leader>gpro", function() require("snacks").terminal("gh pr checkout") end, desc = "[g]it [pr] check[o]ut" },
    { "<leader>gprv", function() require("snacks").terminal("gh pr view && echo 'Press enter...'; read") end, desc = "[g]it [pr] [v]iew" },

    -- GitHub Issues
    { "<leader>gi", function() require("snacks").terminal("gh issue list && echo 'Press enter...'; read") end, desc = "[g]it [i]ssue list" },
    { "<leader>gic", function() require("snacks").terminal("gh issue create") end, desc = "[g]it [i]ssue [c]reate" },
    { "<leader>giv", function() require("snacks").terminal("gh issue view") end, desc = "[g]it [i]ssue [v]iew" },
    { "<leader>gix", function()
        vim.ui.input({ prompt = "Issue Number: " }, function(issue_number)
          if issue_number and issue_number ~= "" then
            require("snacks").terminal("gh issue close " .. issue_number)
          else
            vim.notify("Issue number is required", vim.log.levels.WARN)
          end
        end)
      end, desc = "[g]it [i]ssue close ([x])" },

    -- GitHub Repository Operations
    { "<leader>grv", function() require("snacks").terminal("gh repo view && echo 'Press enter...'; read") end, desc = "[g]it [r]epo [v]iew" },
    { "<leader>grw", function() require("snacks").terminal("gh repo view --web") end, desc = "[g]it [r]epo [w]eb" },
    { "<leader>grc", function() require("snacks").terminal("gh repo clone") end, desc = "[g]it [r]epo [c]lone" },

    -- Advanced Workflows
    { "<leader>gsync", function() require("snacks").terminal("gup && gp && echo 'Sync completed (pull rebase + push)' && echo 'Press enter...'; read") end, desc = "[g]it [sync] (pull rebase + push)" },
    { "<leader>gwip", function() require("snacks").terminal("gwip && echo 'WIP commit created' && echo 'Press enter...'; read") end, desc = "[g]it [wip] commit" },
    { "<leader>gunwip", function() require("snacks").terminal("gunwip && echo 'WIP commit undone' && echo 'Press enter...'; read") end, desc = "[g]it [unwip]" },

    -- LSP Integration
    { "gd", function() require("snacks").picker.lsp_definitions() end, desc = "Goto Definition" },
    { "gD", function() require("snacks").picker.lsp_declarations() end, desc = "Goto Declaration" },
    { "gr", function() require("snacks").picker.lsp_references() end, nowait = true, desc = "References" },
    { "gI", function() require("snacks").picker.lsp_implementations() end, desc = "Goto Implementation" },
    { "gy", function() require("snacks").picker.lsp_type_definitions() end, desc = "Goto T[y]pe Definition" },
    { "<leader>ld", function() require("snacks").picker.diagnostics() end, desc = "[l]sp [d]iagnostics" },
    { "<leader>lD", function() require("snacks").picker.diagnostics_buffer() end, desc = "[l]sp [D]iagnostics buffer" },
    { "<leader>ls", function() require("snacks").picker.lsp_symbols() end, desc = "[l]sp [s]ymbols" },
    { "<leader>lS", function() require("snacks").picker.lsp_workspace_symbols() end, desc = "[l]sp [S]ymbols workspace" },

    -- Reference Navigation with Word Jumps
    { "]]", function()
        require("snacks").words.jump(vim.v.count1)
        vim.cmd("normal! zz")
      end, desc = "Next Reference" },
    { "[[", function()
        require("snacks").words.jump(-vim.v.count1)
        vim.cmd("normal! zz")
      end, desc = "Prev Reference" },

    -- Utilities (all utility commands grouped)
    { "<leader>uc", function() require("snacks").picker.commands() end, desc = "[u]tility [c]ommands" },
    { "<leader>uk", function() require("snacks").picker.keymaps() end, desc = "[u]tility [k]eymaps" },
    { "<leader>uh", function() require("snacks").picker.help() end, desc = "[u]tility [h]elp" },
    { "<leader>ur", function() require("snacks").picker.registers() end, desc = "[u]tility [r]egisters" },
    { "<leader>uu", function() require("snacks").picker.undo() end, desc = "[u]tility [u]ndo" },
    { "<leader>un", function() require("snacks").picker.notifications() end, desc = "[u]tility [n]otifications" },
    { "<leader>uj", function() require("snacks").picker.jumps() end, desc = "[u]tility [j]umps" },
    { "<leader>ua", function() require("snacks").picker.autocmds() end, desc = "[u]tility [a]utocmds" },
    { "<leader>ux", function() require("snacks").picker.command_history() end, desc = "[u]tility command history ([x])" },
    { "<leader>uy", function() require("snacks").picker.search_history() end, desc = "[u]tility search histor[y]" },
    { "<leader>uz", function() require("snacks").picker.highlights() end, desc = "[u]tility highlights ([z])" },
    { "z=", function() require("snacks").picker.spelling() end, desc = "Spelling suggestions" },

    -- Visual & Navigation
    { "<leader>zz", function() require("snacks").zen() end, desc = "[z]en mode toggle" },
    { "<leader>zx", function() require("snacks").zen.zoom() end, desc = "[z]en zoom toggle ([x])" },

    -- Utilities & Debug
    { "<leader>N", function()
        require("snacks").win({
          file = vim.api.nvim_get_runtime_file("doc/news.txt", false)[1],
          width = 0.6,
          height = 0.6,
          wo = {
            spell = false,
            wrap = false,
            signcolumn = "yes",
            statuscolumn = " ",
            conceallevel = 3,
          },
        })
      end, desc = "[N]eovim News" },

    -- Notifications
    { "<leader>nd", function() require("snacks").notifier.hide() end, desc = "[n]otification [d]ismiss" },
    { "<leader>nh", function() require("snacks").notifier.show_history() end, desc = "[n]otification [h]istory" },

    -- Terminal
    { "<leader>tt", function() require("snacks").terminal.toggle() end, desc = "[t]erminal [t]oggle" },

    -- Scratch Notes
    { "<leader>ns", function()
        local utils = require("core.utils")
        local project_root = utils.get_project_root()
        local journal_path = project_root .. "/journal.md"
        local project_name = vim.fn.fnamemodify(project_root, ":t")

        require("snacks").scratch({
          file = journal_path,
          win = {
            title = "  " .. project_name .. " - Journal ",
          }
        })
      end, desc = "[n]otes [s]cratch journal" },

    -- Project-Wide Journal Search
    { "<leader>nj", function()
        local project_dir = vim.env.XDG_PROJECT_DIR or vim.fn.expand("~/Projects")
        require("snacks").picker.grep({
          search_dirs = { project_dir },
          default_text = "journal.md"
        })
      end, desc = "[n]otes [j]ournal finder" },

    -- Toggle Scratch
    { "<leader>nT", function()
        require("snacks").scratch():toggle()
      end, desc = "[n]otes [T]oggle scratch" },

    -- Select Scratch Buffer
    { "<leader>ss", function() require("snacks").scratch.select() end, desc = "[s]cratch [s]elect buffer" },

    -- Explorer
    { "<leader>e", function() require("snacks").explorer() end, desc = "[e]xplorer toggle" },
    { "<leader>et", function() require("snacks").explorer({ tree = true }) end, desc = "[e]xplorer [t]ree toggle" },
  },

  init = function()
    -- Terminal ESC handling with autocmd (your working method)
    vim.api.nvim_create_autocmd("TermOpen", {
      pattern = "*",
      callback = function(ev)
        local buf = ev.buf
        if vim.bo[buf].filetype == "snacks_terminal" then
          vim.keymap.set("t", "<esc><esc>", function()
            vim.cmd("close")
          end, { buffer = buf, desc = "Close terminal (double ESC)" })

          vim.keymap.set("t", "<c-q>", function()
            vim.cmd("close")
          end, { buffer = buf, desc = "Close terminal (Ctrl+q)" })
        end
      end,
    })

    -- Setup toggle mappings (official snacks.nvim approach)
    vim.api.nvim_create_autocmd("User", {
      pattern = "VeryLazy",
      callback = function()
        -- Official snacks.nvim toggle mappings
        require("snacks").toggle.option("spell", { name = "Spelling" }):map("<leader>us")
        require("snacks").toggle.option("wrap", { name = "Wrap" }):map("<leader>uw")
        require("snacks").toggle.option("relativenumber", { name = "Relative Number" }):map("<leader>uL")
        require("snacks").toggle.diagnostics():map("<leader>ud")
        require("snacks").toggle.line_number():map("<leader>ul")
        require("snacks").toggle.option("conceallevel", { off = 0, on = vim.o.conceallevel > 0 and vim.o.conceallevel or 2 }):map("<leader>uc")
        require("snacks").toggle.treesitter():map("<leader>uT")
        require("snacks").toggle.option("background", { off = "light", on = "dark", name = "Dark Background" }):map("<leader>ub")
        require("snacks").toggle.inlay_hints():map("<leader>uh")
        require("snacks").toggle.indent():map("<leader>ug")
      end,
    })
  end,
}
