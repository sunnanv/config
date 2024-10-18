vim.api.nvim_set_keymap('v', '<C-h>', 'y:%s/<C-r>0//gc<left><left><left>', { noremap = true })

vim.api.nvim_set_keymap('v', '<C-t>', 'y:%S/<C-r>0//gc<left><left><left>', { noremap = true })

vim.api.nvim_set_keymap('n', '<leader>w', ':w<CR>', { noremap = true, silent = true })

vim.api.nvim_set_keymap('n', '<leader>p', '"+p', { noremap = true, silent = true })
vim.api.nvim_set_keymap('v', '<leader>p', '"+p', { noremap = true, silent = true })

vim.api.nvim_set_keymap('n', '<leader>y', '"+y', { noremap = true, silent = true })
vim.api.nvim_set_keymap('v', '<leader>y', '"+y', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>Y', 'gg"+yG', { noremap = true, silent = true })

vim.api.nvim_set_keymap('n', '<leader>gdl', ':e ~/code/kog/kog/config/settings/dev_local.py<CR>',
    { noremap = true, silent = true })
