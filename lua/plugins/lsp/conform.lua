-- lua/plugins/lsp/conform.lua
return {
  "stevearc/conform.nvim",
  event = { "BufWritePre" },
  cmd = { "ConformInfo" },
  keys = {
    {
      "<leader>cf",
      function()
        require("conform").format({ async = true, lsp_fallback = true })
      end,
      mode = { "n", "v" },
      desc = "[c]ode [f]ormat",
    },
    {
      "<leader>cF",
      function()
        require("conform").format({ async = true, lsp_fallback = true, range = nil })
      end,
      mode = "n",
      desc = "[c]ode [F]ormat entire buffer",
    },
  },

  config = function()
    -- Project configuration cache for performance
    local config_cache = {}
    local cache_timeout = 5000 -- 5 seconds cache

    local function get_project_root(bufnr)
      return Utils.get_project_root()
    end

    local function get_project_config(bufnr)
      local root = get_project_root(bufnr)
      if not root then
        return {}
      end

      local cache_key = root
      local now = vim.loop.hrtime() / 1000000 -- Convert to milliseconds

      -- Check cache validity
      if config_cache[cache_key] and (now - config_cache[cache_key].timestamp) < cache_timeout then
        return config_cache[cache_key].config
      end

      -- Detect project configuration
      local config = {
        has_prettier = check_prettier_config(root),
        has_biome = check_biome_config(root),
        has_black = check_python_config(root, "black"),
        has_ruff = check_python_config(root, "ruff"),
      }

      -- Cache the result
      config_cache[cache_key] = {
        config = config,
        timestamp = now,
      }

      return config
    end

    local function check_prettier_config(root_dir)
      -- Comprehensive prettier config detection
      local config_files = {
        -- JSON/YAML formats
        ".prettierrc",
        ".prettierrc.json",
        ".prettierrc.yml",
        ".prettierrc.yaml",
        ".prettierrc.json5",

        -- JavaScript/TypeScript formats
        ".prettierrc.js",
        "prettier.config.js",
        ".prettierrc.ts",
        "prettier.config.ts",

        -- ES Module formats
        ".prettierrc.mjs",
        "prettier.config.mjs",
        ".prettierrc.mts",
        "prettier.config.mts",

        -- CommonJS formats
        ".prettierrc.cjs",
        "prettier.config.cjs",
        ".prettierrc.cts",
        "prettier.config.cts",

        -- TOML format
        ".prettierrc.toml",
      }

      for _, config_file in ipairs(config_files) do
        if vim.uv.fs_stat(root_dir .. "/" .. config_file) then
          return true
        end
      end

      -- Check package.json for prettier field
      local package_json = root_dir .. "/package.json"
      if vim.uv.fs_stat(package_json) then
        local ok, content = pcall(vim.fn.readfile, package_json)
        if ok and #content > 0 then
          local json_str = table.concat(content, "\n")
          if json_str:match('"prettier"') or json_str:match('"@prettier/') then
            return true
          end
        end
      end

      return false
    end

    local function check_biome_config(root_dir)
      local config_files = { "biome.json", "biome.jsonc" }
      for _, config_file in ipairs(config_files) do
        if vim.uv.fs_stat(root_dir .. "/" .. config_file) then
          return true
        end
      end
      return false
    end

    local function check_python_config(root_dir, tool)
      local config_files = {
        "pyproject.toml",
        "setup.cfg",
        ".ruff.toml",
        "ruff.toml",
      }

      for _, config_file in ipairs(config_files) do
        local file_path = root_dir .. "/" .. config_file
        if vim.uv.fs_stat(file_path) then
          local ok, content = pcall(vim.fn.readfile, file_path)
          if ok and #content > 0 then
            local file_content = table.concat(content, "\n")
            if file_content:match(tool) then
              return true
            end
          end
        end
      end
      return false
    end

    require("conform").setup({
      format_on_save = function(bufnr)
        -- Exclude certain filetypes from auto-formatting
        local exclude_filetypes = {
          "lazy", "help", "oil", "mason", "TelescopePrompt", "snacks_terminal",
          "trouble", "lspinfo", "checkhealth", "man", "gitcommit", "gitrebase"
        }

        -- Exclude certain directories
        local exclude_dirs = { "node_modules", ".git", "dist", "build", ".next", ".nuxt" }

        local ft = vim.bo[bufnr].filetype
        local filepath = vim.api.nvim_buf_get_name(bufnr)

        -- Don't format excluded filetypes
        if vim.tbl_contains(exclude_filetypes, ft) then
          return false
        end

        -- Don't format files in excluded directories
        for _, dir in ipairs(exclude_dirs) do
          if filepath:match(dir) then
            return false
          end
        end

        -- Don't format if buffer is too large (>1MB)
        local max_filesize = 1024 * 1024 -- 1MB
        local ok, stats = pcall(vim.loop.fs_stat, filepath)
        if ok and stats and stats.size > max_filesize then
          return false
        end

        return {
          timeout_ms = 2000,
          lsp_fallback = true,
          quiet = false,
        }
      end,

      formatters_by_ft = {
        -- Lua
        lua = { "stylua" },

        -- Python with intelligent tool selection
        python = function(bufnr)
          local config = get_project_config(bufnr)
          local formatters = {}

          if config.has_ruff then
            table.insert(formatters, "ruff_organize_imports")
            table.insert(formatters, "ruff_format")
          else
            if config.has_black then
              table.insert(formatters, "isort")
              table.insert(formatters, "black")
            else
              -- Default Python formatting
              table.insert(formatters, "isort")
              table.insert(formatters, "black")
            end
          end

          return formatters
        end,

        -- JavaScript/TypeScript with smart detection
        javascript = function(bufnr)
          local config = get_project_config(bufnr)
          if config.has_biome then
            return {} -- Biome LSP handles formatting
          elseif config.has_prettier then
            return { "prettierd" }
          end
          return {}
        end,

        typescript = function(bufnr)
          local config = get_project_config(bufnr)
          if config.has_biome then
            return {} -- Biome LSP handles formatting
          elseif config.has_prettier then
            return { "prettierd" }
          end
          return {}
        end,

        javascriptreact = function(bufnr)
          local config = get_project_config(bufnr)
          if config.has_biome then
            return {} -- Biome LSP handles formatting
          elseif config.has_prettier then
            return { "prettierd" }
          end
          return {}
        end,

        typescriptreact = function(bufnr)
          local config = get_project_config(bufnr)
          if config.has_biome then
            return {} -- Biome LSP handles formatting
          elseif config.has_prettier then
            return { "prettierd" }
          end
          return {}
        end,

        -- Web technologies
        html = function(bufnr)
          local config = get_project_config(bufnr)
          return config.has_prettier and { "prettierd" } or {}
        end,

        css = function(bufnr)
          local config = get_project_config(bufnr)
          return config.has_prettier and { "prettierd" } or {}
        end,

        scss = function(bufnr)
          local config = get_project_config(bufnr)
          return config.has_prettier and { "prettierd" } or {}
        end,

        sass = function(bufnr)
          local config = get_project_config(bufnr)
          return config.has_prettier and { "prettierd" } or {}
        end,

        less = function(bufnr)
          local config = get_project_config(bufnr)
          return config.has_prettier and { "prettierd" } or {}
        end,

        -- Framework files
        vue = function(bufnr)
          local config = get_project_config(bufnr)
          return config.has_prettier and { "prettierd" } or {}
        end,

        svelte = function(bufnr)
          local config = get_project_config(bufnr)
          return config.has_prettier and { "prettierd" } or {}
        end,

        astro = function(bufnr)
          local config = get_project_config(bufnr)
          return config.has_prettier and { "prettierd" } or {}
        end,

        -- Configuration files
        json = function(bufnr)
          local config = get_project_config(bufnr)
          if config.has_biome then
            return {} -- Biome handles JSON
          elseif config.has_prettier then
            return { "prettierd" }
          end
          return {}
        end,

        jsonc = function(bufnr)
          local config = get_project_config(bufnr)
          if config.has_biome then
            return {} -- Biome handles JSONC
          elseif config.has_prettier then
            return { "prettierd" }
          end
          return {}
        end,

        yaml = function(bufnr)
          local config = get_project_config(bufnr)
          return config.has_prettier and { "prettierd" } or {}
        end,

        yml = function(bufnr)
          local config = get_project_config(bufnr)
          return config.has_prettier and { "prettierd" } or {}
        end,

        toml = { "taplo" },

        -- Markdown
        markdown = function(bufnr)
          local config = get_project_config(bufnr)
          return config.has_prettier and { "prettierd" } or {}
        end,

        -- Shell
        sh = { "shfmt" },
        bash = { "shfmt" },
        zsh = { "shfmt" },
      },

      -- Formatter-specific configuration
      formatters = {
        stylua = {
          prepend_args = { "--indent-type", "Spaces", "--indent-width", "2" },
        },
        black = {
          prepend_args = { "--line-length", "88" },
        },
        isort = {
          prepend_args = { "--profile", "black" },
        },
        prettierd = {
          env = {
            PRETTIERD_DEFAULT_CONFIG = vim.fn.expand("~/.config/prettier/.prettierrc.json"),
          },
        },
        shfmt = {
          prepend_args = { "-i", "2", "-ci" },
        },
      },

      -- Notification integration with snacks
      notify_on_error = true,
    })

    -- Enhanced ConformInfo command
    vim.api.nvim_create_user_command("ConformInfo", function()
      local bufnr = vim.api.nvim_get_current_buf()
      local ft = vim.bo[bufnr].filetype
      local config = get_project_config(bufnr)

      local info = {
        "# Conform Information",
        "",
        "**Current buffer:**",
        string.format("- Filetype: %s", ft),
        string.format("- Buffer: %d", bufnr),
        "",
        "**Project configuration:**",
        string.format("- Has Prettier: %s", config.has_prettier and "✓" or "✗"),
        string.format("- Has Biome: %s", config.has_biome and "✓" or "✗"),
        string.format("- Has Black: %s", config.has_black and "✓" or "✗"),
        string.format("- Has Ruff: %s", config.has_ruff and "✓" or "✗"),
        "",
      }

      -- Show the available formatters for current filetype
      local conform = require("conform")
      local formatters = conform.list_formatters(bufnr)
      if #formatters > 0 then
        table.insert(info, "**Available formatters:**")
        for _, formatter in ipairs(formatters) do
          table.insert(info, string.format("- %s", formatter.name))
        end
      else
        table.insert(info, "**No formatters available for this filetype**")
      end

      vim.notify(table.concat(info, "\n"), vim.log.levels.INFO, { title = "Conform Info" })
    end, { desc = "Show conform configuration info" })
  end,
}
