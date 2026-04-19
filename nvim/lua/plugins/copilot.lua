return {
    {
        "zbirenbaum/copilot.lua",
        requires = {
            "copilotlsp-nvim/copilot-lsp", -- (optional) for NES functionality
        },
        opts = {
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
        }
    },
}
