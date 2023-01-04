local M = {}

function M.setup()
    require("mason-null-ls").setup({
        automatic_installation = false,
        automatic_setup = true,
    })
    require("null-ls").setup(
    )

    require 'mason-null-ls'.setup_handlers()
end

return M
