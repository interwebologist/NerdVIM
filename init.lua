-- █▓▒░⡷⠂Nvim Config⠐⢾░▒▓█
-- presistent undo , with undo statefile
vim.opt.undofile = true
vim.opt.undodir = "~/.config/nvim/undo"
vim.opt.clipboard = "unnamedplus" -- Clipboard integration
--Setup for Python Focus
vim.o.tabstop = 4               -- Number of spaces a tab counts for
vim.o.shiftwidth = 4            -- Number of spaces for each indentation
vim.o.expandtab = true          -- Convert tabs to spaces
vim.o.smartindent = true        -- Smart autoindenting on new lines
vim.o.wrap = false              -- Disable line wrapping
vim.o.cursorline = true         -- Highlight the current line
vim.o.termguicolors = true      -- Enable 24-bit RGB colors
vim.o.number = true             -- Show line numbers
-- Leader key setup = \ explicitly
vim.g.mapleader = "\\" -- Set space as the leader key
-- █▓▒░⡷⠂KEY MAPPINGS⠐⢾░▒▓█
-- ESC in term mode acts exactly as in editor
vim.keymap.set('t', '<Esc>', [[<C-\><C-n>]], { noremap = true }) -- In Terminal mode easily get back to Normal mode w/ Esc. 
-- terminal opens at bottom <leader>t
vim.keymap.set("n", "<leader>t", function()
      vim.cmd("botright split | resize 10 | terminal")
  end, { noremap = true, silent = true })
-- Quick maximize window
vim.keymap.set("n", "<leader>m", "<C-w>_<Enter>", { noremap = true, silent = true }) -- Maximize current window

-- █▓▒░⡷⠂KEY MAP NerdPrompt Window⠐⢾░▒▓█
vim.keymap.set("n", "<leader>np", function()
  -- 1. Prompt user for input
  local prompt = vim.fn.input("Prompt for nerdprompt: ")
  if prompt == "" then return end

  -- 2. Open a terminal in a horizontal split at the bottom, half screen
  vim.cmd("botright split | resize " .. math.floor(vim.o.lines / 2) .. " | terminal")

  -- 3. Enter terminal insert mode and send the command
  -- Wait a moment for terminal to initialize (sometimes needed)
  vim.defer_fn(function()
    local enter = vim.api.nvim_replace_termcodes("<CR>", true, true, true)
    -- Enter insert mode in terminal
    vim.fn.feedkeys("a", "n")
    -- Send the nerdprompt command with user input and press Enter
    vim.fn.feedkeys('nerdprompt "' .. prompt .. '"' .. enter, "n")
  end, 100)
end, { noremap = true, silent = true, desc = "Nerdprompt in terminal" })

-- █▓▒░⡷⠂KEY MAP Git, Add, Commit, Push⠐⢾░▒▓█

vim.keymap.set("n", "<leader>gcp", function()
    vim.cmd("write")
    vim.ui.input({ prompt = "Commit message: " }, function(msg)
        if msg and msg ~= "" then
            vim.cmd("!git add %")
            vim.cmd('!git commit -m "' .. msg .. '" %')
            vim.cmd("!git push")
            vim.cmd("botright split | resize 10 | terminal")
            
            vim.defer_fn(function()
                local enter = vim.api.nvim_replace_termcodes("<CR>", true, true, true)
                vim.fn.feedkeys("a", "n")
                vim.cmd("!git log -2")
            end, 1000)
        end
    end)
end, { noremap = true, silent = true })

-- █▓▒░⡷⠂LazyVIM & Plugins⠐⢾░▒▓█

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
--  {
--      'zbirenbaum/copilot.lua',
--      cmd = 'Copilot',
--      event = 'InsertEnter',
--      config = true,
--   },
--
{
    "CopilotC-Nvim/CopilotChat.nvim",
    dependencies = {
      { "github/copilot.vim" }, -- or zbirenbaum/copilot.lua
      { "nvim-lua/plenary.nvim", branch = "master" }, -- for curl, log and async functions
    },
    build = "make tiktoken", -- Only on MacOS or Linux
    opts = {
      -- See Configuration section for options
    },
    -- See Commands section for default commands if you want to lazy load on them
  },
  {
    's1n7ax/nvim-window-picker',
    name = 'window-picker',
    event = 'VeryLazy',
    version = '2.*',
    config = function()
      require'window-picker'.setup()
    end,
  },

  {
    "folke/noice.nvim",
    event = "VeryLazy",
    opts = {
      -- add any options here
    },
    dependencies = {
      "MunifTanjim/nui.nvim",
      -- Optional: for notification view
      "rcarriga/nvim-notify",
    },
  },

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
    keys = {
    --  { "at", "AvanteToggle", mode = "n", desc = "Toggle Avante" },
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
        auto_set_keymaps = false, -- prevent conflict
        auto_apply_diff_after_generation = false,
        support_paste_from_clipboard = false,
      },
--      mappings = {
--        ask = "<leader>aa",
--        edit = "ae",
--        refresh = "ar",
--        toggle = "at",
--      },
    },
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
      vim.keymap.set({"i", "s"}, "<C-j>", function()
        return require("luasnip").jump(1) or ""
      end, {expr = true})
      vim.keymap.set({"i", "s"}, "<C-k>", function()
        return require("luasnip").jump(-1) or ""
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

  -- Linting setup
  {
    "mfussenegger/nvim-lint",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      local lint = require("lint")
      lint.linters_by_ft = {
        lua = { "luacheck" },
        -- Add other filetypes and their linters here
        -- python = { "pylint" },
        -- javascript = { "eslint" },
      }

      lint.linters.luacheck = lint.linters.luacheck or {}
      lint.linters.luacheck.args = {
        "--no-unused-args",
        "--std",
        "luajit",
        "--globals",
        "vim",
        "--globals",
        "awesome",
        "--globals",
        "client",
        "--globals",
        "root",
      }

      -- Automatically lint after writing and when entering a buffer
      vim.api.nvim_create_autocmd({ "BufWritePost", "BufEnter" }, {
        callback = function()
          require("lint").try_lint()
        end,
      })

      -- Command to manually trigger linting
      vim.api.nvim_create_user_command("Lint", function()
        require("lint").try_lint()
      end, {})
    end,
  },
  {
    "stevearc/conform.nvim",
    event = { "BufWritePre" },
    cmd = { "ConformInfo" },
    config = function()
      require("conform").setup({
        formatters_by_ft = {
          lua = { "stylua" },
        },
        format_on_save = {
          timeout_ms = 500,
          lsp_fallback = true,
        },
      })
    end,
  },
  -- Statusline setup 
  {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    opts = function(_, opts)
      -- Add both the smiley and UFO emoji to lualine_x section
    end,
  },
-- Command cheatsheet <leader>?
{
  "bjarneo/lazyvim-cheatsheet.nvim",
  keys = {
    {
      "<leader>?",
      function()
        require("lazyvim-cheatsheet").show()
      end,
      desc = "Show LazyVim Cheatsheet",
    },
  },
},
 {'romgrk/barbar.nvim',
    dependencies = {
      'lewis6991/gitsigns.nvim', -- OPTIONAL: for git status
      'nvim-tree/nvim-web-devicons', -- OPTIONAL: for file icons
    },
    init = function() vim.g.barbar_auto_setup = false end,
    opts = {
      -- lazy.nvim will automatically call setup for you. put your options here, anything missing will use the default:
      -- animation = true,
      -- insert_at_start = true,
      -- …etc.
    },
    version = '^1.0.0', -- optional: only update when a new 1.x version is released
  },

})
