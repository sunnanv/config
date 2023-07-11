local M = {}

function M.setup()
    local mappings = {
        ['<C-t>'] = ':FloatermToggle<CR>',
    }
    local t_mappings = {
        ['<C-t>'] = '<C-\\><C-n>:FloatermToggle<CR>',
    }


    for keys, mapping in pairs(mappings) do
        vim.api.nvim_set_keymap('n', keys, mapping, { noremap = true, silent = true })
    end

    for keys, mapping in pairs(t_mappings) do
        vim.api.nvim_set_keymap('t', keys, mapping, { noremap = true, silent = true })
    end
end

return M
