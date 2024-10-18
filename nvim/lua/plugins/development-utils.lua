return {
    {
        "tpope/vim-abolish",
        cmd = {
            "Abolish",
            "Subvert",
            "S"
        },
    },
    {
        "numtostr/BufOnly.nvim",
        keys = {
            { "<leader>bb", "<cmd>BufOnly<CR>" }
        }

    },
    {
        'windwp/nvim-ts-autotag',
        event = "InsertEnter",
        opts = {}
    },
    {
        "dinhhuy258/vim-local-history",
        branch = "master",
        build = ":UpdateRemotePlugins",
        keys = {
            { "<leader>lh", "<cmd>LocalHistoryToggle<CR>" }
        },
        cmd = "LocalHistoryToggle",
        config = function()
            vim.g.local_history_path = os.getenv('HOME') .. "/.vim/local_history"
            vim.g.local_history_max_changes = 500
            vim.g.local_history_new_change_delay = 60
        end,
    },
    {
        "okuuva/auto-save.nvim",
        event = "VeryLazy",
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
            "Subs",
            "TextCaseOpenTelescope",
            "TextCaseOpenTelescopeQuickChange",
            "TextCaseOpenTelescopeLSPChange",
            "TextCaseStartReplacingCommand",
        },
    },
    {
        "tpope/vim-repeat",
        event = "VeryLazy"
    },
    {
        'smoka7/hop.nvim',
        version = "*",
        keys = { "f", "F", "t", "T", "<leader>s", "<leader>S" },
        keys = {
            { 'f', function()
                require('hop').hint_char1({ direction = require('hop.hint').HintDirection.AFTER_CURSOR, current_line_only = true })
            end },
            { 'F', function()
                require('hop').hint_char1({ direction = require('hop.hint').HintDirection.BEFORE_CURSOR, current_line_only = true })
            end },
            { 't', function()
                require('hop').hint_char1({ direction = require('hop.hint').HintDirection.AFTER_CURSOR, current_line_only = true, hint_offset = -1 })
            end },
            { 'T', function()
                require('hop').hint_char1({ direction = require('hop.hint').HintDirection.BEFORE_CURSOR, current_line_only = true, hint_offset = 1 })
            end },
            { '<leader>s', function()
                require('hop').hint_words({ direction = require('hop.hint').HintDirection.AFTER_CURSOR })
            end },
            { '<leader>S', function()
                require('hop').hint_words({ direction = require('hop.hint').HintDirection.BEFORE_CURSOR })
            end },
        },
        opts = {}
    },
    {
        "gbprod/yanky.nvim",
        event = "VeryLazy",
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
        opts = {},
    },
    {
        "smjonas/inc-rename.nvim",
        keys = { "rn" },
        config = function()
            require("inc_rename").setup()
            vim.keymap.set("n", "rn", function()
                return ":IncRename " .. vim.fn.expand("<cword>")
            end, { noremap = true, silent = true, expr = true })
        end,
    },
}
