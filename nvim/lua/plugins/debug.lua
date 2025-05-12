return {
    {
        'mfussenegger/nvim-dap',
        dependencies = {
            'mfussenegger/nvim-dap-python',
            "jay-babu/mason-nvim-dap.nvim",
            { 'theHamsta/nvim-dap-virtual-text', opts = {} },
            {
                "igorlfs/nvim-dap-view",
                keys = {
                    { '<leader>dw', function() require('dap-view').add_expr() end }
                },
                opts = {
                    winbar = {
                        controls = {
                            enabled = true
                        },
                    },
                    windows = {
                        terminal = {
                            hide = { 'python', 'node-pwa' },
                        }
                    }
                },
                config = function(_, opts)
                    local dap, dv = require("dap"), require("dap-view")
                    dv.setup(opts)
                    dap.listeners.before.attach["dap-view-config"] = function()
                        dv.open()
                    end
                    dap.listeners.before.launch["dap-view-config"] = function()
                        dv.open()
                    end
                    dap.listeners.before.event_terminated["dap-view-config"] = function()
                        dv.close()
                    end
                    dap.listeners.before.event_exited["dap-view-config"] = function()
                        dv.close()
                    end
                end
            },
        },
        keys = {
            { '<leader>db', function() require('dap').toggle_breakpoint() end, desc = 'Toggle breakpoint' },
            { '<leader>dc', function() require('dap').continue() end,          desc = 'DAP continue' },
            { '<leader>dd', function() require('dap').step_over() end,         desc = 'DAP step over' },
            { '<leader>di', function() require('dap').step_into() end,         desc = 'DAP step into' },
            { '<leader>dx', function() require('dap').step_out() end,          desc = 'DAP step out' },
        },
        init = function()
            local function get_pkg_path(pkg, path)
                pcall(require, 'mason')
                local root = vim.env.MASON or (vim.fn.stdpath('data') .. '/mason')
                path = path or ''
                local ret = root .. '/packages/' .. pkg .. '/' .. path
                return ret
            end
            require('dap').adapters['pwa-node'] = {
                type = 'server',
                host = 'localhost',
                port = '${port}',
                executable = {
                    command = 'node',
                    args = {
                        get_pkg_path('js-debug-adapter', '/js-debug/src/dapDebugServer.js'),
                        '${port}',
                    },
                },
            }
        end
    },

    { "jay-babu/mason-nvim-dap.nvim", opts = {}, dependencies = "williamboman/mason.nvim", },
    {
        "mfussenegger/nvim-dap-python",
        config = function()
            local dap_python = require('dap-python')
            dap_python.setup('~/.local/venv/nvim/bin/python')
        end,
    },

}
