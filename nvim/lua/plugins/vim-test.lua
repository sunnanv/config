
vim.api.nvim_set_keymap('n', '<leader>tf', '<cmd>TestFile<CR>', { noremap = true, silent = true}) -- Test file
vim.api.nvim_set_keymap('n', '<leader>ts', '<cmd>TestSuite<CR>', { noremap = true, silent = true}) -- Test suite
vim.api.nvim_set_keymap('n', '<leader>tl', '<cmd>TestLast<CR>', { noremap = true, silent = true}) -- Test last test run
vim.api.nvim_set_keymap('n', '<leader>tv', '<cmd>TestVisit<CR>', { noremap = true, silent = true}) -- Test visit

vim.g['test#python#djangotest#options'] = {all = '--keepdb'}
vim.g['test#strategy'] = 'neovim'
