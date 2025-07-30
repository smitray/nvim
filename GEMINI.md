# 🛠️ Updated Neovim Configuration Project Summary (0.11+ Compatible)

## 📊 Project Overview
**Objective**: To achieve a modular, reusable configuration structure that has less loading time. Not interested in code folding and I like to keep it simple as buffer only approach.  
**Neovim Version**: 0.11+ with native LSP configuration

---

## 📚 Documentation Sources

### **Official Documentation References**
1. **Neovim Official Documentation**: https://neovim.io/doc/user/
   - LSP Documentation: https://neovim.io/doc/user/lsp.html
   - Diagnostic Documentation: https://neovim.io/doc/user/diagnostic.html
   - News 0.11: https://neovim.io/doc/user/news-0.11.html

2. **nvim-lspconfig**: https://github.com/neovim/nvim-lspconfig/tree/master/lsp
   - Server Configurations: https://github.com/neovim/nvim-lspconfig/blob/master/doc/configs.md

3. **trouble.nvim**: https://github.com/folke/trouble.nvim
   - Examples: https://github.com/folke/trouble.nvim/blob/main/docs/examples.md

4. **blink.cmp**: https://cmp.saghen.dev/
   - Configuration: https://cmp.saghen.dev/configuration/completion
   - Recipes: https://cmp.saghen.dev/recipes
   - Reference: https://cmp.saghen.dev/configuration/reference

5. **snacks.nvim**: https://github.com/folke/snacks.nvim
   - Picker Documentation: https://github.com/folke/snacks.nvim/blob/main/docs/picker.md
   - Explorer Documentation: https://github.com/folke/snacks.nvim/blob/main/docs/explorer.md
   - Dashboard Documentation: https://github.com/folke/snacks.nvim/blob/main/docs/dashboard.md
   - Styles Documentation: https://github.com/folke/snacks.nvim/blob/main/docs/styles.md
   - Input Documentation: https://github.com/folke/snacks.nvim/blob/main/docs/input.md
   - Words Documentation: https://github.com/folke/snacks.nvim/blob/main/docs/words.md
   - Dim Documentation: https://github.com/folke/snacks.nvim/blob/main/docs/dim.md

---

## 🔗 How blink.cmp Binds with LSP Servers

**The correct answer**: blink.cmp binds with languages through the **capabilities table** in each individual LSP server configuration file.

### **Example: `/lsp/lua_ls.lua`**
```lua
return {
  cmd = { 'lua-language-server' },
  filetypes = { 'lua' },
  root_markers = { '.luarc.json', '.luarc.jsonc', '.git' },
  capabilities = require('blink.cmp').get_lsp_capabilities(), -- This is the binding!
  settings = {
    Lua = {
      runtime = { version = 'LuaJIT' },
      diagnostics = { globals = { 'vim' } },
      workspace = {
        library = vim.api.nvim_get_runtime_file("", true),
        checkThirdParty = false,
      },
      hint = { enable = true },
    },
  },
}
```

### **Example: `/lsp/pyright.lua`**
```lua
return {
  cmd = { 'pyright-langserver', '--stdio' },
  filetypes = { 'python' },
  root_markers = { 'pyproject.toml', 'setup.py', 'requirements.txt', '.git' },
  capabilities = require('blink.cmp').get_lsp_capabilities(), -- Binding for Python
  settings = {
    python = {
      analysis = {
        autoSearchPaths = true,
        useLibraryCodeForTypes = true,
        typeCheckingMode = "basic",
      },
    },
  },
}
```

**Each LSP server file** in the `/lsp/` directory includes the `capabilities` table where blink.cmp (and other default capabilities) are added to tell that specific language server that it can send completion requests to blink.cmp.

---

## 🔬 Research Foundation: Neovim 0.11+ LSP Revolution

### Modern LSP Configuration for Neovim 0.11+

Neovim 0.11 represents the most significant leap in LSP functionality since its introduction, introducing native configuration APIs that dramatically simplify setup while reducing dependency on external plugins. **The new `vim.lsp.config()` and `vim.lsp.enable()` APIs make advanced LSP features accessible without complex plugin management**, fundamentally changing how we approach LSP configuration.

This transformation addresses the longstanding complexity of LSP setup by providing built-in auto-completion, enhanced diagnostics with virtual lines, simplified server configuration, and native inlay hints support. The changes represent a mature ecosystem where core functionality is built-in, while plugins enhance rather than enable basic features.

### Revolutionary changes in Neovim 0.11+

The new LSP system introduces two primary configuration methods that eliminate the need for nvim-lspconfig as a framework. **The `vim.lsp.config()` API allows direct server configuration**, while `vim.lsp.enable()` activates servers with minimal boilerplate. This approach supports both inline configuration and file-based setups where server configs live in `~/.config/nvim/lsp/<server_name>.lua`.

#### Native configuration approach

```lua
-- Direct inline configuration
vim.lsp.config.lua_ls = {
  cmd = { 'lua-language-server' },
  filetypes = { 'lua' },
  root_markers = { '.luarc.json', '.luarc.jsonc', '.git' },
  settings = {
    Lua = {
      runtime = { version = 'LuaJIT' },
      diagnostics = { globals = { 'vim' } },
      workspace = {
        library = vim.api.nvim_get_runtime_file("", true),
        checkThirdParty = false,
      },
      hint = { enable = true },
    },
  },
}

-- Enable servers with one command
vim.lsp.enable({ 'lua_ls', 'pyright', 'rust_analyzer' })
```

#### Built-in auto-completion revolution

Neovim 0.11 includes native LSP-driven completion without external dependencies, ported from nvim-lsp-compl. **This eliminates the need for completion plugins in simple setups** while maintaining compatibility with advanced solutions like nvim-cmp or the new high-performance blink.cmp.

```lua
vim.api.nvim_create_autocmd('LspAttach', {
  callback = function(ev)
    local client = vim.lsp.get_client_by_id(ev.data.client_id)
    if client and client:supports_method(vim.lsp.protocol.Methods.textDocument_completion) then
      vim.opt.completeopt = { 'menu', 'menuone', 'noinsert', 'fuzzy', 'popup' }
      vim.lsp.completion.enable(true, client.id, ev.buf, { autotrigger = true })
      vim.keymap.set('i', '<C-Space>', function()
        vim.lsp.completion.get()
      end)
    end
  end,
})
```

#### Enhanced diagnostics with virtual lines

```lua
vim.diagnostic.config({
  virtual_lines = {
    -- Only show virtual line diagnostics for the current cursor line
    current_line = true,
  },
})
```

#### Modern LspAttach pattern with LspDetach

```lua
vim.api.nvim_create_autocmd("LspAttach", {
    group = vim.api.nvim_create_augroup('lsp-attach', { clear = true }),
    callback = function(event)
        local map = function(keys, func, desc)
            vim.keymap.set("n", keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
        end
        
        -- Core navigation
        map("gl", vim.diagnostic.open_float, "Open Diagnostic Float")
        map("K", vim.lsp.buf.hover, "Hover Documentation")
        map("gs", vim.lsp.buf.signature_help, "Signature Documentation")
        map("gD", vim.lsp.buf.declaration, "Goto Declaration")
        map("<leader>v", "<cmd>vsplit | lua vim.lsp.buf.definition()<cr>", "Goto Definition in Vertical Split")
        
        -- Advanced features with capability checking
        local function client_supports_method(client, method, bufnr)
            if vim.fn.has 'nvim-0.11' == 1 then
                return client:supports_method(method, bufnr)
            else
                return client.supports_method(method, { bufnr = bufnr })
            end
        end
        
        local client = vim.lsp.get_client_by_id(event.data.client_id)
        
        -- Document highlighting with proper cleanup
        if client and client_supports_method(client, vim.lsp.protocol.Methods.textDocument_documentHighlight, event.buf) then
            local highlight_augroup = vim.api.nvim_create_augroup('lsp-highlight', { clear = false })
            vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
                buffer = event.buf,
                group = highlight_augroup,
                callback = vim.lsp.buf.document_highlight,
            })
            vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
                buffer = event.buf,
                group = highlight_augroup,
                callback = vim.lsp.buf.clear_references,
            })
            
            -- Critical: LspDetach cleanup to prevent memory leaks
            vim.api.nvim_create_autocmd('LspDetach', {
                group = vim.api.nvim_create_augroup('lsp-detach', { clear = true }),
                callback = function(event2)
                    vim.lsp.buf.clear_references()
                    vim.api.nvim_clear_autocmds { group = 'lsp-highlight', buffer = event2.buf }
                end,
            })
        end
        
        -- Inlay hints toggle
        if client and client_supports_method(client, vim.lsp.protocol.Methods.textDocument_inlayHint, event.buf) then
            map('<leader>th', function()
                vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled { bufnr = event.buf })
            end, '[T]oggle Inlay [H]ints')
        end
    end,
})
```

---

## 📁 Complete File Structure (Neovim 0.11+ Specification)

```
~/.config/nvim/
├── init.lua                    # Main entry point
├── lsp/                        # 🆕 LSP Server Configurations (Neovim 0.11+)
│   ├── lua_ls.lua              # Lua with Neovim globals
│   ├── pyright.lua             # Python type checking
│   ├── ruff_lsp.lua            # Python linting
│   ├── html.lua                # HTML with templating support
│   ├── cssls.lua               # CSS/SCSS/Less
│   ├── emmet_ls.lua            # Emmet for web development
│   ├── tsserver.lua            # TypeScript/JavaScript with inlay hints
│   ├── eslint.lua              # ESLint with flat config support
│   ├── biome.lua               # Biome with smart activation
│   ├── volar.lua               # Vue.js support
│   ├── svelte.lua              # Svelte framework
│   ├── astro.lua               # Astro framework
│   ├── jsonls.lua              # JSON with SchemaStore
│   ├── yamlls.lua              # YAML with schemas
│   ├── taplo.lua               # TOML support
│   ├── bashls.lua              # Bash scripting
│   └── marksman.lua            # Markdown with wiki links
└── lua/
    ├── core/                   # Core Infrastructure (100%)
    │   ├── init.lua            # Core module loader
    │   ├── options.lua         # Performance-optimized settings
    │   ├── keymaps.lua         # Global keymaps with descriptions
    │   ├── autocmd.lua         # Essential autocommands
    │   ├── utils.lua           # Utility functions
    │   ├── icons.lua           # Icon definitions and mappings
    │   ├── lsp.lua             # Native LSP configuration (0.11+)
    │   └── lazy.lua            # lazy.nvim bootstrap
    └── plugins/
        ├── init.lua            # Plugin loader framework
        ├── ui/                 # UI & Theme (100%)
        │   ├── snacks.lua      # Complete snacks.nvim ecosystem
        │   ├── catppuccin.lua  # Theme (mocha, Hyprland transparency)
        │   ├── lualine.lua     # Statusline (no git section)
        │   └── noice.lua       # Enhanced UI notifications
        ├── code/               # Updated: Syntax, Language & LSP Tools
        │   ├── treesitter.lua  # Advanced treesitter with context
        │   ├── mason.lua       # Mason LSP installer only
        │   ├── blink.lua       # Advanced completion with snippets
        │   ├── conform.lua     # Smart formatting with config detection
        │   └── trouble.lua     # Enhanced diagnostics & quickfix UI
        ├── editor/             # Editing & Navigation Tools (100%)
        │   ├── vim-tmux-navigator.lua # Seamless vim/tmux navigation
        │   ├── harpoon.lua            # Quick file bookmarking
        │   ├── grug-far.lua           # Modern search & replace
        │   ├── mini-ai.lua            # Advanced textobjects
        │   ├── flash.lua              # Motion & navigation
        │   ├── mini-surround.lua      # Surround operations
        │   ├── mini-splitjoin.lua     # Split/join constructs
        │   ├── mini-move.lua          # Line/selection movement
        │   ├── mini-pairs.lua         # Auto-pairing
        │   └── rainbow-delimiters.lua # Rainbow brackets
        ├── git/                # Git Integration (100%)
        │   ├── gitsigns.lua    # Git signs with hunk operations
        │   └── diffview.lua    # Advanced diff viewer
        ├── ai/                 # AI Integration (100%)
        │   ├── avante.lua      # Cursor-style AI assistant (Claude)
        │   ├── codecompanion.lua # Chat-based AI assistant
        │   └── copilot.lua     # GitHub Copilot integration
        └── db/                 # Database Tools (100%)
            └── dadbod.lua      # Database interface
```

---

## 🔄 Major Structure Changes (Neovim 0.11+)

### **🆕 New LSP Architecture**
1. **`/lsp/` folder at project root** - Contains all individual LSP server configurations
2. **`core/lsp.lua`** - Native Neovim 0.11+ LSP configuration and management
3. **`core/icons.lua`** - Centralized icon definitions and mappings
4. **Simplified plugin structure** - LSP-related plugins moved to `plugins/code/`

### **📦 Reorganized Plugin Structure**

#### **`plugins/code/` (Updated)**
- **`mason.lua`** - Only Mason LSP installer (no mason-lspconfig or mason-tool-installer)
- **`blink.lua`** - Advanced completion with snippets
- **`conform.lua`** - Smart formatting with config detection  
- **`trouble.lua`** - Enhanced diagnostics & quickfix UI
- **`treesitter.lua`** - Advanced treesitter with context

---

## 🎯 Complete Plugin Ecosystem (30 plugins, simplified)

### **🍿 Core Framework (3 plugins)**
- **`lazy.nvim`** - Plugin manager with intelligent lazy-loading
- **`snacks.nvim`** - 18-module ecosystem (picker, explorer, notifier, etc.)
- **`catppuccin`** - Theme with Hyprland transparency

### **🎨 UI & Interface (3 plugins)**
- **`lualine.nvim`** - Statusline (no git section, uses gitmux)
- **`noice.nvim`** - Enhanced UI notifications, cmdline, LSP progress
- **`nvim-web-devicons`** - File icons

### **🧠 Language & Syntax (6 plugins)**
- **`nvim-treesitter`** - Syntax highlighting & parsing
- **`nvim-ts-autotag`** - Auto-close HTML/JSX tags
- **`ts-comments.nvim`** - Smart commenting
- **`nvim-treesitter-textobjects`** - Advanced textobjects
- **`nvim-treesitter-context`** - Show function/class context
- **`playground`** - Treesitter debugging

### **🔧 Code & LSP Tools (4 plugins, simplified)**
- **`mason.nvim`** - LSP installer only (simplified)
- **`blink.cmp`** - Modern completion with snippets
- **`conform.nvim`** - Intelligent formatting
- **`trouble.nvim`** - Enhanced diagnostics & quickfix UI

### **✏️ Editing & Navigation (9 plugins)**
- **`vim-tmux-navigator`** - Seamless vim/tmux navigation
- **`harpoon`** - Quick file bookmarking system (v2)
- **`grug-far.nvim`** - Modern search & replace UI
- **`mini.ai`** - Enhanced textobjects (functions, classes, etc.)
- **`flash.nvim`** - Motion & navigation
- **`mini.surround`** - Add/delete/replace surroundings
- **`mini.splitjoin`** - Toggle single/multi-line constructs
- **`mini.move`** - Move lines/selections with Alt+hjkl
- **`mini.pairs`** - Auto-pairing for regular typing
- **`rainbow-delimiters.nvim`** - Rainbow bracket highlighting

### **🔀 Git Integration (2 plugins)**
- **`gitsigns.nvim`** - Git signs in gutter with staging
- **`diffview.nvim`** - Advanced diff viewer & merge conflicts

### **🤖 AI Integration (3 plugins)**
- **`avante.nvim`** - Cursor-style AI assistant (Claude)
- **`codecompanion.nvim`** - Chat-based AI assistant
- **`copilot.lua`** - GitHub Copilot integration

### **🗄️ Database Tools (1 plugin)**
- **`vim-dadbod-ui`** - Database interface with connection management

---

## 🍿 Complete snacks.nvim Ecosystem (18 modules)

### **Core Functionality Modules (9 enabled)**
1. **`picker`** - Unified fuzzy finder (replaces Telescope)
   - **Submodules (24 pickers)**:
     - **File & Buffer (5)**: `files`, `git_files`, `buffers`, `recent`, `smart`
     - **Search (4)**: `grep`, `grep_word`, `grep_buffers`, `lines`
     - **Project (1)**: `projects`
     - **Git (6)**: `git_diff`, `git_status`, `git_log_file`, `git_branches`, `git_commits`, `git_log`
     - **Commands (3)**: `commands`, `command_history`, `keymaps`
     - **System (2)**: `help`, `autocmds`
     - **LSP (7)**: `diagnostics`, `diagnostics_buffer`, `lsp_symbols`, `lsp_workspace_symbols`, `lsp_definitions`, `lsp_references`, `lsp_implementations`
     - **Utilities (8)**: `undo`, `resume`, `notifications`, `registers`, `jumps`, `highlights`, `spelling`, `search_history`

2. **`explorer`** - File manager (right sidebar, auto-close)

3. **`bufdelete`** - Smart buffer management
   - **Functions**: `bufdelete()`, `bufdelete.other()`, `bufdelete.all()`

4. **`notifier`** - Notification system (replaces nvim-notify)
   - **Functions**: `show_history()`, `hide()`, timeout configuration

5. **`terminal`** - Enhanced terminal management
   - **Features**: Floating windows, multiple instances, key handling

6. **`scratch`** - Project-specific scratch buffers
   - **Functions**: `scratch()`, `scratch.select()`, `scratch():toggle()`

7. **`rename`** - File rename with import updates
   - **Functions**: `rename_file()`

8. **`lazygit`** - Lazygit integration
   - **Functions**: `lazygit()`

9. **`git`** - Enhanced git blame & history
   - **Functions**: `git.blame_line()`, git history navigation

### **Visual & Navigation Modules (5 enabled)**
10. **`words`** - Word highlighting & navigation
    - **Functions**: `words.jump()`, reference highlighting

11. **`zen`** - Focus mode with zoom functionality
    - **Modes**: 
      - `zen()` - Full zen mode (hide statusline, tabline)
      - `zen.zoom()` - Zoom mode (show statusline, tabline)
    - **Toggles**: git_signs, mini_diff_signs configuration

12. **`dim`** - Inactive window dimming
    - **Features**: Automatic dimming of inactive windows

13. **`statuscolumn`** - Enhanced status column
    - **Features**: Line numbers, git signs, fold indicators

14. **`indent`** - Smart indentation guides
    - **Functions**: `indent` toggle, visual indentation guides

### **Performance & QoL Modules (4 enabled)**
15. **`quickfile`** - Fast file opening optimization
    - **Features**: Optimized file loading for better performance

16. **`bigfile`** - Large file optimization (1.5MB threshold)
    - **Features**: Automatic handling of large files, plugin disabling

17. **`toggle`** - Unified option toggles
    - **Available Toggles**:
      - `toggle.option("spell")` - Spelling
      - `toggle.option("wrap")` - Line wrap
      - `toggle.option("relativenumber")` - Relative numbers
      - `toggle.diagnostics()` - LSP diagnostics
      - `toggle.line_number()` - Line numbers
      - `toggle.option("conceallevel")` - Conceal level
      - `toggle.treesitter()` - Treesitter
      - `toggle.option("background")` - Dark/light background
      - `toggle.inlay_hints()` - LSP inlay hints
      - `toggle.indent()` - Indent guides

18. **`input`** - Enhanced vim.ui.input
    - **Features**: Better input dialogs and prompts

---

## 🎯 Language Support (15 LSP servers)

| Language | LSP Server | Formatter | Linter | Features |
|----------|------------|-----------|---------|----------|
| **Lua** | lua_ls | stylua | lua_ls | Neovim globals, diagnostics |
| **Python** | pyright + ruff_lsp | black + isort | ruff | Type checking, fast linting |
| **TypeScript/JS** | tsserver | prettierd/biome | eslint/biome | Inlay hints, smart detection |
| **HTML** | html + emmet_ls | prettierd | - | Auto-completion, emmet |
| **CSS/SCSS** | cssls | prettierd | - | Color preview, validation |
| **Vue.js** | volar | prettierd | - | SFC support, TypeScript |
| **Svelte** | svelte | prettierd | - | Component intelligence |
| **Astro** | astro | prettierd | - | Framework support |
| **JSON/YAML** | jsonls + yamlls | prettierd | - | Schema validation |
| **TOML** | taplo | taplo | - | Config file support |
| **Markdown** | marksman | prettierd | - | Wiki links, references |
| **Bash** | bashls | shfmt | - | Scripting support |

---

## 🔑 Key Features & Workflows

### **🧭 Navigation & File Management**
- **Harpoon**: Quick file bookmarking with `<leader>ha` and `<leader>1-5`
- **Tmux Integration**: Seamless `Ctrl+hjkl` navigation between vim/tmux
- **Search & Replace**: Live preview with grug-far using ripgrep
- **File Explorer**: snacks.explorer with auto-close and smart behavior
- **Buffer-Only**: No tabs, enhanced buffer navigation with Shift+HL

### **📝 Editing Workflow**
- **Textobjects**: mini.ai + treesitter (functions, classes, parameters)
- **Surround**: `sa"` add quotes, `sd"` delete quotes, `sr"'` replace
- **Movement**: Alt+hjkl for lines/selections, flash.nvim for motions
- **Auto-pairs**: Comprehensive pairing for `()`, `[]`, `{}`, quotes
- **Split/Join**: `gS` toggle between single/multi-line constructs
- **Rainbow**: Visual bracket highlighting with catppuccin integration

### **🤖 AI Integration**
- **Avante**: Cursor-style AI with Claude integration for inline assistance
- **CodeCompanion**: Chat-based AI for complex discussions and code review
- **Copilot**: GitHub suggestions with smart triggering and panel access

### **🔀 Git Workflow**
- **Gitsigns**: Hunk navigation, staging, blame with `<leader>h*` keymaps
- **Diffview**: Advanced 2/3/4-way diff views with merge conflict resolution
- **Lazygit**: Full git interface integration
- **Terminal Git**: Complete git workflow through snacks.terminal

### **⚡ Performance Optimizations**
- **Startup**: 15+ disabled built-in plugins, lazy-loading
- **Large Files**: snacks.bigfile handles 1.5MB+ files
- **Memory**: Smart buffer management, conditional context
- **Loading**: Event-driven plugin loading, minimal dependencies

---

## 🎯 Keymap Philosophy

All keymaps follow the consistent `[x]word [y]word` format for better discoverability:

**Examples:**
- `<leader>ha` - **[h]arpoon [a]dd file**
- `<leader>sr` - **[s]earch and [r]eplace**
- `<leader>hs` - **[h]unk [s]tage**
- `<leader>aa` - **[a]vante [a]sk**
- `<leader>xx` - **trouble [x]diagnostics toggle [x]**

---

## 📊 Updated Project Statistics

- **Total Plugins**: 30 plugins (reduced from 34, simplified)
- **Core Files**: 8 files (added `core/icons.lua`)
- **Plugin Files**: 25+ files (reorganized structure)
- **LSP Server Files**: 15 individual server configurations
- **Languages Supported**: 12+ languages with full tooling
- **AI Providers**: 3 different AI assistants
- **Startup Time**: Optimized for minimal loading time
- **Architecture**: Modular, reusable configuration structure
- **snacks.nvim Modules**: 18 enabled modules with 24 picker submodules

---

## 🚀 Migration Benefits (0.11+ Update)

### **Simplified LSP Stack**
- ✅ **Fewer dependencies** with native LSP improvements
- ✅ **Cleaner configuration** with separated server configs
- ✅ **Better performance** using Neovim 0.11+ optimizations
- ✅ **Easier maintenance** with modular LSP server files

### **Enhanced Developer Experience**
- ✅ **Faster startup** with reduced plugin count
- ✅ **Better LSP UI** with native improvements
- ✅ **Simplified debugging** with clearer separation of concerns
- ✅ **Future-proof architecture** leveraging latest Neovim features

### **Maintained Functionality**
- ✅ **All language support preserved** (15 LSP servers)
- ✅ **Complete tooling maintained** (formatting, linting, completion)
- ✅ **AI integration unchanged** (3 AI assistants)
- ✅ **Navigation and editing tools preserved** (Mini.nvim, Harpoon, etc.)

**This updated configuration leverages Neovim 0.11+ native LSP improvements while maintaining all the powerful features and performance optimizations of the original setup! 🎉**
