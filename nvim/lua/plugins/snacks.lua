return {
    {
        "folke/snacks.nvim",
        priority = 1000,
        lazy = false,
        ---@type snacks.Config
        keys = {
            { "<leader>sh", function() Snacks.notifier.show_history() end,                 desc = "Notification History" },
            { "<leader>cn", function() Snacks.notifier.hide() end },
            { "<leader>cR", function() Snacks.rename.rename_file() end,                    desc = "Rename File" },
            { "]]",         function() Snacks.words.jump(vim.v.count1) end,                desc = "Next Reference",      mode = { "n", "t" } },
            { "[[",         function() Snacks.words.jump(-vim.v.count1) end,               desc = "Prev Reference",      mode = { "n", "t" } },
            { "<leader>n",  function() Snacks.picker.explorer() end,                       desc = "Explorer" },
            { "<leader>N",  function() Snacks.picker.explorer({ auto_close = false }) end, desc = "Explorer" },
            { "ff",         function() Snacks.picker.smart() end,                          desc = "Files" },
            { "fg",         function() Snacks.picker.grep() end,                           desc = "Grep" },
            { "fs",         function() Snacks.picker.git_status() end,                     desc = "Git Status" },
            { "fb",         function() Snacks.picker.git_branches() end,                   desc = "Branches" },
            { "fr",         function() Snacks.picker.resume() end,                         desc = "Resume" },
            { "fh",         function() Snacks.picker.recent() end,                         desc = "Recent" },
            { "gd",         function() Snacks.picker.lsp_definitions() end,                desc = "Lsp Definitions" },
            { "gt",         function() Snacks.picker.lsp_type_definitions() end,           desc = "Lsp Type Definitions" },
            { "gi",         function() Snacks.picker.lsp_implementations() end,            desc = "Lsp Implementations" },
            { "gr",         function() Snacks.picker.lsp_references() end,                 desc = "Lsp References" },
        },

        opts = {
            dashboard = {},
            notifier = {
            },
            picker = {
                sources = {
                    explorer = {
                        hidden = true,
                        ignored = true,
                        auto_close = true,
                    },
                }
            },
            words = { enabled = true },
            statuscolumn = {},
            indent = { enabled = true },
        },
    }
}
