return {
    {
        "epwalsh/obsidian.nvim",
        version = "*",
        -- lazy = true,
        -- ft = "markdown",
        -- keys = { "<leader>o" },
        dependencies = {
            "nvim-lua/plenary.nvim",
        },
        config = function()
            require("obsidian").setup({
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
                ui = {
                    checkboxes = {
                        [" "] = { char = "󰄱", hl_group = "ObsidianTodo" },
                        ["x"] = { char = "", hl_group = "ObsidianDone" },
                        [">"] = { char = "", hl_group = "ObsidianRightArrow" },
                        ["~"] = { char = "󰰱", hl_group = "ObsidianTilde" },
                        ["w"] = { char = "", hl_group = "ObsidianTodo" },
                    }
                },
            })


            vim.keymap.set("n", "<leader>oo", '<cmd>ObsidianToday<cr>', { noremap = true, silent = true })
            vim.keymap.set("n", "<leader>oq", '<cmd>ObsidianQuickSwitch<cr>', { noremap = true, silent = true })
            vim.keymap.set("n", "<leader>of", '<cmd>ObsidianFind<cr>', { noremap = true, silent = true })
            vim.keymap.set("n", "<leader>ot", '<cmd>ObsidianTags<cr>', { noremap = true, silent = true })
            vim.keymap.set("n", "<leader>od", '<cmd>ObsidianDailies<cr>', { noremap = true, silent = true })
            vim.keymap.set("n", "<leader>on", function()
                    local bufnr = vim.fn["floaterm#terminal#get_bufnr"]("obsidian")
                    if bufnr ~= -1 then
                        print("Toggling obsidian")
                        return vim.cmd("FloatermToggle obsidian")
                    else
                        print("Opening obsidian")
                        return vim.cmd("FloatermNew --name=obsidian floaterm -c ':ObsidianToday' && exit")
                    end
                end,
                { noremap = true, silent = true })
        end,
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
