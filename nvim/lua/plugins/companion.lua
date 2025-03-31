return {
    {
        "olimorris/codecompanion.nvim",
        config = true,
        dependencies = {
            "j-hui/fidget.nvim",
            "nvim-lua/plenary.nvim",
            "nvim-treesitter/nvim-treesitter",
        },
        keys = {
            { '<C-a>',     '<cmd>CodeCompanionActions<cr>',     mode = { 'n', 'v' } },
            { "<leader>a", "<cmd>CodeCompanionChat Toggle<cr>", mode = { "n", "v" } },
            { "ga",        "<cmd>CodeCompanionChat Add<cr>",    mode = 'v' }
        },
        opts = {
            strategies = {
                chat = {
                    adapter = 'copilot',
                    tools = {
                        vectorcode = {
                            description = "Run VectorCode to retrieve the project context.",
                            callback = function()
                                return require("vectorcode.integrations").codecompanion.chat.make_tool()
                            end,
                        },
                    }
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
            },

        },
        init = function()
            require("plugins.codecompanion.spinner"):init()
        end
    },
    {
        "Davidyz/VectorCode",
        version = "*", -- optional, depending on whether you're on nightly or release
        dependencies = { "nvim-lua/plenary.nvim" },
    }
}
