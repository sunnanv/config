vim.api.nvim_set_keymap('v', '<C-t>', 'y:%S/<C-r>0//gc<left><left><left>', { noremap = true })

vim.api.nvim_set_keymap('n', '<leader>w', ':w<CR>', { noremap = true, silent = true })

vim.api.nvim_set_keymap('n', '<leader>p', '"+p', { noremap = true, silent = true })
vim.api.nvim_set_keymap('v', '<leader>p', '"+p', { noremap = true, silent = true })

vim.api.nvim_set_keymap('n', '<leader>y', '"+y', { noremap = true, silent = true })
vim.api.nvim_set_keymap('v', '<leader>y', '"+y', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>Y', 'gg"+yG', { noremap = true, silent = true })

vim.api.nvim_set_keymap('n', '<leader>dl', ':e ~/code/kog/kog/config/settings/dev_local.py<CR>',
    { noremap = true, silent = true })

vim.api.nvim_set_keymap('n', '<A-h>', '<C-w>h', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<A-j>', '<C-w>j', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<A-k>', '<C-w>k', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<A-l>', '<C-w>l', { noremap = true, silent = true })

vim.api.nvim_create_user_command('QfSave', function(opts)
    local qflist = vim.fn.getqflist()
    local lines = {}

    for _, item in ipairs(qflist) do
        local bufname = vim.fn.bufname(item.bufnr)
        local line = string.format('%s:%d:%d: %s', bufname, item.lnum, item.col, item.text)
        table.insert(lines, line)
    end

    vim.fn.writefile(lines, opts.args)
end, { nargs = 1 })

vim.api.nvim_create_user_command('QfLoad', function(opts)
    vim.cmd('cfile ' .. opts.args)
end, { nargs = 1 })

vim.api.nvim_set_keymap('n', '<c-/>', '/<C-r><C-w><CR>', { noremap = true, silent = true })
