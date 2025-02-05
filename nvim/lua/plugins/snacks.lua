return {
    {
        "folke/snacks.nvim",
        priority = 1000,
        lazy = false,
        keys = {
            { "<leader>sh", function() Snacks.notifier.show_history() end,       desc = "Notification History" },
            { "<leader>cn", function() Snacks.notifier.hide() end },
            { "<leader>cR", function() Snacks.rename.rename_file() end,          desc = "Rename File" },
            { "]]",         function() Snacks.words.jump(vim.v.count1) end,      desc = "Next Reference",      mode = { "n", "t" } },
            { "[[",         function() Snacks.words.jump(-vim.v.count1) end,     desc = "Prev Reference",      mode = { "n", "t" } },
            { "<leader>n",  function() Snacks.picker.explorer() end,             desc = "Explorer" },
            { "ff",         function() Snacks.picker.smart() end,                desc = "Files" },
            { "fg",         function() Snacks.picker.grep() end,                 desc = "Grep" },
            { "fs",         function() Snacks.picker.git_status() end,           desc = "Git Status" },
            { "fb",         function() Snacks.picker.git_branches() end,         desc = "Branches" },
            { "fr",         function() Snacks.picker.resume() end,               desc = "Resume" },
            { "fh",         function() Snacks.picker.recent() end,               desc = "Recent" },
            { "gd",         function() Snacks.picker.lsp_definitions() end,      desc = "Lsp Definitions" },
            { "gt",         function() Snacks.picker.lsp_type_definitions() end, desc = "Lsp Type Definitions" },
            { "gi",         function() Snacks.picker.lsp_implementations() end,  desc = "Lsp Implementations" },
            { "gr",         function() Snacks.picker.lsp_references() end,       desc = "Lsp References" },
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
        },
        init = function()
            local prev = { new_name = "", old_name = "" } -- Prevents duplicate events
            vim.api.nvim_create_autocmd("User", {
                pattern = "NvimTreeSetup",
                callback = function()
                    local events = require("nvim-tree.api").events
                    events.subscribe(events.Event.NodeRenamed, function(data)
                        if prev.new_name ~= data.new_name or prev.old_name ~= data.old_name then
                            data = data
                            Snacks.rename.on_rename_file(data.old_name, data.new_name)
                        end
                    end)
                end,
            })
        end,
    }
}
