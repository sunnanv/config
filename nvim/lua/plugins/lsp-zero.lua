local M = {}

function M.setup()
    local lsp = require('lsp-zero')
    lsp.preset('recommended')
    lsp.setup()

    local mappings = {
        ['<leader>f'] = ':LspZeroFormat<CR>',
    }

    for keys, mapping in pairs(mappings) do
        vim.api.nvim_set_keymap('n', keys, mapping, { noremap = true, silent = true })
    end

    local callback_mappings = {
        ['<leader>e'] = vim.diagnostic.open_float,
        ['<leader>rn'] = vim.lsp.buf.rename,
    }

    for keys, mapping in pairs(callback_mappings) do
        vim.api.nvim_set_keymap('n', keys, '', { callback = mapping, noremap = true, silent = true })
    end
end

return M
