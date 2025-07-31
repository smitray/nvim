-- ~/.config/nvim/lua/plugins/git/diffview.lua

return {
  "sindrets/diffview.nvim",
  cmd = { "DiffviewOpen", "DiffviewClose", "DiffviewToggleFiles", "DiffviewFocusFiles" },
  opts = {
    diff_binaries = false,
    enhanced_diff_hl = true,
    git_cmd = { "git" },
    use_icons = true,
    show_help_hints = true,
    watch_index = true,
    keyboard_bindings = {
      disable_defaults = false,
      -- Keymaps for navigation
      view = {
        ["<tab>"] = "select_next_entry",
        ["<s-tab>"] = "select_prev_entry",
        ["gf"] = "goto_file",
        ["<C-w><C-f>"] = "goto_file_split",
        ["<C-w>gf"] = "goto_file_tab",
        ["<leader>e"] = "focus_files",
        ["<leader>b"] = "toggle_files",
      },
      file_panel = {
        ["j"] = "next_entry",
        ["k"] = "prev_entry",
        ["<cr>"] = "select_entry",
        ["o"] = "select_entry",
        ["<2-LeftMouse>"] = "select_entry",
        ["-"] = "toggle_stage_entry",
        ["S"] = "stage_all",
        ["U"] = "unstage_all",
        ["X"] = "restore_entry",
        ["L"] = "open_commit_log",
        ["<c-l>"] = "open_commit_log",
        ["R"] = "refresh_files",
        ["<leader>e"] = "focus_files",
        ["<leader>b"] = "toggle_files",
      },
      file_history_panel = {
        ["j"] = "next_entry",
        ["k"] = "prev_entry",
        ["<cr>"] = "select_entry",
        ["o"] = "select_entry",
        ["<2-LeftMouse>"] = "select_entry",
        ["y"] = "copy_hash",
        ["L"] = "open_commit_log",
        ["<c-l>"] = "open_commit_log",
        ["zR"] = "open_all_folds",
        ["zM"] = "close_all_folds",
      },
      option_panel = {
        ["<tab>"] = "select_next_entry",
        ["<s-tab>"] = "select_prev_entry",
        ["<cr>"] = "select_entry",
        ["o"] = "select_entry",
      },
    },
    view = {
      -- Configure the layout and behavior of different views
      default = {
        -- Config for changed files, and staged files in diff views
        layout = "diff2_horizontal",
      },
      merge_tool = {
        layout = "diff3_mixed",
        disable_diagnostics = true,
      },
      file_history = {
        layout = "diff2_horizontal",
      },
    },
    file_panel = {
      listing_style = "tree", -- 'list' or 'tree'
      tree_options = {
        flatten_dirs = true,
        folder_statuses = "only_folded",
      },
      win_config = {
        position = "left",
        width = 35,
      },
    },
    file_history_panel = {
      log_options = {
        git = {
          single_file = {
            diff_merges = "combined",
          },
          multi_file = {
            diff_merges = "first-parent",
          },
        },
      },
    },
    commit_log_panel = {
      win_config = {
        win_height = 10,
        win_position = "bottom",
      },
    },
  },
  keys = {
    { "<leader>do", "<cmd>DiffviewOpen<cr>", desc = "Diffview Open" },
    { "<leader>dc", "<cmd>DiffviewClose<cr>", desc = "Diffview Close" },
    { "<leader>dt", "<cmd>DiffviewToggleFiles<cr>", desc = "Diffview Toggle Files" },
    { "<leader>df", "<cmd>DiffviewFocusFiles<cr>", desc = "Diffview Focus Files" },
    { "<leader>dh", "<cmd>DiffviewFileHistory %<cr>", desc = "Diffview File History" },
    { "<leader>dl", "<cmd>DiffviewOpen -S<cr>", desc = "Diffview Log" },
  },
}
