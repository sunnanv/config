return {
    {
        "folke/snacks.nvim",
        priority = 1000,
        lazy = false,
        keys = {
            { "<leader>sh", function() Snacks.notifier.show_history() end, desc = "Notification History" },
            { "<leader>cn", function() Snacks.notifier.hide() end },
            { "<leader>cR", function() Snacks.rename.rename_file() end,    desc = "Rename File" },
        },
        opts = {
            notifier = {
            }
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
