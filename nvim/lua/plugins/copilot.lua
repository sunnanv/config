local M = {}

function M.setup()
    require("copilot").setup({
        panel = {
            enabled = true,
        },
        suggestion = {
            enabled = true,
            auto_trigger = true,
            keymap = {
                accept = "<C-space>",
                next = "<C-k>",
                prev = "<C-j>",
            },
        }
    })
end

return M
