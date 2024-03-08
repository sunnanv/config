return {
    "tpope/vim-commentary",
    "tpope/vim-surround",
    "tpope/vim-abolish",
    "RRethy/vim-illuminate",
    {
        'windwp/nvim-autopairs',
        event = "InsertEnter",
        config = true
    },
    {
        'windwp/nvim-ts-autotag',
        event = "InsertEnter",
        config = true
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
        end
    }
}
