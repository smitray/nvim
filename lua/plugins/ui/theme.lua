-- plugins/ui/catppuccin.lua
return {
  {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000,
    lazy = false, -- Load immediately for colorscheme
    opts = {
      flavour = "mocha",
      background = {
        light = "latte",
        dark = "mocha",
      },
      transparent_background = true, -- Hyprland compatibility
      show_end_of_buffer = false,
      term_colors = false,
      -- Disable dim_inactive since using snacks.dim for window dimming
      dim_inactive = {
        enabled = false,
      },
      styles = {
        comments = { "italic" },
        conditionals = { "italic" },
      },
      integrations = {
        treesitter = true,
        treesitter_context = true,
        native_lsp = {
          enabled = true,
          virtual_text = {
            errors = { "italic" },
            hints = { "italic" },
            warnings = { "italic" },
            information = { "italic" },
          },
          underlines = {
            errors = { "underline" },
            hints = { "underline" },
            warnings = { "underline" },
            information = { "underline" },
          },
        },
        gitsigns = true,
        flash = true,
        harpoon = true,
        mason = true,
        mini = true,
        snacks = true,
        which_key = true,
        notify = true,
        noice = true,
        blink_cmp = true,
      },
    },
    config = function(_, opts)
      require("catppuccin").setup(opts)

      -- Set colorscheme with fallback
      local ok, _ = pcall(vim.cmd.colorscheme, "catppuccin")
      if not ok then
        vim.notify("Failed to load catppuccin colorscheme", vim.log.levels.ERROR)
        vim.cmd.colorscheme("default")
      end
    end,
  },
}
