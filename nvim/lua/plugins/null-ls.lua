local M = {}

function M.setup()
    require("mason-null-ls").setup({
        automatic_installation = false,
        automatic_setup = true,
        handlers = {}
    })
    require("null-ls").setup(
    )
end

return M
