return {
    {
        "folke/snacks.nvim",
        priority = 1000,
        lazy = false,
        ---@type snacks.Config
        keys = {
            { "<leader>sh",   function() Snacks.notifier.show_history() end,                                       desc = "Notification History" },
            { "<leader>cn",   function() Snacks.notifier.hide() end },
            { "<leader>cR",   function() Snacks.rename.rename_file() end,                                          desc = "Rename File" },
            { "]]",           function() Snacks.words.jump(vim.v.count1) end,                                      desc = "Next Reference",        mode = { "n", "t" } },
            { "[[",           function() Snacks.words.jump(-vim.v.count1) end,                                     desc = "Prev Reference",        mode = { "n", "t" } },
            { "<leader>n",    function() Snacks.picker.explorer() end,                                             desc = "Explorer" },
            { "<leader>N",    function() Snacks.picker.explorer({ auto_close = false }) end,                       desc = "Explorer" },
            { "<leader>ff",   function() Snacks.picker.smart() end,                                                desc = "Files" },
            { "<leader>fg",   function() Snacks.picker.grep() end,                                                 desc = "Grep" },
            { "<leader>fw",   function() Snacks.picker.grep_word() end,                                            desc = "Grep word" },
            { "<leader>gf",   function() Snacks.picker.grep({ search = vim.fs.basename(vim.fn.expand("%")) }) end, desc = "Grep current file name" },
            { "<leader>fs",   function() Snacks.picker.git_status() end,                                           desc = "Git Status" },
            { "<leader>fb",   function() Snacks.picker.git_branches() end,                                         desc = "Branches" },
            { "<leader>fr",   function() Snacks.picker.resume() end,                                               desc = "Resume" },
            { "<leader>fh",   function() Snacks.picker.recent({ filter = { cwd = true } }) end,                    desc = "Recent" },
            { "<leader>ft",   function() Snacks.picker.lsp_symbols() end,                                          desc = "Lsp Symbols" },
            { "<leader><cr>", function() Snacks.picker() end,                                                      desc = "All pickers" },
            { "gd",           function() Snacks.picker.lsp_definitions() end,                                      desc = "Lsp Definitions" },
            { "gt",           function() Snacks.picker.lsp_type_definitions() end,                                 desc = "Lsp Type Definitions" },
            { "gi",           function() Snacks.picker.lsp_implementations() end,                                  desc = "Lsp Implementations" },
            { "gr",           function() Snacks.picker.lsp_references() end,                                       desc = "Lsp References" },
        },

        opts = {
            bigfile = {},
            dashboard = {},
            notifier = {
            },
            picker = {
                layout = {
                    --     preset = "vertical",
                    layout = {
                        width = 0.9,
                    }
                },
                sources = {
                    explorer = {
                        layout = { layout = { width = 90 } },
                        hidden = true,
                        ignored = true,
                        auto_close = true,
                        supports_live = false,
                    },
                },
                formatters = {
                    file = {
                        filename_first = true,
                        truncate = 80,
                    }
                }
            },
            words = { enabled = true },
            statuscolumn = {},
            indent = { enabled = true },
        },
        init = function(_, opts)
            vim.api.nvim_create_autocmd("User", {
                pattern = "VeryLazy",
                callback = function()
                    Snacks.toggle.option("wrap", { name = "Wrap" }):map("<leader>uw")
                    Snacks.toggle.inlay_hints():map("<leader>uh")
                    Snacks.toggle.dim():map("<leader>uD")
                end,
            })
        end,
    },
}
