-- ~/.config/nvim/lua/plugins/editor/mini-splitjoin.lua

return {
  "echasnovski/mini.splitjoin",
  version = false, -- Use HEAD for latest features
  event = "VeryLazy",
  opts = {
    -- Module mappings
    mappings = {
      toggle = 'gS',  -- Toggle between split and join
      split = '',     -- Disable separate split mapping (use toggle)
      join = '',      -- Disable separate join mapping (use toggle)
    },

    -- Detection options
    detect = {
      -- List of Lua patterns to detect regions with split and join
      brackets = nil, -- Use default: { '%b()', '%b[]', '%b{}' }

      -- Whether to add/remove trailing separator when splitting/joining
      separator_high_priority = false,
    },

    -- Split options
    split = {
      hooks_pre = {},
      hooks_post = {},
    },

    -- Join options
    join = {
      hooks_pre = {},
      hooks_post = {},
    },
  },

  config = function(_, opts)
    require('mini.splitjoin').setup(opts)

    -- Add which-key integration for the toggle mapping
    vim.keymap.set('n', 'gS', function()
      require('mini.splitjoin').toggle()
    end, { desc = '[g]o [S]plit/join toggle' })
  end,
}
