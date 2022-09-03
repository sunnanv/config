vim.g['neoformat_try_node_exe'] = 1
vim.g['neoformat_try_formatprg'] = 1
vim.g['neoformat_run_all_formatters'] = 1
vim.g['neoformat_enabled_python'] = {'black', 'isort'}

vim.g['neoformat_enabled_javascript'] = {'eslint_d'}
vim.g['neoformat_enabled_vue'] = {'eslint'}

vim.api.nvim_create_autocmd("BufLeave,FocusLost", {
    pattern = '*.py,*.js,*.ts,*.vue,*.json',
    command = 'Neoformat'
})

vim.api.nvim_set_keymap('n', '<leader>f', ':Neoformat<CR>', { noremap = true, silent = true })

vim.g['neoformat_vue_eslint'] = {
        exe =  'eslint_d',
        args= { '--stdin', '--stdin-filename', '"%:p"', '--fix-to-stdout' },
        stdin= 1,
        try_node_exe= 1, 
}
