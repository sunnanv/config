require("nvim-tree").setup{
    git = {
        ignore = false
    },
    view = {
        adaptive_size = true,
        mappings = {
            list = {
                { key = 'fi', action = 'live_filter'}
            }
        }
    },
    actions = {
        open_file = {
            quit_on_open = true,
        }
    },
    renderer = {
        icons = {
            glyphs = {
                git = {
                   untracked = "", 
                }
            }
        }
    }
}

local map = vim.api.nvim_set_keymap

options = { noremap = true }
map('n', '<leader>n', ':NvimTreeFocus<CR>', {noremap=True})
map('n', '<leader>N', ':NvimTreeFindFile<CR>', {noremap=True})
