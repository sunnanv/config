local M = {}

function M.setup()
    local telescope = require 'telescope'

    telescope.setup {
        defaults = {
            path_display = { shorten = { len = 3, exclude = { 2, -1 } } },
        }
    }

    telescope.load_extension('fzf')
    telescope.load_extension('live_grep_args')


    local mappings = {
        ['ff'] = ':Telescope find_files<CR>',
        ['fg'] = ':Telescope live_grep_args<CR>',
        ['fs'] = ':Telescope git_status<CR>',
        ['fb'] = ':Telescope git_branches<CR>',
        ['gt'] = ':Telescope lsp_type_definitions<CR>',
        ['fr'] = ':Telescope resume<CR>',
    }
    local telescope_builtin = require 'telescope.builtin'
    local mappings2 = {
        ['gr'] = function()
            telescope_builtin.lsp_references({ show_line = false })
        end
    }

    for keys, mapping in pairs(mappings) do
        vim.api.nvim_set_keymap('n', keys, mapping, { noremap = true, silent = true })
    end
    for keys, mapping in pairs(mappings2) do
        vim.api.nvim_set_keymap('n', keys, '', { callback = mapping, noremap = true, silent = true })
    end
end

return M
