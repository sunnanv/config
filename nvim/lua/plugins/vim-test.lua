local M = {}

function M.setup()
    vim.g['test#strategy'] = 'floaterm'
    vim.g['test#python#djangotest#options'] = '--keepdb'

    local mappings = {
        ['<leader>tn'] = '<cmd>TestNearest<CR>',
        ['<leader>tf'] = '<cmd>TestFile<CR>',
        ['<leader>ts'] = '<cmd>TestSuite<CR>',
        ['<leader>tl'] = '<cmd>TestLast<CR>',
        ['<leader>tv'] = '<cmd>TestVisit<CR>',
    }


    for keys, mapping in pairs(mappings) do
        vim.api.nvim_set_keymap('n', keys, mapping, { noremap = true, silent = true })
    end
end

return M
