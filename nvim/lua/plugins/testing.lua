return {
    {
        -- {
        --     "vim-test/vim-test",
        --     config = function()
        --         vim.g['test#strategy'] = 'floaterm'
        --         vim.g['test#python#djangotest#options'] = '--keepdb'
        --
        --         local mappings = {
        --             ['<leader>tn'] = '<cmd>TestNearest<CR>',
        --             ['<leader>tf'] = '<cmd>TestFile<CR>',
        --             ['<leader>ts'] = '<cmd>TestSuite<CR>',
        --             ['<leader>tl'] = '<cmd>TestLast<CR>',
        --             ['<leader>tv'] = '<cmd>TestVisit<CR>',
        --         }
        --
        --
        --         for keys, mapping in pairs(mappings) do
        --             vim.api.nvim_set_keymap('n', keys, mapping, { noremap = true, silent = true })
        --         end
        --     end
        -- },
        {
            "nvim-neotest/neotest",
            dependencies = {
                "nvim-neotest/nvim-nio",
                "nvim-lua/plenary.nvim",
                "nvim-treesitter/nvim-treesitter",
                "nvim-neotest/neotest-python",
                "nvim-neotest/neotest-jest",
                "nvim-neotest/neotest-vim-test",
                "marilari88/neotest-vitest",
            },
            lazy = true,
            keys = {
                { '<leader>tn', function() require('neotest').run.run() end },
                { '<leader>tf', function() require('neotest').run.run(vim.fn.expand('%')) end, },
                { '<leader>td', function() require('neotest').run.run({ strategy = 'dap' }) end },
                { '<leader>tl', function() require('neotest').run.run_last() end },
                { '<leader>ta', function() require('neotest').run.attach() end },
                { '<leader>tt', function() require('neotest').summary.toggle() end },
                { '<leader>tm', function() require('neotest').summary.run_marked() end },
                { '<leader>to', function() require('neotest').output.open({ quiet = true }) end },
                { '<leader>tO', function() require('neotest').output.open({ quiet = true, enter = true }) end },
                { '[t',         function() require('neotest').jump.prev({ status = 'failed' }) end },
                { ']t',         function() require('neotest').jump.next({ status = 'failed' }) end },
            },
            config = function()
                local neotest = require("neotest")

                neotest.setup({
                    discovery = {
                        enabled = false,
                    },
                    adapters = {
                        require("neotest-python")({
                            dap = { justMyCode = false },
                            args = { "--keepdb" },
                        }),
                        require("neotest-jest")({
                            filter_dir = function(name, rel_path, root)
                                return name ~= "node_modules"
                            end,
                        }),
                        require("neotest-vim-test")({
                            ignore_file_types = { "python" },
                        }),
                        require('neotest-vitest')({
                            filter_dir = function(name, rel_path, root)
                                return name ~= "node_modules"
                            end,
                        })
                    },
                    summary = {
                        follow = true,
                        open = "botright vsplit | vertical resize 75"
                    },
                })
            end,
        },


    }
}
