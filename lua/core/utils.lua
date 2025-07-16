-- ~/.config/nvim/lua/core/utils.lua
-- Utility functions

local M = {}

-- Toggle between buffer and last buffer (enhanced)
function M.toggle_buffer()
  local current_buf = vim.api.nvim_get_current_buf()
  local alt_buf = vim.fn.bufnr("#")

  -- Check if alternate buffer exists and is valid
  if alt_buf ~= -1 and alt_buf ~= current_buf and vim.fn.buflisted(alt_buf) == 1 then
    vim.cmd("buffer " .. alt_buf)
  else
    -- Fallback: find the most recent buffer
    local buffers = {}
    for _, buf in ipairs(vim.api.nvim_list_bufs()) do
      if vim.api.nvim_buf_is_loaded(buf) and vim.bo[buf].buflisted and buf ~= current_buf then
        table.insert(buffers, {
          buf = buf,
          lastused = vim.fn.getbufvar(buf, "changedtick"),
        })
      end
    end

    if #buffers > 0 then
      -- Sort by last used and switch to most recent
      table.sort(buffers, function(a, b) return a.lastused > b.lastused end)
      vim.cmd("buffer " .. buffers[1].buf)
    else
      vim.notify("No alternate buffer available", vim.log.levels.WARN)
    end
  end
end

-- NOTE: Buffer deletion functions removed - using snacks.bufdelete instead
-- snacks.bufdelete provides superior handling of:
-- - Modified buffers (prompts to save)
-- - Special buffers (terminals, help, etc.)
-- - Last buffer scenarios
-- - Window/split management

-- NOTE: Option toggle functions removed - using snacks.toggle instead
-- snacks.toggle provides superior functionality:
-- - Better UI with status messages
-- - Pre-configured common toggles
-- - Consistent keybinding patterns
-- - Integration with which-key
-- - Custom toggle creation API

-- Check if a plugin is loaded
function M.is_loaded(plugin)
  local lazy_config = require("lazy.core.config")
  return lazy_config.plugins[plugin] and lazy_config.plugins[plugin]._.loaded
end

-- Safely require a module
function M.safe_require(module)
  local ok, result = pcall(require, module)
  if not ok then
    vim.notify("Failed to load " .. module, vim.log.levels.ERROR)
    return nil
  end
  return result
end

-- Get project root based on git or common project files
function M.get_project_root()
  local root_files = {
    ".git",
    "Makefile",
    "package.json",
    "pyproject.toml",
    "Cargo.toml",
    "go.mod",
    "composer.json",
  }

  -- Start from current buffer's directory, fallback to cwd
  local current_dir = vim.fn.expand("%:p:h")
  if current_dir == "" or current_dir == "." then
    current_dir = vim.fn.getcwd()
  end

  -- Search upward for project root markers
  for _, file in ipairs(root_files) do
    local found = vim.fn.findfile(file, current_dir .. ";")
    if found ~= "" then
      return vim.fn.fnamemodify(found, ":p:h")
    end
    local found_dir = vim.fn.finddir(file, current_dir .. ";")
    if found_dir ~= "" then
      return vim.fn.fnamemodify(found_dir, ":p:h:h")
    end
  end

  -- Fallback: return absolute path of current working directory
  return vim.fn.fnamemodify(current_dir, ":p")
end


-- Create a centered floating window
function M.create_float_win(width_ratio, height_ratio, opts)
  opts = opts or {}
  local width = math.floor(vim.o.columns * width_ratio)
  local height = math.floor(vim.o.lines * height_ratio)
  local row = math.floor((vim.o.lines - height) / 2)
  local col = math.floor((vim.o.columns - width) / 2)

  local buf = vim.api.nvim_create_buf(false, true)
  local win_opts = vim.tbl_extend("force", {
    relative = "editor",
    width = width,
    height = height,
    row = row,
    col = col,
    style = "minimal",
    border = "rounded",
  }, opts)

  local win = vim.api.nvim_open_win(buf, true, win_opts)
  return buf, win
end

-- Get visual selection text
function M.get_visual_selection()
  local start_pos = vim.fn.getpos("'<")
  local end_pos = vim.fn.getpos("'>")
  local lines = vim.fn.getline(start_pos[2], end_pos[2])

  if #lines == 0 then
    return ""
  end

  lines[#lines] = string.sub(lines[#lines], 1, end_pos[3])
  lines[1] = string.sub(lines[1], start_pos[3])

  return table.concat(lines, "\n")
end

-- Format current buffer with LSP
function M.format_buffer()
  if vim.lsp.buf.format then
    vim.lsp.buf.format({ async = true })
  else
    vim.notify("No LSP formatter available", vim.log.levels.WARN)
  end
end

-- NOTE: Terminal management functions removed - using snacks.terminal instead
-- snacks.terminal provides superior functionality:
-- - Multiple terminal instances with different configs
-- - Floating, split, and full-screen modes
-- - Persistent terminal sessions
-- - Better key handling for zsh vi-mode
-- - Auto-insert mode on terminal open

-- Measure startup time
function M.measure_startup_time()
  local start_time = vim.fn.reltime()

  vim.api.nvim_create_autocmd("VimEnter", {
    once = true,
    callback = function()
      local elapsed = vim.fn.reltimestr(vim.fn.reltime(start_time))
      vim.notify("Startup time: " .. elapsed .. "s", vim.log.levels.INFO)
    end,
  })
end

-- Export utility functions globally
_G.Utils = M

return M
