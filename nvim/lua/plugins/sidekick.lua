return {
    {
        "folke/sidekick.nvim",
        event = "VeryLazy",
        opts = {
            mux = {
                backend = "tmux",
                enabled = true,
            },
        },
        keys = {
            {
                "<c-space>",
                function()
                    -- if there is a next edit, jump to it, otherwise apply it if any
                    if not require("sidekick").nes_jump_or_apply() then
                        return "<c-space>" -- fallback to normal tab
                    end
                end,
                expr = true,
                desc = "Goto/Apply Next Edit Suggestion",
            },
            {
                "<c-.>",
                function()
                    require("sidekick.cli").focus()
                end,
                mode = { "n", "x", "i", "t" },
                desc = "Sidekick Switch Focus",
            },
            {
                "<leader>aa",
                function()
                    require("sidekick.cli").toggle({ focus = true })
                end,
                desc = "Sidekick Toggle CLI",
                mode = { "n", "v" },
            },
            {
                "<leader>ap",
                function()
                    require("sidekick.cli").select_prompt()
                end,
                desc = "Sidekick Ask Prompt",
                mode = { "n", "v" },
            },
            {
                "<leader>as",
                function()
                    require("sidekick.cli").save_state()
                end,
                desc = "Sidekick Save State",
                mode = { "n", "v" },
            },
        },
    }
}
