return {
    {
        'mfussenegger/nvim-dap',
        dependencies = {
            'mfussenegger/nvim-dap-python',
            'rcarriga/nvim-dap-ui',
            'mxsdev/nvim-dap-vscode-js',
            { 'theHamsta/nvim-dap-virtual-text', opts = {} },
            { "jay-babu/mason-nvim-dap.nvim",    opts = {} },
        },
        keys = {
            { '<leader>db', function() require('dap').toggle_breakpoint() end },
            { '<leader>dc', function() require('dap').continue() end },
            { '<leader>do', function() require('dap').step_over() end },
            { '<leader>dd', function() require('dap').step_into() end },
            { '<leader>dx', function() require('dap').step_out() end },
        }
    },
    {
        "mfussenegger/nvim-dap-python",
        keys = {
            { '<leader>dtn', function() require('dap-python').test_method() end },
            { '<leader>dtf', function() require('dap-python').test_class() end },
        },
        config = function()
            local dap_python = require('dap-python')
            dap_python.setup('~/.local/venv/nvim/bin/python')
        end,
    },
    {
        'rcarriga/nvim-dap-ui',
        keys = {
            { '<leader>du', function() require('dapui').open() end },
            { '<leader>dq', function() dapui.close() end },
        },
        opts = {}
    },
    {
        "mxsdev/nvim-dap-vscode-js",
        lazy = true,
        opts = {
            adapters = { 'pwa-node', 'pwa-chrome', 'pwa-msedge', 'node-terminal', 'pwa-extensionHost' },
        }
    },


}
