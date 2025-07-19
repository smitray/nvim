-- lua/plugins/lsp/conform.lua
-- Smart formatting using existing Utils

return {
  "stevearc/conform.nvim",
  event = { "BufWritePre" },
  keys = {
    {
      "<leader>cf",
      function()
        require("conform").format({ async = true, lsp_fallback = true })
      end,
      mode = { "n", "v" },
      desc = "[c]ode [f]ormat",
    },
  },
  config = function()
    -- Use existing Utils.get_project_root()
    local function has_config(filename)
      local root = Utils.get_project_root()
      return root and vim.uv.fs_stat(root .. "/" .. filename) ~= nil
    end

    local function has_prettier()
      local configs = { ".prettierrc", ".prettierrc.json", ".prettierrc.js", "prettier.config.js" }
      for _, config in ipairs(configs) do
        if has_config(config) then
          return true
        end
      end
      return false
    end

    local function has_biome()
      return has_config("biome.json") or has_config("biome.jsonc")
    end

    require("conform").setup({
      format_on_save = { timeout_ms = 2000, lsp_fallback = true },
      formatters_by_ft = {
        lua = { "stylua" },
        python = { "isort", "black" },

        -- Smart JS/TS: Biome > Prettier > fallback
        javascript = function()
          return has_biome() and {} or { "prettier" }
        end,
        typescript = function()
          return has_biome() and {} or { "prettier" }
        end,
        javascriptreact = function()
          return has_biome() and {} or { "prettier" }
        end,
        typescriptreact = function()
          return has_biome() and {} or { "prettier" }
        end,

        -- Web files: only if prettier config exists
        vue = function()
          return has_prettier() and { "prettier" } or {}
        end,
        svelte = function()
          return has_prettier() and { "prettier" } or {}
        end,
        astro = function()
          return has_prettier() and { "prettier" } or {}
        end,
        html = function()
          return has_prettier() and { "prettier" } or {}
        end,
        css = function()
          return has_prettier() and { "prettier" } or {}
        end,
        scss = function()
          return has_prettier() and { "prettier" } or {}
        end,

        -- Config files
        json = function()
          return has_biome() and {} or { "prettier" }
        end,
        jsonc = function()
          return has_biome() and {} or { "prettier" }
        end,
        markdown = function()
          return has_prettier() and { "prettier" } or {}
        end,

        sh = { "shfmt" },
        toml = { "taplo" },
      },
    })
  end,
}
