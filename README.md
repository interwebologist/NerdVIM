# Neovim Configuration README

Modern Neovim setup focused on AI-assisted development and modern tooling. Built with `lazy.nvim`.

## Core Features

### **Theme**
- **Dracula.nvim**: Default colorscheme with classic Dracula styling.

### **AI Integration**
- **Avante.nvim**: Claude 3.5 Sonnet AI assistant (Anthropic API required)
  - Keymaps:
    - `<leader>aa`: Ask AI
    - `<leader>ae`: Edit with AI
    - `<leader>ar`: Refresh response
  - Configured for code analysis without auto-suggestions

### **Language Support**
- **LSP**: Pyright (Python) + bashls (Bash)
- **Treesitter**: Advanced syntax highlighting/parsing

### **Workflow Tools**
- **File Management**:
  - Neo-tree (v3): File explorer
  - Telescope: Fuzzy finder (needs keymap setup)
- **Editing**:
  - LuaSnip: Snippet engine with VSCode snippets
  - nvim-cmp: Autocomplete (LSP, snippets, buffers, paths)
  - Tab/S-Tab: Snippet navigation

### **Quality**
- none-ls: Formatting/linting framework
- Copilot.lua: Optional GitHub Copilot integration

## Key Settings

vim.o.number = true -- Line numbers
vim.g.mapleader = " " -- Space as leader key


