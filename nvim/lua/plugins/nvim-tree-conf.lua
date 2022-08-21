require("nvim-tree").setup{
    git = {
        ignore = false
    },
    view = {
        adaptive_size = true,
    },
    actions = {
        open_file = {
            quit_on_open = true,
        }
    }
}

local map = vim.api.nvim_set_keymap

options = { noremap = true }
map('n', '<leader>n', ':NvimTreeFocus<CR>', {noremap=True})
map('n', '<leader>N', ':NvimTreeFindFile<CR>', {noremap=True})
