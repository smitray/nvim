-- plugins/editor/vim-tmux-navigator.lua
-- Seamless navigation between vim and tmux panes

return {
  "christoomey/vim-tmux-navigator",
  cmd = {
    "TmuxNavigateLeft",
    "TmuxNavigateDown",
    "TmuxNavigateUp",
    "TmuxNavigateRight",
    "TmuxNavigatePrevious",
  },
  keys = {
    { "<c-h>", "<cmd><C-U>TmuxNavigateLeft<cr>", desc = "[t]mux navigate [h]left" },
    { "<c-j>", "<cmd><C-U>TmuxNavigateDown<cr>", desc = "[t]mux navigate [j]down" },
    { "<c-k>", "<cmd><C-U>TmuxNavigateUp<cr>", desc = "[t]mux navigate [k]up" },
    { "<c-l>", "<cmd><C-U>TmuxNavigateRight<cr>", desc = "[t]mux navigate [l]right" },
    { "<c-\\>", "<cmd><C-U>TmuxNavigatePrevious<cr>", desc = "[t]mux navigate [\\]previous" },
  },
  init = function()
    -- Disable tmux navigator when zooming the Vim pane
    vim.g.tmux_navigator_disable_when_zoomed = 1

    -- Save on switch - automatically save when switching panes
    vim.g.tmux_navigator_save_on_switch = 2

    -- Preserve zoom when switching panes
    vim.g.tmux_navigator_preserve_zoom = 1

    -- No wrap around navigation
    vim.g.tmux_navigator_no_wrap = 0
  end,
}
