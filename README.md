# NerdVIM

### Neovim Configuration
UI shots:
![NerdVIM UI Screenshot](images/UI4.png)
![NerdVIM UI Screenshot](images/UI3.png)
![NerdVIM UI Screenshot](images/UI.png)

NerdVIM with CodeCompanion running Anthropic Claude 3.7 paid model.
Picks up Env var for API key automatically. 
![NerdVIM AI Prompt Example](images/codecompanion.png)
NerdPrompt Perplexity.AI "\np" leader hotkey.
![NerdVIM AI Prompt Example](images/nerdprompt1.png)
![NerdVIM AI Prompt Example](images/nerdprompt2.png) 


This configuration is focused on productivity, code quality, and a modern Neovim experience, with special attention on development and AI-powered tooling.

Python, Lua, Javascript, Typescript, Bash support. Add your own!

This README describes the main plugins and features included in your Neovim setup, based on your `init.lua`. It highlights the primary plugins, their purpose, and how they enhance your workflow.

## Main Plugins

### AI & Code Assistance

- **codecompanion.nvim**
  Integrates with external AI models (e.g., Anthropic Claude) for code chat and inline assistance directly in Neovim.

- **claudecode.nvim**
  Native Claude Code integration via WebSocket providing real-time context tracking, diff support, and seamless Claude Code CLI integration.

- **NerdPrompt**
  `<leader>np` is mapped to trigger Perplexity.AI via [NerdPrompt](https://github.com/interwebologist/NerdPrompt/tree/main), enabling you to interact with Perplexity.AI from within Neovim.
  **Note:** NerdPrompt must be installed separately.

- **minuet-ai.nvim**
  RAG-powered AI code completion using local Ollama models. Provides semantic code completions with full codebase context awareness through VectorCode integration.

- **VectorCode**
  Semantic code indexing and RAG (Retrieval-Augmented Generation) system using `nomic-embed-text` embeddings via Ollama. Automatically indexes your codebase and retrieves relevant snippets for AI completions.

#### How Intelligent AI Autocomplete using Minuet & VectorCode(ChormaDB RAG) Works

**Semantic RAG Flow:**
1. VectorCode continuously indexes your codebase using `nomic-embed-text` embeddings if you set this up in pre-commit hook or run the command on the repo.
2. When you type, VectorCode retrieves the 3 most semantically relevant code snippets
3. Minuet sends these snippets + your current context to Llama-server's `qwen2.5-coder:7B-instruct` (6GB) model (In My personal case)
4. The FIM model generates completions aware of your entire codebase
5. Completions appear in blink.cmp alongside LSP suggestions

**Usage**

Normal Workflow:
- Install VectorCode to system wide pip, not .venv for the project.
- Just start typing - minuet completions appear automatically in the completion menu
- Press `<C-y>` to accept (standard blink.cmp)
- Press `<A-y>` to manually trigger minuet completions

VectorCode Commands:
- `:VectorCode register` - Manually register current buffer 
- `:VectorCode deregister` - Stop RAG for current buffer
- `:VectorCode vectorise` - Index entire project
- `:VectorCode query <text>` - Search semantic context text

**Per-Project Setup**

When you cd into a new codebase:
1. VectorCode will create a `.vectorcode/` directory in that project
2. Buffers auto-register on file open
3. Each project maintains its own semantic index
4. RAG context is project-specific

**Testing**

To test the setup:
1. Reload Neovim (restart nvim or `:Lazy sync`)
2. Open a Python/Lua/JS file in any project
3. Start typing a function - you should see completions with RAG context
4. Check `:messages` for VectorCode registration notifications

**Troubleshooting**

If completions aren't working:
- Ensure Ollama is running: `ollama list`
- Check VectorCode: `vectorcode version` (should be 0.7.20)
- Verify registration: Look for VectorCode notifications when opening files
- Check logs: `:messages` for errors

### AI Completion - Alt-y
**`Alt-y` (Option-y on Mac)**: Manually trigger Minuet AI completion with RAG context
- Queries your codebase semantically via VectorCode
- Sends relevant code snippets to Llama `qwen2.5-coder:7B-instruct-Q5_K_M.GGUF` model. My research shows this is on of the better model currently.
- Generates context-aware completions using FIM (Fill-In-Middle)

## Key Features & Custom Mappings

### Leader Key
**The leader key is `\` (backslash)** - Neovim's default. All `<leader>` keybindings use backslash.
**Usage:** Press `\` followed by the key combo (e.g., `\t` for terminal, `\cc` for CodeCompanion)

- **Mini and Rest Break Timers**
  Get reminders to take a microbreak and a restbreak. Disable the timers in the config file at the top of init.lua if not needed

- **Persistent Undo**  
  Undo history is saved across sessions for better workflow continuity.

- **Clipboard Integration**  
  Seamless copy-paste between Neovim and your system clipboard.

- **Python-centric Indentation**  
  Tabs and indentation are set to 4 spaces, tailored for Python development.

- **Custom Terminal and Window Shortcuts**  
  - `t`: Open a terminal at the bottom split.
  - `m`: Maximize current window.
  - `np`: Open a "nerdprompt" terminal with user input.
  - `gcp`: Add, commit, and push current file with a prompted git commit message while inside a git repo.
  - `ct`: Toggle Claude Code terminal.
  - `cs`: Send visual selection to Claude Code (visual mode).
  - `ca`: Accept Claude Code diff suggestions.
  - `cr`: Reject Claude Code diff suggestions.

- **Auto-linting and Formatting**  
  Linting and formatting are triggered automatically on file save and buffer enter.

- **Command Cheatsheet**  
  Press `?` to open your custom cheatsheet for quick reference.

## Theme

- **Dracula** is the default color scheme, providing a dark, vibrant look.

### UI & Usability

- **cheatsheet.nvim**  
  Provides an in-editor "\?" custom command cheatsheet, allowing you to quickly reference and edit custom commands. Just the ones you add to cheatsheet.txt.

- **noice.nvim**  
  Enhances command-line and message UI with popups and a centered command palette for better visibility.

- **lualine.nvim**  
  A fast and customizable statusline, displaying useful information at the bottom of the editor.

- **barbar.nvim**  
  Offers a modern tabline for buffer management, making it easy to switch between open files.

- **neo-tree.nvim**  
  File explorer sidebar for navigating and managing the project tree visually.

- **diagflow.nvim**  
  Displays diagnostics (like LSP, Lint errors and warnings when you hover over squiggles) at the top of the window, right-aligned, for immediate feedback while coding.

### LSP, Completion, and Code Intelligence

- **nvim-lspconfig**  
  Simplifies configuring built-in LSP (Language Server Protocol) support for multiple languages, including Python, Lua, Bash, and JavaScript/TypeScript.

- **mason.nvim**  
  Manages external tools (LSP servers, linters, formatters, DAPs) with automatic installation support.

- **nvim-treesitter**  
  Advanced syntax highlighting and code parsing for better code understanding and manipulation.

- **none-ls.nvim**  
  Allows integrating external tools (like linters and formatters) as sources for LSP features.

- **nvim-lint**  
  Asynchronous linting engine, automatically runs linters (like pylint, luacheck, eslint) on save and buffer enter.

- **conform.nvim**  
  Handles code formatting, with support for format-on-save and fallback to LSP formatting.

- **blink.cmp**  
  Modern and fast autocompletion engine, supporting multiple sources (LSP, snippets, buffer, path) and customizable key mappings.

### Utilities

- **telescope.nvim**  
  (As a dependency) Powerful fuzzy finder for files, buffers, and more.

- **friendly-snippets**  
  (As a dependency) Collection of community-driven code snippets for use with completion engines.

---
