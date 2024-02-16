local M = {}

function M.setup()
    vim.keymap.set('i', '<C-space>', 'copilot#Accept("\\<CR>")', {
        expr = true,
        replace_keycodes = false
    })
    vim.g.copilot_no_tab_map = true

    vim.keymap.set('i', '<C-k>', '<Plug>(copilot-next)')
    vim.keymap.set('i', '<C-j>', '<Plug>(copilot-previous)')
    -- require("copilot").setup({
    --     panel = {
    --         enabled = true,
    --     },
    --     suggestion = {
    --         enabled = true,
    --         auto_trigger = true,
    --         keymap = {
    --             accept = "<C-space>",
    --             next = "<C-k>",
    --             prev = "<C-j>",
    --         },
    --     }
    -- })
end

return M
