return {
    {
        "epwalsh/obsidian.nvim",
        version = "*",
        ft = "markdown",
        dependencies = {
            "nvim-lua/plenary.nvim",
        },
        keys = {
            { '<leader>oo', '<cmd>ObsidianToday<cr>' },
            { '<leader>oq', '<cmd>ObsidianQuickSwitch<cr>' },
            { '<leader>of', '<cmd>ObsidianFind<cr>' },
            { '<leader>ot', '<cmd>ObsidianTags<cr>' },
            { '<leader>od', '<cmd>ObsidianDailies<cr>' },
        },
        opt = {
            workspaces = {
                {
                    name = "work",
                    path = "~/vaults/work",
                },
                {
                    name = "personal",
                    path = "~/vaults/personal",
                }
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
            mappings = {
                -- Overrides the 'gf' mapping to work on markdown/wiki links within your vault.
                ["gf"] = {
                    action = function()
                        return require("obsidian").util.gf_passthrough()
                    end,
                    opts = { noremap = false, expr = true, buffer = true },
                },
                -- Toggle check-boxes.
                ["<leader>ch"] = {
                    action = function()
                        return require("obsidian").util.toggle_checkbox()
                    end,
                    opts = { buffer = true },
                },
                -- Smart action depending on context, either follow link or toggle checkbox.
                ["<cr>"] = {
                    action = function()
                        return require("obsidian").util.smart_action()
                    end,
                    opts = { buffer = true, expr = true },
                },

            },
            follow_url_func = function(url)
                vim.fn.jobstart({ "open", url }) -- Mac OS
            end,
            follow_img_func = function(img)
                vim.fn.jobstart { "qlmanage", "-p", img } -- Mac OS quick look preview
            end,
            ui = {
                enable = false,
                checkboxes = {
                    [" "] = { char = "󰄱", hl_group = "ObsidianTodo" },
                    ["x"] = { char = "", hl_group = "ObsidianDone" },
                    ["~"] = { char = "", hl_group = "ObsidianRightArrow" },
                    ["o"] = { char = "󰰱", hl_group = "ObsidianTilde" },
                    ["-"] = { char = "", hl_group = "ObsidianTodo" },
                }
            },

        },
    },
    {
        "iamcco/markdown-preview.nvim",
        cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
        build = "cd app && yarn install",
        init = function()
            vim.g.mkdp_filetypes = { "markdown" }
        end,
        ft = { "markdown" },
    }
}
