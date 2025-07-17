-- ~/.config/nvim/lua/plugins/editor/rainbow-delimiters.lua

return {
  "HiPhish/rainbow-delimiters.nvim",
  event = { "BufReadPost", "BufNewFile" },
  config = function()
    local rainbow_delimiters = require("rainbow-delimiters")

    ---@type rainbow_delimiters.config
    vim.g.rainbow_delimiters = {
      strategy = {
        [""] = rainbow_delimiters.strategy["global"],
        vim = rainbow_delimiters.strategy["local"],
        html = rainbow_delimiters.strategy["local"],
        jsx = rainbow_delimiters.strategy["local"],
        tsx = rainbow_delimiters.strategy["local"],
      },
      query = {
        [""] = "rainbow-delimiters",
        lua = "rainbow-blocks",
        javascript = "rainbow-delimiters",
        typescript = "rainbow-delimiters",
        jsx = "rainbow-parens",
        tsx = "rainbow-parens",
        html = "rainbow-tags",
      },
      priority = {
        [""] = 110,
        lua = 210,
        javascript = 120,
        typescript = 120,
        jsx = 120,
        tsx = 120,
      },
      highlight = {
        "RainbowDelimiterRed",
        "RainbowDelimiterYellow",
        "RainbowDelimiterBlue",
        "RainbowDelimiterOrange",
        "RainbowDelimiterGreen",
        "RainbowDelimiterViolet",
        "RainbowDelimiterCyan",
      },
      -- Disable for very large files (performance)
      blacklist = {},
      whitelist = nil,
    }

    -- Integration with catppuccin theme colors
    local function setup_catppuccin_colors()
      if vim.g.colors_name == "catppuccin" or vim.g.colors_name == "catppuccin-mocha" then
        -- Use catppuccin colors for rainbow delimiters
        vim.api.nvim_set_hl(0, "RainbowDelimiterRed", { fg = "#f38ba8" })
        vim.api.nvim_set_hl(0, "RainbowDelimiterYellow", { fg = "#f9e2af" })
        vim.api.nvim_set_hl(0, "RainbowDelimiterBlue", { fg = "#89b4fa" })
        vim.api.nvim_set_hl(0, "RainbowDelimiterOrange", { fg = "#fab387" })
        vim.api.nvim_set_hl(0, "RainbowDelimiterGreen", { fg = "#a6e3a1" })
        vim.api.nvim_set_hl(0, "RainbowDelimiterViolet", { fg = "#cba6f7" })
        vim.api.nvim_set_hl(0, "RainbowDelimiterCyan", { fg = "#94e2d5" })
      end
    end

    -- Set colors immediately and on colorscheme change
    setup_catppuccin_colors()
    vim.api.nvim_create_autocmd("ColorScheme", {
      group = vim.api.nvim_create_augroup("RainbowDelimitersColors", { clear = true }),
      callback = setup_catppuccin_colors,
      desc = "Update rainbow delimiter colors when colorscheme changes",
    })

    -- Add toggle command for rainbow delimiters
    vim.api.nvim_create_user_command("RainbowToggle", function()
      local state = vim.g.rainbow_delimiters
      if state and state.strategy and state.strategy[""] then
        -- Disable
        vim.g.rainbow_delimiters = vim.tbl_extend("force", state, {
          strategy = { [""] = nil }
        })
        vim.notify("Rainbow delimiters disabled", vim.log.levels.INFO)
      else
        -- Enable
        vim.g.rainbow_delimiters = vim.tbl_extend("force", state or {}, {
          strategy = {
            [""] = rainbow_delimiters.strategy["global"],
            vim = rainbow_delimiters.strategy["local"],
          }
        })
        vim.notify("Rainbow delimiters enabled", vim.log.levels.INFO)
      end
      -- Refresh current buffer
      vim.cmd("edit!")
    end, { desc = "Toggle rainbow delimiters" })

    -- Add keymap for toggle
    vim.keymap.set("n", "<leader>or", "<cmd>RainbowToggle<cr>", { desc = "[o]ptions [r]ainbow delimiters toggle" })
  end,
}
