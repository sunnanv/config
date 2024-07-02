return {
    {
        "sindrets/diffview.nvim",
        cmd = "DiffviewOpen",
    },
    "tpope/vim-fugitive",
    "rhysd/conflict-marker.vim",
    {
        "lewis6991/gitsigns.nvim",
        dependencies = "nvim-lua/plenary.nvim",
        config = function()
            require('gitsigns').setup {
                on_attach = function(bufnr)
                    local gs = package.loaded.gitsigns

                    local function map(mode, l, r, opts)
                        opts = opts or {}
                        opts.buffer = bufnr
                        vim.keymap.set(mode, l, r, opts)
                    end

                    map('n', ']h', function()
                        if vim.wo.diff then return ']h' end
                        vim.schedule(function() gs.next_hunk() end)
                        return '<Ignore>'
                    end, { expr = true })

                    map('n', '[h', function()
                        if vim.wo.diff then return '[h' end
                        vim.schedule(function() gs.prev_hunk() end)
                        return '<Ignore>'
                    end, { expr = true })

                    -- Actions
                    map('n', '<leader>hs', gs.stage_hunk)
                    map('n', '<leader>hr', gs.reset_hunk)
                    map('v', '<leader>hs', function() gs.stage_hunk { vim.fn.line('.'), vim.fn.line('v') } end)
                    map('v', '<leader>hr', function() gs.reset_hunk { vim.fn.line('.'), vim.fn.line('v') } end)
                    map('n', '<leader>hS', gs.stage_buffer)
                    map('n', '<leader>hu', gs.undo_stage_hunk)
                    map('n', '<leader>hU', gs.reset_buffer_index)
                    map('n', '<leader>hR', gs.reset_buffer)
                    map('n', '<leader>hp', gs.preview_hunk)
                    map('n', '<leader>hb', function() gs.blame_line { full = true } end)
                    map('n', '<leader>tb', gs.toggle_current_line_blame)
                    map('n', '<leader>hd', gs.diffthis)
                    map('n', '<leader>hD', function() gs.diffthis('~') end)
                    map('n', '<leader>td', gs.toggle_deleted)

                    -- Text object
                    map({ 'o', 'x' }, 'ih', ':<C-U>Gitsigns select_hunk<CR>')
                end
            }
            -- local set_keymap = vim.api.nvim_set_keymap
            -- local gitsigns = require('gitsigns')

            -- gitsigns.setup()

            -- local mappings = {
            --     ['<leader>gb'] = gitsigns.blame_line,
            --     ['<leader>gg'] = gitsigns.toggle_signs,
            --     ['<leader>gp'] = gitsigns.preview_hunk,
            --     ['<leader>gj'] = gitsigns.next_hunk,
            --     ['<leader>gk'] = gitsigns.prev_hunk,
            --     [']g'] = gitsigns.next_hunk,
            --     ['[g'] = gitsigns.prev_hunk,
            --     ['<leader>gu'] = gitsigns.reset_hunk,
            --     ['<leader>ga'] = gitsigns.stage_hunk,
            -- }


            -- for keys, mapping in pairs(mappings) do
            --     set_keymap('n', keys, '', { callback = mapping, noremap = true, silent = true })
            -- end
        end,
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
    }
}
