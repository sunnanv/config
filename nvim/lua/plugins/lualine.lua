local M = {}

function M.setup()
    require('lualine').setup {
        options = {
            theme = 'tokyonight'
        }
    }
end

return M
