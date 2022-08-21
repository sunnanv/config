vim.g['neoformat_try_node_exe'] = 1
vim.g['neoformat_try_formatprg'] = 1
vim.g['neoformat_enabled_python'] = {'black'}

vim.g['neoformat_enabled_javascript'] = {'prettier'}

-- vim.api.nvim_create_autocmd("InsertLeave", {
--     pattern = '*',
--     command = 'Neoformat'
-- })

vim.api.nvim_set_keymap('n', '<leader>f', ':Neoformat<CR>', { noremap = true, silent = true })
