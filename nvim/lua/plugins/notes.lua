return {
    {
        "obsidian-nvim/obsidian.nvim",
        version = "*",
        dependencies = {
            "nvim-lua/plenary.nvim",
        },
        cmd = { "ObsidianToday", "ObsidianQuickSwitch", "ObsidianFind", "ObsidianTags", "ObsidianDailies", "ObsidianOpen" },
        keys = {
            { "<leader>oi", ":ObsidianYesterday<cr>",                     "Obsidian Yesterday" },
            { "<leader>oo", ":ObsidianToday<cr>",                         "Obsidian Today" },
            { "<leader>op", ":ObsidianTomorrow<cr>",                      "Obsidian Tomorrow" },
            { "<leader>ot", ":ObsidianQuickSwitch todo-archive<cr>",      "Obisidian Todo" },
            { "<leader>on", ":ObsidianQuickSwitch notes-archive<cr>",     "Obisidian Notes" },
            { "<leader>ol", ":ObsidianQuickSwitch learnings-archive<cr>", "Obisidian Learnings" },
            { "<leader>oq", ":ObsidianQuickSwitch<cr>" },
            { "<leader>od", ":ObsidianDailies<cr>" },
        },
        opts = {
            workspaces = {
                {
                    name = "work",
                    path = "~/vaults/work",
                },
                -- {
                --     name = "personal",
                --     path = "~/vaults/personal",
                -- },
            },
            daily_notes = {
                folder = "dailies",
                template = "dailies",
            },
            templates = {
                folder = "templates",
                date_format = "%Y-%m-%d",
                time_format = "%H:%M",
                -- A map for custom variables, the key should be the variable and the value a function
                substitutions = {},
            },
            follow_url_func = function(url)
                vim.fn.jobstart({ "open", url }) -- Mac OS
            end,
            follow_img_func = function(img)
                vim.fn.jobstart({ "qlmanage", "-p", img }) -- Mac OS quick look preview
            end,
            ui = {
                enable = true,
                checkboxes = {
                    [" "] = { char = "󰄱", hl_group = "ObsidianTodo" },
                    ["x"] = { char = "", hl_group = "ObsidianDone" },
                    ["-"] = { char = "", hl_group = "ObsidianTodo" },
                    [">"] = { char = "", hl_group = "ObsidianRightArrow" },
                    ["~"] = { char = "󰰱", hl_group = "ObsidianTilde" },
                    ["!"] = { char = "", hl_group = "ObsidianImportant" },
                },
            },
            picker = {
                name = "snacks.pick",
            },
            completion = {
                -- Enables completion using nvim_cmp
                nvim_cmp = false,
                -- Enables completion using blink.cmp
                blink = true,
                -- Trigger completion at 2 chars.
                min_chars = 2,
            },
        },
    },
}
