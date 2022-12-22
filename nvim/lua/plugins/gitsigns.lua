local M = {}

function M.setup()
    local set_keymap = vim.api.nvim_set_keymap
    local gitsigns = require('gitsigns')

    gitsigns.setup()

    local mappings = {
        ['<leader>gb'] = gitsigns.blame_line,
        ['<leader>gg'] = gitsigns.toggle_signs,
        ['<leader>gp'] = gitsigns.preview_hunk,
        ['<leader>gj'] = gitsigns.next_hunk,
        ['<leader>gk'] = gitsigns.prev_hunk,
        ['<leader>gu'] = gitsigns.reset_hunk,
        ['<leader>ga'] = gitsigns.stage_hunk,
    }


    for keys, mapping in pairs(mappings) do
        set_keymap('n', keys, '', { callback = mapping, noremap = true, silent = true })
    end
end

return M
