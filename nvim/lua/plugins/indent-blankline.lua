local M = {}

function M.setup()
    require 'indent_blankline'.setup {
        show_current_context = true,
    }
end

return M
