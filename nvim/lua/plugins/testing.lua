return {
    {
        {
            "nvim-neotest/neotest",
            dependencies = {
                "nvim-lua/plenary.nvim",
                "antoinemadec/FixCursorHold.nvim",
                "nvim-treesitter/nvim-treesitter",
                "nvim-neotest/neotest-python",
                "nvim-neotest/neotest-jest",
                "nvim-neotest/neotest-vim-test",
                "nvim-neotest/nvim-nio"
            },
            config = function()
                local set_keymap = vim.api.nvim_set_keymap
                local neotest = require("neotest")

                neotest.setup({
                    discovery = {
                        concurrent = 4,
                        filter_dir = function(name, rel_path, root)
                            if name == "node_modules" then
                                return false
                            end
                            return true
                        end

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
                    },
                    summary = {
                        follow = true,
                        open = "botright vsplit | vertical resize 75"
                    },
                })

                local mappings = {
                    ['<leader>tn'] = function() neotest.run.run() end,
                    ['<leader>tN'] = function()
                        neotest.run.run()
                        neotest.run.attach()
                    end,
                    ['<leader>tf'] = function() neotest.run.run(vim.fn.expand('%')) end,
                    ['<leader>tF'] = function()
                        neotest.run.run(vim.fn.expand('%'))
                        neotest.run.attach()
                    end,
                    ['<leader>td'] = function() neotest.run.run({ strategy = 'dap' }) end,
                    ['<leader>tl'] = function() neotest.run.run_last() end,
                    ['<leader>ta'] = function() neotest.run.attach() end,
                    ['<leader>tt'] = function() neotest.summary.toggle() end,
                    ['<leader>tm'] = function() neotest.summary.run_marked() end,
                    ['<leader>to'] = function() neotest.output.open({ quiet = true }) end,
                    ['<leader>tO'] = function() neotest.output.open({ quiet = true, enter = true }) end,
                    ['[t'] = function() neotest.jump.prev({ status = 'failed' }) end,
                    [']t'] = function() neotest.jump.next({ status = 'failed' }) end,
                }

                for keys, mapping in pairs(mappings) do
                    set_keymap('n', keys, '', { callback = mapping, noremap = true, silent = true })
                end
            end,
        },

    }
}
