return {
    {
        "tpope/vim-abolish",
        cmd = {
            "Abolish",
            "Subvert",
            "S",
        },
    },
    {
        "numtostr/BufOnly.nvim",
        keys = {
            { "<leader>bb", "<cmd>BufOnly<CR>" },
        },
    },
    {
        "windwp/nvim-ts-autotag",
        event = "InsertEnter",
        opts = {},
    },
    {
        "dinhhuy258/vim-local-history",
        branch = "master",
        lazy = false,
        build = ":UpdateRemotePlugins",
        keys = {
            { "<leader>lh", "<cmd>LocalHistoryToggle<CR>" },
        },
        cmd = "LocalHistoryToggle",
        config = function()
            vim.g.local_history_path = os.getenv("HOME") .. "/.vim/local_history"
            vim.g.local_history_max_changes = 500
            vim.g.local_history_new_change_delay = 60
        end,
    },
    {
        "okuuva/auto-save.nvim",
        event = "VeryLazy",
        config = function()
            require("auto-save").setup({
                debounce_delay = 1000,
                condition = function(buf)
                    local filetype = vim.fn.getbufvar(buf, "&filetype")

                    if vim.list_contains({ "sql", "harpoon" }, filetype) then
                        return false
                    end
                    return true
                end,
            })
        end,
    },
    {
        "folke/which-key.nvim",
        event = "VeryLazy",
        init = function()
            vim.o.timeout = true
            vim.o.timeoutlen = 300
        end,
        opts = {},
    },
    {
        "johmsalas/text-case.nvim",
        config = function()
            require("textcase").setup({})
        end,
        keys = {
            "ga", -- Default invocation prefix
        },
        cmd = {
            "Subs",
            "TextCaseStartReplacingCommand",
        },
    },
    {
        "tpope/vim-repeat",
        event = "VeryLazy",
    },
    {
        "smoka7/hop.nvim",
        version = "*",
        keys = {
            {
                "f",
                function()
                    require("hop").hint_char1({
                        direction = require("hop.hint").HintDirection.AFTER_CURSOR,
                        current_line_only = true,
                    })
                end,
            },
            {
                "F",
                function()
                    require("hop").hint_char1({
                        direction = require("hop.hint").HintDirection.BEFORE_CURSOR,
                        current_line_only = true,
                    })
                end,
            },
            {
                "t",
                function()
                    require("hop").hint_char1({
                        direction = require("hop.hint").HintDirection.AFTER_CURSOR,
                        current_line_only = true,
                        hint_offset = -1,
                    })
                end,
            },
            {
                "T",
                function()
                    require("hop").hint_char1({
                        direction = require("hop.hint").HintDirection.BEFORE_CURSOR,
                        current_line_only = true,
                        hint_offset = 1,
                    })
                end,
            },
            {
                "s",
                function()
                    require("hop").hint_words({ direction = require("hop.hint").HintDirection.AFTER_CURSOR })
                end,
            },
            {
                "S",
                function()
                    require("hop").hint_words({ direction = require("hop.hint").HintDirection.BEFORE_CURSOR })
                end,
            },
        },
        opts = {},
    },
    {
        "gbprod/yanky.nvim",
        event = "VeryLazy",
        config = function()
            require("yanky").setup({
                system_clipboard = {
                    sync_with_ring = false,
                },
            })

            vim.keymap.set({ "n", "x" }, "p", "<Plug>(YankyPutAfter)")
            vim.keymap.set({ "n", "x" }, "P", "<Plug>(YankyPutBefore)")

            vim.keymap.set("n", "<c-p>", "<Plug>(YankyPreviousEntry)")
            vim.keymap.set("n", "<c-n>", "<Plug>(YankyNextEntry)")
        end,
    },
    {
        "folke/zen-mode.nvim",
        keys = {
            { "<leader>zz", "<cmd>ZenMode<CR>" },
        },
        opts = {},
    },
    {
        "saecki/live-rename.nvim",
        keys = {
            { "rn", function() require('live-rename').rename() end },
            { "Rn", function() require('live-rename').rename({ text = "", insert = true }) end },
        },
        opts = {
            keys = {
                submit = {
                    { "n", "<c-space>" },
                    { "v", "<c-space>" },
                    { "i", "<c-space>" },
                }
            }
        },
    },

    -- {
    --     "smjonas/inc-rename.nvim",
    --     config = function()
    --         require("inc_rename").setup()
    --         vim.keymap.set("n", "rn", function()
    --             return ":IncRename " .. vim.fn.expand("<cword>")
    --         end, { expr = true })
    --     end,
    -- },
    {
        "ranelpadon/python-copy-reference.vim"
    },
    {
        'mawkler/demicolon.nvim',
        -- keys = { ';', ',', 't', 'f', 'T', 'F', ']', '[', ']d', '[d' }, -- Uncomment this to lazy load
        dependencies = {
            'nvim-treesitter/nvim-treesitter',
            'nvim-treesitter/nvim-treesitter-textobjects',
        },
        opts = {
            integrations = {
                gitsigns = {
                    keymaps = {
                        next = ']h',
                        prev = '[h',
                    }
                }
            }
        }
    }
}
