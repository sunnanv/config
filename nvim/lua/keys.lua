vim.api.nvim_set_keymap('v', '<C-h>', 'y:%s/<C-r>0//gc<left><left><left>', {  noremap = true })

vim.api.nvim_set_keymap('v', '<C-t>', 'y:%S/<C-r>0//gc<left><left><left>', {  noremap = true })

vim.api.nvim_set_keymap('n', '<leader>w', ':w<CR>', { noremap = true, silent = true })
