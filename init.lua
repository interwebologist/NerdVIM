-- Basic settings
vim.o.number = true
vim.g.mapleader = " "

-- Bootstrap lazy.nvim if not installed
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  {
    "Mofiqul/dracula.nvim",
    priority = 1000,
    config = function()
      require("dracula").setup({})
      vim.cmd[[colorscheme dracula]]
    end,
  },
{
  "yetone/avante.nvim",
  event = "VeryLazy",
  build = "make",
  -- Keymaps must be at this level (not inside opts)
  keys = {
    { "<leader>at", "<cmd>AvanteToggle<CR>", mode = "n", desc = "Toggle Avante" },
  },
  opts = {
    provider = "claude",
    claude = {
      endpoint = "https://api.anthropic.com",
      model = "claude-3-5-sonnet-20241022",
      temperature = 0,
      max_tokens = 4096,
    },
    behaviour = {
      auto_suggestions = false,
      auto_set_highlight_group = true,
      auto_set_keymaps = false, -- Changed to false to prevent conflict[3]
      auto_apply_diff_after_generation = false,
      support_paste_from_clipboard = false,
    },
    mappings = {
      ask = "<leader>aa",
      edit = "<leader>ae",
      refresh = "<leader>ar",
      toggle = "<leader>at",
    },
  },
  -- Dependencies must be at this level (not inside opts)
  dependencies = {
    "nvim-treesitter/nvim-treesitter",
    "stevearc/dressing.nvim",
    "nvim-lua/plenary.nvim",
    "MunifTanjim/nui.nvim",
    "nvim-tree/nvim-web-devicons",
    "zbirenbaum/copilot.lua",
  },
},
  { "nvim-neo-tree/neo-tree.nvim", branch = "v3.x" },
  { "nvim-treesitter/nvim-treesitter", build = ":TSUpdate" },
  { "nvimtools/none-ls.nvim" },
  {
    "neovim/nvim-lspconfig",
    config = function()
      require("lspconfig").pyright.setup {}
      require("lspconfig").bashls.setup {}
    end,
  },
  {
    "L3MON4D3/LuaSnip",
    dependencies = { "honza/vim-snippets" },
    config = function()
      require("luasnip.loaders.from_vscode").lazy_load()
      -- Optional: Keymaps for snippet navigation
      vim.keymap.set({"i", "s"}, "<Tab>", function()
        return require("luasnip").jump(1) or "<Tab>"
      end, {expr = true})
      vim.keymap.set({"i", "s"}, "<S-Tab>", function()
        return require("luasnip").jump(-1) or "<S-Tab>"
      end, {expr = true})
    end,
  },
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "saadparwaiz1/cmp_luasnip",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
    },
    config = function()
      local cmp = require("cmp")
      cmp.setup({
        snippet = {
          expand = function(args)
            require("luasnip").lsp_expand(args.body)
          end,
        },
        sources = {
          { name = "nvim_lsp" },
          { name = "luasnip" },
          { name = "buffer" },
          { name = "path" },
        },
      })
    end,
  },
  {
    "nvim-telescope/telescope.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
  },
})

