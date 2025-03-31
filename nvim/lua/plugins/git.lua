return {
    {
        "tpope/vim-fugitive",
        cmd = {
            'Git',
            "GBrowse"
        },
        dependencies = 'tpope/vim-rhubarb'
    },
    {
        'akinsho/git-conflict.nvim',
        keys = {
            ']x', '[x'
        },
        cmd = {
            'GitConflictChooseOurs',
            'GitConflictChooseTheirs',
            'GitConflictChooseBoth',
            'GitConflictChooseNone',
            'GitConflictListQf',
        },
        version = "*",
        opts = {}
    },
    {
        "lewis6991/gitsigns.nvim",
        dependencies = "nvim-lua/plenary.nvim",
        event = "VeryLazy",
        opts = {
            on_attach = function(bufnr)
                local gs = package.loaded.gitsigns
                local wk = require("which-key")


                local function map(mode, mapping, func, desc, opts)
                    opts = {}
                    opts.buffer = bufnr
                    wk.add(
                        {
                            mapping,
                            func,
                            mode = mode,
                            opts = opts,
                            desc = desc
                        }
                    )
                end

                map('n', ']g', function()
                    if vim.wo.diff then return ']g' end
                    vim.schedule(function() gs.next_hunk() end)
                    return '<Ignore>'
                end, 'Next hunk', { expr = true })

                map('n', '[g', function()
                    if vim.wo.diff then return '[g' end
                    vim.schedule(function() gs.prev_hunk() end)
                    return '<Ignore>'
                end, 'Previous hunk', { expr = true })

                -- Actions
                map('n', '<leader>gs', gs.stage_hunk, 'Stage hunk')
                map('n', '<leader>gr', gs.reset_hunk, 'Reset hunk')
                map('v', '<leader>gs', function() gs.stage_hunk { vim.fn.line('.'), vim.fn.line('v') } end,
                    'Stage hunk in visual mode')
                map('v', '<leader>gr', function() gs.reset_hunk { vim.fn.line('.'), vim.fn.line('v') } end,
                    'Reset hunk in visual mode')
                map('n', '<leader>gS', gs.stage_buffer, 'Stage buffer')
                map('n', '<leader>gu', gs.undo_stage_hunk, 'Undo stage hunk')
                map('n', '<leader>gU', gs.reset_buffer_index, 'Reset buffer index')
                map('n', '<leader>gR', gs.reset_buffer, 'Reset buffer')
                map('n', '<leader>gp', gs.preview_hunk, 'Preview hunk')
                map('n', '<leader>gb', function() gs.blame_line { full = true } end, 'Blame line')
                map('n', '<leader>tb', gs.toggle_current_line_blame, 'Toggle current line blame')
                map('n', '<leader>gd', gs.diffthis, 'Diff this')
                map('n', '<leader>gD', function() gs.diffthis('~') end, 'Diff file')
                map('n', '<leader>gtd', gs.toggle_deleted, 'Toggle deleted')

                -- Text object
                map({ 'o', 'x' }, 'ig', ':<C-U>Gitsigns select_hunk<CR>', 'Select hunk')
            end
        }
    },
    {
        "kdheepak/lazygit.nvim",
        cmd = {
            "LazyGit",
            "LazyGitConfig",
            "LazyGitCurrentFile",
            "LazyGitFilter",
            "LazyGitFilterCurrentFile",
        },
        -- optional for floating window border decoration
        dependencies = {
            "nvim-lua/plenary.nvim",
        },
        -- setting the keybinding for LazyGit with 'keys' is recommended in
        -- order to load the plugin when the command is run for the first time
        keys = {
            { "<leader>lg", "<cmd>LazyGit<cr>", desc = "LazyGit" }
        }
    },


}
