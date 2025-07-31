-- ~/.config/nvim/lua/plugins/editor/grug-far.lua

return {
  "MagicDuck/grug-far.nvim",
  dependencies = { "nvim-lua/plenary.nvim" },
  keys = {
    {
      "<leader>sr",
      function()
        require("grug-far").open()
      end,
      desc = "Search & Replace",
    },
  },
  opts = {
    -- Pre-filled search text can be:
    -- "selected_text" -> text selected in visual mode
    -- "word_under_cursor"
    -- "file_path"
    prefill_search_text = "selected_text",

    -- Pre-filled context can be:
    -- "current_file"
    -- "other_files" -> all open buffers except current
    -- "all_files" -> all open buffers
    -- "git_root"
    prefill_context = "current_file",

    -- Show a summary window after a replace is finished
    show_summary_window = true,

    -- Show a confirmation prompt before replacing
    -- "always"
    -- "never"
    -- "when_replacing_in_multiple_files"
    show_confirmation_prompt = "when_replacing_in_multiple_files",

    -- Whether to open the file that a given search result is in when you move
    -- to it in the results list
    open_file_on_move = true,

    -- The command used to search for files.
    -- The default is "rg --color=never --no-heading --with-filename --line-number --column"
    search_command = "rg --color=never --no-heading --with-filename --line-number --column",
  },
}
