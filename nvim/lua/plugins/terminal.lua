return {
    {
        "voldikss/vim-floaterm",
        config = function()
            local mappings = {
                ['<C-t>'] = ':FloatermToggle<CR>',
            }
            local t_mappings = {
                ['<C-t>'] = '<C-\\><C-n>:FloatermToggle<CR>',
                ['<C-]>'] = '<C-\\><C-n>:FloatermNext<CR>',
                ['<C-[>'] = '<C-\\><C-n>:FloatermPrev<CR>',
                ['<C-n>'] = '<C-\\><C-n>:FloatermNew<CR>',
                ['<C-x>'] = '<C-\\><C-n>:FloatermKill<CR>:FloatermShow<CR>',
                ['<Esc>'] = '<Esc>',
            }


            for keys, mapping in pairs(mappings) do
                vim.api.nvim_set_keymap('n', keys, mapping, { noremap = true, silent = true })
            end

            for keys, mapping in pairs(t_mappings) do
                vim.api.nvim_set_keymap('t', keys, mapping, { noremap = true, silent = true })
            end
        end,
    }
}
