return {
  {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    dependencies = { "echasnovski/mini.icons" },
    config = function()
      -- Get Catppuccin mocha palette
      local mocha = require("catppuccin.palettes").get_palette "mocha"

      require("lualine").setup({
        options = {
          theme = 'catppuccin',
          always_divide_middle = false,
          globalstatus = true,
          transparent = true,
          icons_enabled = true,
          component_separators = { left = '', right = '' },
          section_separators = { left = '', right = '' },
        },

        sections = {
          lualine_a = {
            {
              function()
                local mode_icons = {
                  ['n'] = "", ['i'] = "", ['v'] = "󰩭",
									['\22'] = "󰕢", ['V'] = "", ['c'] = "",
									['R'] = "󰬳", ['s'] = "󰩬", ['S'] = "󱐁",
									['t'] = "", ['no'] = "󰘳", ['ic'] = "󰏘",
									['Rv'] = "", ['cv'] = "󰞷", ['ce'] = "󰞷",
									['r'] = "󰘥", ['rm'] = "󰜷", ['r?'] = "󰋗", ['!'] = "󱆃",
                }
                local mode = vim.fn.mode()
                return mode_icons[mode] or mode
              end,
              color = function()
                local mode = vim.fn.mode()
                local mode_bg_colors = {
                  ['n'] = mocha.blue, ['i'] = mocha.green, ['v'] = mocha.mauve,
                  ['\22'] = mocha.mauve, ['V'] = mocha.mauve, ['c'] = mocha.yellow,
                  ['R'] = mocha.red, ['s'] = mocha.peach, ['S'] = mocha.peach,
                  ['t'] = mocha.teal, ['no'] = mocha.mauve, ['ic'] = mocha.mauve,
                  ['Rv'] = mocha.red, ['cv'] = mocha.flamingo, ['ce'] = mocha.flamingo,
                  ['r'] = mocha.sky, ['rm'] = mocha.sky, ['r?'] = mocha.sky,
                  ['!'] = mocha.maroon,
                }
                local bg_color = mode_bg_colors[mode] or mocha.surface0
                return { fg = mocha.base, bg = bg_color }
              end,
              padding = { left = 1, right = 1 },
              separator = { right = '' },
            },
            {
              function()
                local current_buf = vim.api.nvim_get_current_buf()
                local buffers = vim.tbl_filter(function(buf)
                  return vim.api.nvim_buf_is_valid(buf) and vim.bo[buf].buflisted
                end, vim.api.nvim_list_bufs())
                table.sort(buffers)

                local current_pos = 0
                for i, buf in ipairs(buffers) do
                  if buf == current_buf then
                    current_pos = i
                    break
                  end
                end

                if current_pos > 0 then
                  return string.format(" %d/%d", current_pos, #buffers)
                end
                return ""
              end,
              color = function()
                local is_modified = vim.bo[vim.api.nvim_get_current_buf()].modified
                return {
                  fg = mocha.base,
                  bg = is_modified and mocha.red or mocha.peach,
                }
              end,
              separator = { right = "" },
            },
          },

          lualine_b = {
            {
              function()
                local file = vim.fn.expand("%:p")
                local cwd = vim.loop.cwd()

                file = vim.fn.fnamemodify(file, ":.")
                cwd = cwd:gsub("/+$", "")

                local rel = vim.fn.fnamemodify(file, ":~:.")
                local segments = vim.split(rel, "/")

                local path
                if #segments >= 2 then
                  path = table.concat({ segments[#segments - 1], segments[#segments] }, "/")
                else
                  path = rel
                end

                return " " .. path
              end,
              color = {
                fg = mocha.base,
                bg = mocha.flamingo,
              },
              padding = { left = 1, right = 1 },
              separator = { right = "" },
            },
          },
          lualine_c = {

          },
          lualine_x = {{
            -- require("noice").api.status.mode.get,
            -- cond = require("noice").api.status.mode.has,
            -- color = { fg = "#ff9e64" },
          }},
          lualine_y = {
            -- Then the filetype component
            -- Define the common abbreviations table outside the component
            (function()
              -- Define the common abbreviations table
              local common_abbrevs = {
                -- Web development
                javascript = "JS",
                typescript = "TS",
                typescriptreact = "TSX",
                javascriptreact = "JSX",
                vue = "Vue",
                svelte = "Svelte",
                html = "HTML",
                css = "CSS",
                scss = "SCSS",
                sass = "Sass",

                -- Data formats
                json = "JSON",
                yaml = "YAML",
                yml = "YML",
                toml = "TOML",
                xml = "XML",

                -- Markup & Documentation
                markdown = "MD",
                mdx = "MDX",
                rst = "RST",

                -- Configuration & DevOps
                dockerfile = "Docker",
                docker = "Docker",
                ["docker-compose"] = "Compose",
                prisma = "Prisma",
                terraform = "TF",

                -- Programming languages
                lua = "Lua",
                python = "Py",
                rust = "Rust",
                go = "Go",
                php = "PHP",

                -- Shell
                sh = "SH",
                bash = "Bash",
                zsh = "ZSH",
                fish = "Fish",

                -- VIM
                vim = "Vim",
                nvim = "Nvim",
                vimdoc = "VimDoc",
              }

              -- Cache for dynamic abbreviations
              local abbrev_cache = {}

              -- Function to create dynamic abbreviation
              local function create_dynamic_abbrev(ft)
                -- Check cache first
                if abbrev_cache[ft] then
                  return abbrev_cache[ft]
                end

                local label

                -- Special cases for compound filetypes
                if ft:find("typescript") and ft:find("react") then
                  label = "TSX"
                elseif ft:find("javascript") and ft:find("react") then
                  label = "JSX"
                else
                  -- For other filetypes, create abbreviations by:
                  -- 1. Using uppercase for single-word filetypes up to 3 chars
                  if #ft <= 3 then
                    label = ft:upper()
                  -- 2. Using first letter uppercase for longer single-word filetypes
                  elseif not ft:find("[^%a]") then
                    -- No special characters, likely a single word
                    if #ft <= 6 then
                      -- Short enough to display as is with first letter capitalized
                      label = ft:sub(1,1):upper() .. ft:sub(2)
                    else
                      -- Longer filetype, use first letter and last few letters
                      label = ft:sub(1,1):upper() .. ft:sub(-3)
                    end
                  else
                    -- Otherwise, leave as is
                    label = ft
                  end
                end

                -- Cache the result
                abbrev_cache[ft] = label
                return label
              end

              -- Return the actual component
              return {
                function()
                  local ft = vim.bo.filetype
                  if ft ~= "" then
                    -- Get icon for the filetype (mini.icons handles its own caching)
                    local icon = require("mini.icons").get("filetype", ft) or ""

                    -- Use predefined abbreviation if available, otherwise get dynamic one
                    local label = common_abbrevs[ft] or create_dynamic_abbrev(ft)

                    return " " .. icon .. " " .. label .. " "
                  end
                  return ""
                end,
                color = {
                  fg = mocha.base,
                  bg = mocha.flamingo,
                },
                padding = { left = 1, right = 1 },
                separator = { left = '' },
              }
            end)(),
          },

          lualine_z = {
            {
              "progress",
              icon = "",
              color = { fg = mocha.base, bg = mocha.peach },
              padding = { left = 1, right = 1 },
            },
            {
              function()
                return " " .. vim.fn.line(".")
              end,
              padding = { left = 1, right = 1 },
              separator = { left = '' },
            },
          },
        },
      })
    end,
  },
}
