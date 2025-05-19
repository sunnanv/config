return {
    {
        "yetone/avante.nvim",
        event = "VeryLazy",
        version = false, -- Never set this value to "*"! Never!
        opts = {
            -- add any opts here
            -- for example
            provider = "copilot",
            vendors = {
                ["copilot-4o"] = {
                    __inherited_from = "copilot",
                    model = 'gpt-4o'
                },
                ["copilot-claude-3.7-sonnet"] = {
                    __inherited_from = "copilot",
                    model = 'claude-3.7-sonnet'
                },
                ["copilot-claude-3.7-sonnet-thought"] = {
                    __inherited_from = "copilot",
                    model = 'claude-3.7-sonnet-thought'
                }
            },
            selector = {
                provider = "snacks"
            },
            file_selector = {
                provider = "snacks"
            },
            web_search_engine = {
                provider = "google",
            }

        },
        -- if you want to build from source then do `make BUILD_FROM_SOURCE=true`
        build = "make",
        -- build = "powershell -ExecutionPolicy Bypass -File Build.ps1 -BuildFromSource false" -- for windows
        dependencies = {
            "nvim-treesitter/nvim-treesitter",
            "stevearc/dressing.nvim",
            "nvim-lua/plenary.nvim",
            "MunifTanjim/nui.nvim",
            --- The below dependencies are optional,
            "nvim-tree/nvim-web-devicons",
            "zbirenbaum/copilot.lua", -- for providers='copilot'
            {
                -- Make sure to set this up properly if you have lazy=true
                'MeanderingProgrammer/render-markdown.nvim',
                opts = {
                    file_types = { "markdown", "Avante" },
                },
                ft = { "markdown", "Avante" },
            },
        },
    }
}
