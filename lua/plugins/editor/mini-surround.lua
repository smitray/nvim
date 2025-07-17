-- ~/.config/nvim/lua/plugins/editor/mini-surround.lua

return {
  "echasnovski/mini.surround",
  version = false, -- Use HEAD for latest features
  event = "VeryLazy",
  opts = {
    -- Custom surroundings for common use cases
    custom_surroundings = {
      -- Angle brackets for generics/JSX
      ['<'] = {
        input = { '%<().-()%>' },
        output = { left = '<', right = '>' }
      },
      -- Function calls (dynamic)
      ['f'] = {
        input = { '%f[%w]()%w+%(.-%)()' },
        output = function()
          local fn_name = vim.fn.input('Function name: ')
          if fn_name == '' then return nil end
          return { left = fn_name .. '(', right = ')' }
        end,
      },
      -- Markdown code blocks
      ['c'] = {
        input = { '```().-()```' },
        output = { left = '```', right = '```' }
      },
    },

    -- Duration (in ms) of highlight when calling `MiniSurround.highlight()`
    highlight_duration = 500,

    -- Module mappings using 's' prefix to avoid conflicts
    mappings = {
      add = 'sa',            -- Add surrounding in Normal and Visual modes
      delete = 'sd',         -- Delete surrounding
      find = 'sf',           -- Find surrounding (to the right)
      find_left = 'sF',      -- Find surrounding (to the left)
      highlight = 'sh',      -- Highlight surrounding
      replace = 'sr',        -- Replace surrounding
      update_n_lines = 'sn', -- Update `n_lines`

      suffix_last = 'l',     -- Suffix to search with "prev" method
      suffix_next = 'n',     -- Suffix to search with "next" method
    },

    -- Number of lines within which surrounding is searched
    n_lines = 20,

    -- How to search for surrounding
    search_method = 'cover',

    -- Whether to disable showing non-error feedback
    silent = false,
  },
}
