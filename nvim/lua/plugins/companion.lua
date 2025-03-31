return {
    {
        "olimorris/codecompanion.nvim",
        config = true,
        dependencies = {
            "nvim-lua/plenary.nvim",
            "nvim-treesitter/nvim-treesitter",
        },
        opts = {
            strategies = {
                chat = {
                    adapter = 'copilot'
                },
                inline = {
                    adapter = 'copilot'
                },
                cmd = {
                    adapter = 'copilot'
                },
            },
            display = {
                diff = {
                    provider = 'mini_diff'
                },
            }
        }
    },
}
