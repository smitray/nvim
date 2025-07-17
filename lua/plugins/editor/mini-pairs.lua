-- ~/.config/nvim/lua/plugins/editor/mini-pairs.lua

return {
  "echasnovski/mini.pairs",
  version = false, -- Use HEAD for latest features
  event = "VeryLazy",
  opts = {
    -- In which modes mappings from this `config` should be created
    modes = { insert = true, command = false, terminal = false },

    -- Global mappings. Each right hand side should be a pair information, a
    -- table with at least these fields (see more in help):
    -- - <action> - one of 'open', 'close', 'closeopen'.
    -- - <pair> - two character string for pair to be used.
    mappings = {
      -- Auto-open pairs
      ['('] = { action = 'open', pair = '()', neigh_pattern = '[^\\].' },
      ['['] = { action = 'open', pair = '[]', neigh_pattern = '[^\\].' },
      ['{'] = { action = 'open', pair = '{}', neigh_pattern = '[^\\].' },

      -- Auto-close pairs
      [')'] = { action = 'close', pair = '()', neigh_pattern = '[^\\].' },
      [']'] = { action = 'close', pair = '[]', neigh_pattern = '[^\\].' },
      ['}'] = { action = 'close', pair = '{}', neigh_pattern = '[^\\].' },

      -- Auto-closeopen pairs (quotes)
      ['"'] = { action = 'closeopen', pair = '""', neigh_pattern = '[^\\].', register = { cr = false } },
      ["'"] = { action = 'closeopen', pair = "''", neigh_pattern = '[^%a\\].', register = { cr = false } },
      ['`'] = { action = 'closeopen', pair = '``', neigh_pattern = '[^\\].', register = { cr = false } },
    },
  },

  config = function(_, opts)
    require('mini.pairs').setup(opts)

    -- Enhanced smart deletion with pairs
    local function smart_bs()
      local col = vim.fn.col('.') - 1
      local line = vim.fn.getline('.')
      local prev_char = line:sub(col, col)
      local next_char = line:sub(col + 1, col + 1)

      -- Pairs to check for smart deletion
      local pairs = {
        ['('] = ')',
        ['['] = ']',
        ['{'] = '}',
        ['"'] = '"',
        ["'"] = "'",
        ['`'] = '`',
      }

      -- If cursor is between a pair, delete both characters
      if pairs[prev_char] == next_char then
        return '<Right><BS><BS>'
      else
        return '<BS>'
      end
    end

    -- Enhanced <CR> behavior for pairs
    local function smart_cr()
      local col = vim.fn.col('.') - 1
      local line = vim.fn.getline('.')
      local prev_char = line:sub(col, col)
      local next_char = line:sub(col + 1, col + 1)

      -- Check if we're between brackets that should expand
      local expand_pairs = {
        ['('] = ')',
        ['['] = ']',
        ['{'] = '}',
      }

      -- If between expandable brackets, create indented block
      if expand_pairs[prev_char] == next_char then
        return '<CR><Esc>O'
      else
        return '<CR>'
      end
    end

    -- Map enhanced behaviors
    vim.keymap.set('i', '<BS>', smart_bs, { expr = true, desc = '[b]ackspace [s]mart deletion' })
    vim.keymap.set('i', '<CR>', smart_cr, { expr = true, desc = '[CR] smart newline' })

    -- Optional: Add space inside brackets when typing space
    local function smart_space()
      local col = vim.fn.col('.') - 1
      local line = vim.fn.getline('.')
      local prev_char = line:sub(col, col)
      local next_char = line:sub(col + 1, col + 1)

      -- Add spaces inside brackets
      local space_pairs = {
        ['('] = ')',
        ['['] = ']',
        ['{'] = '}',
      }

      if space_pairs[prev_char] == next_char then
        return '<Space><Space><Left>'
      else
        return '<Space>'
      end
    end

    vim.keymap.set('i', '<Space>', smart_space, { expr = true, desc = '[Space] smart spacing' })
  end,
}
