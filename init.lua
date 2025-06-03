-- █▓▒░⡷⠂Nvim Config⠐⢾░▒▓█
-- Leader key is set to \ (Default in Neovim). Don't use M(alt) or C(ctrl)
-- it can cause conflicts with vim/iterm

-- presistent undo
vim.opt.undofile = true
vim.opt.undodir = "~/.config/nvim/undo"
vim.opt.clipboard = "unnamedplus" -- Clipboard integration
--Setup for Python Focus
vim.o.tabstop = 4                 -- Number of spaces a tab counts for
vim.o.softtabstop = 4             -- Number of spaces a tab counts for while editing
-- vim.o.shiftwidth = 4              -- Number of spaces for each indentation
vim.o.expandtab = true            -- Convert tabs to spaces
vim.o.smartindent = true          -- Smart autoindenting on new lines
vim.o.wrap = false                -- Disable line wrapping
vim.o.cursorline = true           -- Highlight the current line
vim.o.termguicolors = true        -- Enable 24-bit RGB colors
vim.o.number = true               -- Show line numbers
vim.hlsearch = true               -- Highlight search results

-- █▓▒░⡷⠂KEY MAPPINGS⠐⢾░▒▓█
-- close and open to enable changes

-- ESC in term mode acts exactly as in editor to switch to normal mode
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
        vim.cmd("botright vsplit | terminal ")

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
                        vim.cmd("botright split | resize 10 | terminal git log -2")
                end
        end)
end, { noremap = true, silent = true })

-- █▓▒░⡷⠂Autogroups⠐⢾░▒▓█
-- when over squggly, show diagnostics
vim.o.updatetime = 250 -- Set a short delay for CursorHold
vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
        callback = function()
                vim.diagnostic.open_float(nil, {
                        -- focus = false
                        focusable = false,
                        close_events = { "CursorMoved", "CursorMovedI", "BufLeave", "InsertEnter" }
                })
        end,
})

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

        {
                "folke/noice.nvim", -- this make cmd in center, and popups
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
        -- Theme
        {
                "Mofiqul/dracula.nvim",
                priority = 1000,
                config = function()
                        require("dracula").setup({})
                        vim.cmd [[colorscheme dracula]]
                end,
        },

        {
                "yetone/avante.nvim",
                event = "VeryLazy",
                build = "make",
                keys = {
                        --  { "<C-a>t", "AvanteToggle", mode = "n", desc = "Toggle Avante" },
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
                        mappings = {
                                ask = "<leader>aa",     -- Ask Avante a question
                                edit = "<leader>ae",    -- Edit the current buffer with Avante.Use in Visual mode to
                                refresh = "<leader>ar", -- Refresh the Avante window
                                toggle = "<leader>at",  -- Toggle the Avante window
                        },
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

        { "nvim-neo-tree/neo-tree.nvim",     branch = "v3.x" },
        { "nvim-treesitter/nvim-treesitter", build = ":TSUpdate" },
        { "nvimtools/none-ls.nvim" },
        {
                -- Mason for LSP,Linters,DAPs,Formatters(think brew for Neovim)
                "williamboman/mason.nvim",
                config = function()
                        require("mason").setup({
                                ensure_installed = {
                                        -- Lua
                                        "luacheck",
                                        -- Python
                                        "ruff",
                                        "mypy",
                                        "black",
                                        -- JavaScript/TypeScript
                                        "eslint_d",
                                        -- Shell
                                        "shellcheck",
                                        -- Global
                                        "typos",
                                }
                        })
                end
        },
        -- Linting with nvim-lint
        {
                "mfussenegger/nvim-lint",
                config = function()
                        local lint = require('lint')

                        -- Configure linters by filetype
                        lint.linters_by_ft = {
                                python = { 'pylint' }
                        }

                        -- Configure pylint to work with virtual environments
                        lint.linters.pylint.cmd = 'python'
                        lint.linters.pylint.args = { '-m', 'pylint', '-f', 'json' }

                        -- Auto-lint on save
                        vim.api.nvim_create_autocmd({ "BufWritePost" }, {
                                callback = function()
                                        lint.try_lint()
                                end,
                        })
                end
        },
        -- LSP configuration
        {
                "neovim/nvim-lspconfig",
                dependencies = { 'saghen/blink.cmp' },
                config = function()
                        local capabilities = require('blink.cmp').get_lsp_capabilities()
                        local lspconfig = require('lspconfig')

                        lspconfig['lua_ls'].setup({ capabilities = capabilities })
                        -- end
                        --    config = function()
                        require("lspconfig").pyright.setup {}
                        require("lspconfig").bashls.setup {}
                        require("lspconfig").ts_ls.setup {}
                        require("lspconfig").lua_ls.setup {
                                settings = {
                                        Lua = {
                                                diagnostics = {
                                                        globals = { 'vim' }
                                                }
                                        }
                                }
                        }
                end
        },
        -- linting will add logic and formatting checks outside of LSP
        {
                "mfussenegger/nvim-lint",
                event = { "BufReadPre", "BufNewFile" },
                config = function()
                        local lint = require("lint")
                        lint.linters_by_ft = {
                                lua = { "luacheck" },
                                python = { "pylint" },
                                javascript = { "eslint" },
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
                                "<leader>h",
                                function()
                                        require("lazyvim-cheatsheet").show()
                                end,
                                desc = "Show LazyVim Cheatsheet",
                        },
                },
        },
        {
                'romgrk/barbar.nvim',
                dependencies = {
                        'lewis6991/gitsigns.nvim',     -- OPTIONAL: for git status
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
        -- copilot load after deps so keys work

        --    {
        --        "zbirenbaum/copilot.lua",
        --        cmd = "Copilot",
        --        build = ":Copilot auth",
        --        event = "BufReadPost",
        --        opts = {
        --            suggestion = {
        --                enabled = true,
        --                auto_trigger = true,
        --                hide_during_completion = false,
        --                -- Not global keymaps, but local to the plugin, so does show up in :map
        --                keymap = {
        --                    accept = "<leader>y",
        --                    next = "<leader>j",
        --                    prev = "<leader>k",
        --                    dismiss = "<leader>n",
        --                },
        --            },
        --            panel = { enabled = false },
        --            filetypes = {
        --                markdown = true,
        --                help = true,
        --            },
        --        },
        --    },
        -- SuperMavon a replacement for Copilot thats faster and more context aware. test it out later. running w/ pro account
        {
                "supermaven-inc/supermaven-nvim",
                keymaps = {
                        accept_suggestion = "<Tab>", -- handled by nvim-cmp / blink.cmp:
                        clear_suggestion = "<C-]>",
                        accept_word = "<C-j>",
                },
                event = "InsertEnter",
                cmd = {
                        "SupermavenUseFree",
                        "SupermavenUsePro",
                },
                opts = {
                        keymaps = {
                                accept_suggestion = nil, -- handled by nvim-cmp / blink.cmp
                        },
                        disable_inline_completion = vim.g.ai_cmp,
                        ignore_filetypes = { "bigfile", "snacks_input", "snacks_notif" },
                },
        },
        -- Blick CMP
        {
                'saghen/blink.cmp',
                dependencies = { 'rafamadriz/friendly-snippets' },
                version = '1.*',
                opts = {
                        -- 'default' (recommended) for mappings similar to built-in completions (C-y to accept)
                        -- 'super-tab' for mappings similar to vscode (tab to accept)
                        -- 'enter' for enter to accept
                        -- 'none' for no mappings
                        --
                        -- All presets have the following mappings:
                        -- C-space: Open menu or open docs if already open
                        -- C-n/C-p or Up/Down: Select next/previous item
                        -- C-e: Hide menu
                        -- C-k: Toggle signature help (if signature.enabled = true)
                        --
                        -- See :h blink-cmp-config-keymap for defining your own keymap
                        keymap = { preset = 'default' },

                        appearance = {
                                -- 'mono' (default) for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
                                -- Adjusts spacing to ensure icons are aligned
                                nerd_font_variant = 'mono'
                        },

                        -- (Default) Only show the documentation popup when manually triggered
                        completion = { documentation = { auto_show = true } },

                        -- Default list of enabled providers defined so that you can extend it
                        -- elsewhere in your config, without redefining it, due to `opts_extend`
                        sources = {
                                default = { 'lsp', 'path', 'snippets', 'buffer' },
                        },

                        -- (Default) Rust fuzzy matcher for typo resistance and significantly better performance
                        -- You may use a lua implementation instead by using `implementation = "lua"` or fallback to the lua implementation,
                        -- when the Rust fuzzy matcher is not available, by using `implementation = "prefer_rust"`
                        --
                        -- See the fuzzy documentation for more information
                        fuzzy = { implementation = "prefer_rust_with_warning" }
                },
                opts_extend = { "sources.default" }
        },
        {
                "olimorris/codecompanion.nvim",
                dependencies = {
                        "nvim-lua/plenary.nvim",
                        "nvim-treesitter/nvim-treesitter",
                        "hrsh7th/nvim-cmp",                      -- Optional: For using slash commands and variables in the chat buffer
                        "nvim-telescope/telescope.nvim",         -- Optional: For using slash commands
                        { "stevearc/dressing.nvim", opts = {} }, -- Optional: Improves `vim.ui.select`
                },
                config = function()
                        require("codecompanion").setup({
                                adapters = {
                                        anthropic = function()
                                                return require("codecompanion.adapters").extend("anthropic", {
                                                        env = {
                                                                api_key = "cmd:echo $ANTHROPIC_API_KEY"
                                                        },
                                                        schema = {
                                                                model = {
                                                                        default = "claude-sonnet-4-20250514"
                                                                }
                                                        }
                                                })
                                        end
                                },
                                strategies = {
                                        chat = {
                                                adapter = "anthropic",
                                        },
                                        inline = {
                                                adapter = "anthropic",
                                        }
                                }
                        })
                end,
        }

})
