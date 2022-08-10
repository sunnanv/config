local map = vim.api.nvim_set_keymap

options = { noremap = true }

map('n', 'ff', ':Telescope find_files<CR>', options)
map('n', 'fg', ':Telescope live_grep<CR>', options)
map('n', 'T', ':belowright split | term<CR>', options)
