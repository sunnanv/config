return {
    {
        {
            "nvim-telescope/telescope.nvim",
            dependencies = {
                "nvim-lua/plenary.nvim",
                "nvim-telescope/telescope-live-grep-args.nvim",
                "prochri/telescope-all-recent.nvim",
                "kkharji/sqlite.lua",
            },
            keys = {
                { "ff", function() require("telescope.builtin").find_files() end },
                { "fg", function() require("telescope").extensions.live_grep_args.live_grep_args() end },
                { "fs", function() require("telescope.builtin").git_status() end },
                { "fb", function() require("telescope.builtin").git_branches() end },
                { "gt", function() require("telescope.builtin").lsp_type_definitions() end },
                { "fr", function() require("telescope.builtin").resume() end },
                { "fh", function() require("telescope.builtin").oldfiles() end },
                { "ft", function() require("telescope.builtin").treesitter() end }
            },
            opts = {
                defaults = {
                    path_display = { shorten = { len = 3, exclude = { 2, -1 } } },
                    layout_config = {
                        horizontal = {
                            preview_cutoff = 0,
                        },
                        cursor = {
                            preview_cutoff = 0,
                        },
                    },
                    mappings = {
                        i = {
                            ["<C-j>"] = require("telescope.actions").move_selection_next,
                            ["<C-k>"] = require("telescope.actions").move_selection_previous,
                        },
                    },
                },
            },
            config = function(_, opts)
                require("telescope-all-recent").setup({
                    default = {
                        sorting = "frecency",
                    },
                })

                local telescope = require("telescope")
                telescope.setup(opts)

                telescope.load_extension("fzf")
                telescope.load_extension("live_grep_args")

                local live_grep_args_shortcuts = require("telescope-live-grep-args.shortcuts")
                vim.keymap.set("v", "<C-/>", live_grep_args_shortcuts.grep_word_visual_selection_current_buffer)
                vim.keymap.set("n", "<C-/>", live_grep_args_shortcuts.grep_word_under_cursor_current_buffer)

                vim.keymap.set("v", "<C-.>", live_grep_args_shortcuts.grep_visual_selection)
                vim.keymap.set("n", "<C-.>", live_grep_args_shortcuts.grep_word_under_cursor)
            end,
        },
        {
            "nvim-telescope/telescope-fzf-native.nvim",
            build =
            "cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build",
        },
        { "xiyaowong/telescope-emoji.nvim" },
    },
}
