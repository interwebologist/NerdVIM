# Neovim Configuration

A modern Neovim setup focused on AI-assisted development, Python/Bash support, and efficient workflows.

## Features

- **Plugin Manager:** lazy.nvim
- **Theme:** Dracula
- **AI Assistant:** Claude 3.5 Sonnet via Avante.nvim  
  - Keymaps: `<leader>aa` (Ask), `<leader>ae` (Edit), `<leader>ar` (Refresh)
- **LSP:** Python (Pyright), Bash (bashls)
- **Syntax Highlighting:** Treesitter
- **File Explorer:** Neo-tree (v3)
- **Fuzzy Finder:** Telescope
- **Snippets:** LuaSnip (VSCode snippets, Tab/S-Tab navigation)
- **Autocomplete:** nvim-cmp (LSP, snippets, buffer, path)
- **Format/Lint:** none-ls

## Key Settings

```lua
vim.o.number = true
vim.g.mapleader = " "
