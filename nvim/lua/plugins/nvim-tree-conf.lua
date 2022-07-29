require("nvim-tree").setup{}

local map = vim.api.nvim_set_keymap

options = { noremap = true }
map('n', '<leader>n', ':NvimTreeFocus<CR>', {noremap=True})
