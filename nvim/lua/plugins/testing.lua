return {
    {
        {
            "nvim-neotest/neotest",
            commit = "52fca6717ef972113ddd6ca223e30ad0abb2800c",
            dependencies = {
                "nvim-neotest/nvim-nio",
                "nvim-lua/plenary.nvim",
                "antoinemadec/FixCursorHold.nvim",
                "nvim-treesitter/nvim-treesitter",
                "nvim-neotest/neotest-python",
                "nvim-neotest/neotest-jest",
                "nvim-neotest/neotest-vim-test",
                "marilari88/neotest-vitest",
            },
            event = 'VeryLazy',
            keys = {
                { '<leader>tn', function() require('neotest').run.run() end },
                { '<leader>tf', function() require('neotest').run.run(vim.fn.expand('%')) end, },
                { '<leader>td', function() require('neotest').run.run({ strategy = 'dap' }) end },
                { '<leader>tl', function() require('neotest').run.run_last() end },
                { '<leader>ta', function() require('neotest').run.attach() end },
                { '<leader>tt', function() require('neotest').summary.toggle() end },
                { '<leader>tm', function() require('neotest').summary.run_marked() end },
                { '<leader>to', function() require('neotest').output.open({ quiet = true, enter = true }) end },
                { '<leader>tO', function() require('neotest').output.open({ quiet = true }) end },
                { '<leader>tp', function() require('neotest').output_panel.toggle() end },
                { '[t',         function() require('neotest').jump.prev({ status = 'failed' }) end },
                { ']t',         function() require('neotest').jump.next({ status = 'failed' }) end },
            },
            config = function()
                local neotest = require("neotest")

                neotest.setup({
                    discovery = {
                        enabled = true,
                    },
                    adapters = {
                        require("neotest-python")({
                            dap = { justMyCode = false },
                            args = { "--keepdb" },
                        }),
                        require("neotest-jest")({
                        }),
                        require("neotest-vim-test")({
                            ignore_file_types = { "python" },
                        }),
                        require('neotest-vitest')({
                        })
                    },
                    summary = {
                        follow = true,
                        open = "botright vsplit | vertical resize 75"
                    },
                    floating = {
                        max_width = 0.9,
                        max_height = 0.9,
                    },
                    quickfix = {
                        enabled = false,
                        open = false
                    },
                    output_panel = {
                        enabled = true,
                        open = "botright vsplit | vertical resize 75"
                    },

                })
            end,
        },


    }
}
