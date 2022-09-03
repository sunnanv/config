
require("telescope").load_extension "file_browser"
require("telescope").load_extension "frecency"

require("telescope").setup({
    extensions = {
        frecency = {
            default_workspace = "CWD",
            show_scores = true,
        },
    },
})
local map = vim.api.nvim_set_keymap
options = { noremap = true }

map('n', 'ff', ':Telescope find_files<CR>', options)
map('n', 'fg', ':Telescope live_grep<CR>', options)
map('n', 'fb', ':Telescope file_browser path=%:p:h<CR>', options)
