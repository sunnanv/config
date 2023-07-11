local M = {}

function M.setup()
    require('tokyonight').setup({
        style = 'night',
    })
    vim.cmd [[colorscheme tokyonight]]
end

return M
