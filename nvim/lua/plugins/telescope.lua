local M = {}

function M.setup()
    local telescope = require'telescope'
    telescope.load_extension 'file_browser'

    telescope.setup {}


    local mappings = {
        ['ff'] = ':Telescope find_files<CR>',
        ['fg'] = ':Telescope live_grep<CR>',
        ['fb'] = ':Telescope file_browser path=%:p:h<CR>',
        ['fs'] = ':Telescope git_status<CR>',
    }

    for keys, mapping in pairs(mappings) do
      vim.api.nvim_set_keymap('n', keys, mapping, { noremap = true, silent = true })
    end
end

return M
