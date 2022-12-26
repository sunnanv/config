local M = {}

function M.setup()
    local dap_python = require 'dap-python'
    dap_python.setup('~/.local/venv/nvim/bin/python')

    local dap = require 'dap'
    local dapui = require 'dapui'
    dapui.setup {}

    require 'nvim-dap-virtual-text'.setup {}

    local mappings = {
        ['<leader>db'] = dap.toggle_breakpoint,
        ['<leader>dd'] = dap.continue,
        ['<leader>do'] = dap.step_over,
        ['<leader>di'] = dap.step_into,
        ['<leader>dx'] = dap.step_out,
        ['<leader>dtn'] = dap_python.test_method,
        ['<leader>dtf'] = dap_python.test_class,
    }


    for keys, mapping in pairs(mappings) do
        vim.api.nvim_set_keymap('n', keys, '', { callback = mapping, noremap = true, silent = true })
    end



    dap.listeners.after.event_initialized["dapui_config"] = function()
        dapui.open()
    end
    dap.listeners.before.event_terminated["dapui_config"] = function()
        dapui.close()
    end
    dap.listeners.before.event_exited["dapui_config"] = function()
        dapui.close()
    end
end

return M
