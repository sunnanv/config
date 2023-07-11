local M = {}

function M.setup()
    local onenord = require('onenord')
    onenord.setup {
        theme = 'dark'
    }
    onenord.load()
end

return M
