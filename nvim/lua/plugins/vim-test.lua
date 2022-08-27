
vim.api.nvim_set_keymap('n', '<leader>tn', '<cmd>TestNearest<CR>', { noremap = true, silent = true}) -- Test file
vim.api.nvim_set_keymap('n', '<leader>tf', '<cmd>TestFile<CR>', { noremap = true, silent = true}) -- Test file
vim.api.nvim_set_keymap('n', '<leader>ts', '<cmd>TestSuite<CR>', { noremap = true, silent = true}) -- Test suite
vim.api.nvim_set_keymap('n', '<leader>tl', '<cmd>TestLast<CR>', { noremap = true, silent = true}) -- Test last test run
vim.api.nvim_set_keymap('n', '<leader>tv', '<cmd>TestVisit<CR>', { noremap = true, silent = true}) -- Test visit

vim.g['test#python#djangotest#options'] = '--keepdb'

vim.g['ultest_max_threads'] = 1
vim.g['ultest_icons'] = 0
vim.g['ultest_deprecation_notice'] = 0
