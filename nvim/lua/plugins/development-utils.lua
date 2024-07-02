return {
    "tpope/vim-commentary",
    "tpope/vim-surround",
    "tpope/vim-abolish",
    "RRethy/vim-illuminate",
    {
        "numtostr/BufOnly.nvim",
        keys = {
            { "<leader>bb", "<cmd>BufOnly<CR>" }
        }

    },
    {
        'windwp/nvim-autopairs',
        event = "InsertEnter",
        config = true
    },
    {
        'windwp/nvim-ts-autotag',
        event = "InsertEnter",
        config = function()
            require('nvim-ts-autotag').setup()
        end

    },
    {
        "brenoprata10/nvim-highlight-colors",
        opts = {
            enable_tailwind = true
        }
    },
    {
        "lukas-reineke/indent-blankline.nvim",
        main = "ibl",
        opts = {},
    },
    {
        "dinhhuy258/vim-local-history",
        branch = "master",
        build = ":UpdateRemotePlugins",
        config = function()
            vim.g.local_history_path = os.getenv('HOME') .. "/.vim/local_history"
            vim.g.local_history_max_changes = 500
            vim.g.local_history_new_change_delay = 60
            vim.keymap.set("n", "<leader>lh", "<cmd>LocalHistoryToggle<CR>")
        end,
    },
    {
        "tzachar/highlight-undo.nvim",
        opts = {}
    },
    {
        "okuuva/auto-save.nvim",
        config = function()
            require('auto-save').setup({
                debounce_delay = 1000
            })
        end
    },
    {
        'folke/which-key.nvim',
        event = "VeryLazy",
        init = function()
            vim.o.timeout = true
            vim.o.timeoutlen = 300
        end,
        opts = {}
    },
    {
        "folke/todo-comments.nvim",
        dependencies = { "nvim-lua/plenary.nvim" },
        opts = {}
    },
    {
        "johmsalas/text-case.nvim",
        dependencies = { "nvim-telescope/telescope.nvim" },
        config = function()
            require("textcase").setup({})
            require("telescope").load_extension("textcase")
        end,
        keys = {
            "ga", -- Default invocation prefix
            { "ga.", "<cmd>TextCaseOpenTelescope<CR>", mode = { "n", "x" }, desc = "Telescope" },
        },
        cmd = {
            -- NOTE: The Subs command name can be customized via the option "substitude_command_name"
            "Subs",
            "TextCaseOpenTelescope",
            "TextCaseOpenTelescopeQuickChange",
            "TextCaseOpenTelescopeLSPChange",
            "TextCaseStartReplacingCommand",
        },

        -- If you want to use the interactive feature of the `Subs` command right away, text-case.nvim
        -- has to be loaded on startup. Otherwise, the interactive feature of the `Subs` will only be
        -- available after the first executing of it or after a keymap of text-case.nvim has been used.
        lazy = false,
    },
    {
        "tpope/vim-repeat",
    },
    {
        'wthollingsworth/pomodoro.nvim',
        requires = 'MunifTanjim/nui.nvim',
        config = function()
            require('pomodoro').setup({
                time_work = 25,
                time_break_short = 5,
                time_break_long = 20,
                timers_to_long_break = 4
            })
        end
    },
    -- {
    --     "ggandor/leap.nvim",
    --     lazy = false,
    --     config = function()
    --         require("leap").create_default_mappings()
    --     end,
    -- },
    {
        'smoka7/hop.nvim',
        version = "*",
        config = function()
            local hop = require('hop')
            hop.setup()
            local directions = require('hop.hint').HintDirection
            vim.keymap.set('', 'f', function()
                hop.hint_char1({ direction = directions.AFTER_CURSOR, current_line_only = true })
            end, { remap = true })
            vim.keymap.set('', 'F', function()
                hop.hint_char1({ direction = directions.BEFORE_CURSOR, current_line_only = true })
            end, { remap = true })
            vim.keymap.set('', 't', function()
                hop.hint_char1({ direction = directions.AFTER_CURSOR, current_line_only = true, hint_offset = -1 })
            end, { remap = true })
            vim.keymap.set('', 'T', function()
                hop.hint_char1({ direction = directions.BEFORE_CURSOR, current_line_only = true, hint_offset = 1 })
            end, { remap = true })
            vim.keymap.set('', 's', function()
                hop.hint_words({ direction = directions.AFTER_CURSOR })
            end, { remap = true })
            vim.keymap.set('', 'S', function()
                hop.hint_words({ direction = directions.BEFORE_CURSOR })
            end, { remap = true })
        end
    },
    {
        "gbprod/yanky.nvim",
        config = function()
            require("yanky").setup({
                system_clipboard = {
                    sync_with_ring = false
                }
            })

            vim.keymap.set({ "n", "x" }, "p", "<Plug>(YankyPutAfter)")
            vim.keymap.set({ "n", "x" }, "P", "<Plug>(YankyPutBefore)")
            vim.keymap.set({ "n", "x" }, "gp", "<Plug>(YankyGPutAfter)")
            vim.keymap.set({ "n", "x" }, "gP", "<Plug>(YankyGPutBefore)")

            vim.keymap.set("n", "<c-p>", "<Plug>(YankyPreviousEntry)")
            vim.keymap.set("n", "<c-n>", "<Plug>(YankyNextEntry)")
        end,
    },
    {
        "folke/zen-mode.nvim",
        keys = {
            { "<leader>zz", "<cmd>ZenMode<CR>" }
        },
        opts = {
            -- your configuration comes here
            -- or leave it empty to use the default settings
            -- refer to the configuration section below
        }
    }
}
