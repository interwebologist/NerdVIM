-- █▓▒░⡷⠂Nvim Config⠐⢾░▒▓█
-- ╔═══════════════════════════════════════════════════════════════════╗
-- ║ LEADER KEY: \ (backslash) - Default in Neovim                   ║
-- ║ NOTE: Don't use M(alt) or C(ctrl) as leader - conflicts with    ║
-- ║ vim/iTerm. The leader key is NOT explicitly set in this config   ║
-- ║ because we use Neovim's default backslash (\) leader.            ║
-- ╚═══════════════════════════════════════════════════════════════════╝

-- Add VectorCode CLI to PATH
vim.env.PATH = vim.env.HOME .. "/.local/bin:" .. vim.env.PATH

-- █▓▒░⡷⠂Break Timers⠐⢾░▒▓█
-- Define a boolean to control timer activation for 10 min mini break and 60 min break reminders
-- See :h pulse.nvim for documentation for using break timers
local enable_timers = false -- Set to false to disable all micro break and break timers.
local microbreak_interval = 10
local restbreak_interval = 60

-- presistent undo
vim.opt.undofile = true
vim.opt.undodir = "~/.config/nvim/undo"
vim.opt.clipboard = "unnamedplus" -- Clipboard integration
--Setup for Python Focus
vim.o.tabstop = 4                 -- Number of spaces a tab counts for
vim.o.shiftwidth = 4              -- Number of spaces for each indentation
vim.o.softtabstop = 4             -- Number of spaces a tab counts for while editing
-- vim.o.shiftwidth = 4              -- Number of spaces for each indentation
vim.o.expandtab = true            -- Convert tabs to spaces
vim.o.autoindent = true           -- Auto indent on new lines
vim.o.smartindent = true          -- Smart autoindenting on new lines
vim.o.wrap = false                -- Disable line wrapping
vim.o.cursorline = true           -- Highlight the current line
vim.o.termguicolors = true        -- Enable 24-bit RGB colors
vim.o.number = true               -- Show line numbers
vim.hlsearch = true               -- Highlight search results

-- █▓▒░⡷⠂KEY MAPPINGS⠐⢾░▒▓█
-- close and open to enable changes

-- Diagnostic keybinding
vim.keymap.set('n', '<leader>do', vim.diagnostic.open_float, { desc = 'Open diagnostic float' })

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
-- Autogroups HERE
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
        "linguini1/pulse.nvim",
        version = "*",
        config = function()
            local pulse = require("pulse")
            pulse.setup()
            pulse.add("microbreak", {
                interval = microbreak_interval,
                message = string.format("%d minute microbreak! Stretch hands, arms & look away", microbreak_interval),
                enabled = enable_timers, -- Controlled by the boolean
            })
            pulse.add("restbreak", {
                interval = restbreak_interval,
                message = string.format("%d minute long break! 5-10mins", restbreak_interval),
                enabled = enable_timers, -- Controlled by the boolean
            })
        end,
    },
    { -- diagnostics at the top of the window
        'dgagn/diagflow.nvim',
        config = function()
            require('diagflow').setup({
                enable = true,
                placement = 'top',    -- Top of the window
                text_align = 'right', -- Right-aligned
                -- You can add more options as above
            })
        end
    },

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
            -- Javascript/Typescript (ts_ls is the new name for tsserver)
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
    -- Command cheatsheet <leader>? . Edit chectsheet.txt in nvim config file with custom commands you want to see in cheatsheet
    {
        "sudormrfbin/cheatsheet.nvim",
        dependencies = {
            { "nvim-lua/popup.nvim" },
            { "nvim-lua/plenary.nvim" },
            { "nvim-telescope/telescope.nvim" }, -- optional but recommended
        },
        config = function()
            require("cheatsheet").setup({
                bundled_cheatsheets = false,        -- disables built-in sheets
                bundled_plugin_cheatsheets = false, -- disables plugin sheets
            })
        end,
        cmd = { "Cheatsheet", "CheatsheetEdit" },
        keys = {
            { "<leader>?", "<cmd>Cheatsheet<cr>", desc = "Open Cheatsheet" },
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
    -- Blink CMP
    {
        'saghen/blink.cmp',
        dependencies = { 'rafamadriz/friendly-snippets', 'milanglacier/minuet-ai.nvim' },
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
            keymap = {
                preset = 'default',
                ['<A-y>'] = function(cmp) require('minuet').make_blink_map()(cmp) end,
            },

            appearance = {
                -- 'mono' (default) for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
                -- Adjusts spacing to ensure icons are aligned
                nerd_font_variant = 'mono'
            },

            -- (Default) Only show the documentation popup when manually triggered
            completion = {
                documentation = { auto_show = true },
                trigger = { prefetch_on_insert = false },
            },

            -- Default list of enabled providers defined so that you can extend it
            -- elsewhere in your config, without redefining it, due to `opts_extend`
            sources = {
                default = { 'lsp', 'path', 'snippets', 'buffer', 'minuet' },
                providers = {
                    minuet = {
                        name = 'minuet',
                        module = 'minuet.blink',
                        async = true,
                        timeout_ms = 3000,
                        score_offset = 50,
                    },
                },
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
    },
    {
        "junegunn/fzf",
        build = "./install --bin",
    },
    {
        "junegunn/fzf.vim",
    },
    -- Claude Code integration
    {
        "coder/claudecode.nvim",
        dependencies = { "folke/snacks.nvim" },
        config = true,
        keys = {
            { "<leader>c",  nil,                             desc = "Claude Code" },
            { "<leader>ct", "<cmd>ClaudeCode<cr>",           desc = "Toggle Claude Code" },
            { "<leader>cs", "<cmd>ClaudeCodeSend<cr>",       mode = "v",                 desc = "Send selection to Claude" },
            { "<leader>ca", "<cmd>ClaudeCodeDiffAccept<cr>", desc = "Accept Claude diff" },
            { "<leader>cr", "<cmd>ClaudeCodeDiffDeny<cr>",   desc = "Reject Claude diff" },
        },
    },
    -- vim-slime: send code to tmux pane (IPython REPL workflow)
    {
        "jpalardy/vim-slime",
        ft = { "python", "lua", "sh", "javascript", "typescript" },
        init = function()
            vim.g.slime_target = "tmux"
            vim.g.slime_default_config = {
                socket_name = vim.fn.split(vim.env.TMUX or "default", ",")[1] or "default",
                target_pane = "{top-right}",
            }
            vim.g.slime_dont_ask_default = 1
            vim.g.slime_bracketed_paste = 1
            vim.g.slime_cell_delimiter = "# %%"
        end,
        keys = {
            { "<leader>vs", "<cmd>SlimeConfig<cr>",     desc = "Slime: configure target pane" },
            { "<leader>sc", "<Plug>SlimeSendCell",      desc = "Slime: send cell" },
            { "<leader>sl", "<Plug>SlimeLineSend",      desc = "Slime: send line" },
            { "<leader>sv", "<Plug>SlimeRegionSend",    mode = "v", desc = "Slime: send visual selection" },
            { "<leader>sp", "<Plug>SlimeParagraphSend", desc = "Slime: send paragraph" },
        },
    },
    -- VectorCode for semantic RAG code search
    {
        "Davidyz/VectorCode",
        dependencies = { "nvim-lua/plenary.nvim" },
        config = function()
            require("vectorcode").setup {
                n_query = 1,
            }
        end,
    },
    -- Minuet AI completion with VectorCode integration
    {
        "milanglacier/minuet-ai.nvim",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "Davidyz/VectorCode",
        },
        config = function()
            local has_vc, vectorcode_config = pcall(require, "vectorcode.config")
            local vectorcode_cacher = nil
            if has_vc then
                vectorcode_cacher = vectorcode_config.get_cacher_backend()
            end

            local RAG_Context_Window_Size = 8000

            local provider_options = {
                openai_fim_compatible = {
                    model = "qwen2.5-coder:7b-instruct-q5_K_M",
                    template = {
                        prompt = function(pref, suff, _)
                            local prompt_message = ""
                            if has_vc then
                                for _, file in ipairs(vectorcode_cacher.query_from_cache(0)) do
                                    prompt_message = prompt_message
                                        .. "<|file_sep|>"
                                        .. file.path
                                        .. "\n"
                                        .. file.document
                                end
                            end

                            prompt_message = vim.fn.strcharpart(
                                prompt_message,
                                0,
                                RAG_Context_Window_Size
                            )

                            return prompt_message
                                .. "<|fim_prefix|>"
                                .. pref
                                .. "<|fim_suffix|>"
                                .. suff
                                .. "<|fim_middle|>"
                        end,
                        suffix = false,
                    },
                },
            }

            require("minuet").setup {
                provider = "openai_fim_compatible",
                provider_options = provider_options,
            }
        end,
    },
})
