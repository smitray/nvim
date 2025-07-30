-- ~/.config/nvim/lua/plugins/code/conform.lua
-- Smart formatting with intelligent project detection

return {
  "stevearc/conform.nvim",
  event = { "BufWritePre", "BufNewFile" },
  cmd = { "ConformInfo" },
  keys = {
    {
      "<leader>lf",
      function()
        require("conform").format({
          lsp_format = "fallback",
          async = false,
          timeout_ms = 2000,
        })
      end,
      mode = "n",
      desc = "Format buffer",
    },
    {
      "<leader>lf",
      function()
        require("conform").format({
          lsp_format = "fallback",
          async = false,
          timeout_ms = 2000,
        })
      end,
      mode = "v",
      desc = "Format selection",
    },
  },
  opts = {
    formatters_by_ft = {
      lua = { "stylua" },
    },
    format_on_save = {
      timeout_ms = 2000,
      lsp_format = "fallback",
    },
    notify_on_error = false,
    notify_no_formatters = false,
  },
  config = function(_, opts)
    require("conform").setup(opts)
  end,
}
