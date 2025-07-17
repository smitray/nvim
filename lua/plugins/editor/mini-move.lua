-- ~/.config/nvim/lua/plugins/editor/mini-move.lua

return {
  "echasnovski/mini.move",
  version = false, -- Use HEAD for latest features
  event = "VeryLazy",
  opts = {
    -- Module mappings (use Alt + hjkl for intuitive movement)
    mappings = {
      -- Move visual selection in Visual mode
      left = '<M-h>',
      right = '<M-l>',
      down = '<M-j>',
      up = '<M-k>',

      -- Move current line in Normal mode
      line_left = '<M-h>',
      line_right = '<M-l>',
      line_down = '<M-j>',
      line_up = '<M-k>',
    },

    -- Options which control moving behavior
    options = {
      -- Automatically reindent selection during linewise vertical move
      reindent_linewise = true,
    },
  },

  config = function(_, opts)
    require('mini.move').setup(opts)

    -- Alternative keymaps for terminals that don't support Alt well
    -- Using Shift + Arrow keys as backup
    vim.keymap.set('n', '<S-Down>', '<M-j>', { remap = true, desc = '[m]ove line down' })
    vim.keymap.set('n', '<S-Up>', '<M-k>', { remap = true, desc = '[m]ove line up' })
    vim.keymap.set('n', '<S-Left>', '<M-h>', { remap = true, desc = '[m]ove line left' })
    vim.keymap.set('n', '<S-Right>', '<M-l>', { remap = true, desc = '[m]ove line right' })

    vim.keymap.set('v', '<S-Down>', '<M-j>', { remap = true, desc = '[m]ove selection down' })
    vim.keymap.set('v', '<S-Up>', '<M-k>', { remap = true, desc = '[m]ove selection up' })
    vim.keymap.set('v', '<S-Left>', '<M-h>', { remap = true, desc = '[m]ove selection left' })
    vim.keymap.set('v', '<S-Right>', '<M-l>', { remap = true, desc = '[m]ove selection right' })
  end,
}
