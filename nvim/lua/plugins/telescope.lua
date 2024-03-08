return {
    {
        {
            "nvim-telescope/telescope.nvim",
            dependencies = {
                "nvim-lua/plenary.nvim",
                "nvim-telescope/telescope-live-grep-args.nvim",
                "fannheyward/telescope-coc.nvim",
            },
            config = function()
                local telescope = require('telescope')

                telescope.setup({
                    defaults = {
                        path_display = { shorten = { len = 3, exclude = { 2, -1 } } },
                    },
                    extensions = {
                        coc = {
                            prefer_locations = true,
                        }
                    }
                })

                telescope.load_extension('fzf')
                telescope.load_extension('live_grep_args')
                telescope.load_extension('coc')


                local mappings = {
                    ['ff'] = ':Telescope find_files<CR>',
                    ['fg'] = ':Telescope live_grep_args<CR>',
                    ['fs'] = ':Telescope git_status<CR>',
                    ['fb'] = ':Telescope git_branches<CR>',
                    ['gt'] = ':Telescope lsp_type_definitions<CR>',
                    ['fr'] = ':Telescope resume<CR>',
                    ['fh'] = ':Telescope oldfiles<CR>'
                }

                for keys, mapping in pairs(mappings) do
                    vim.api.nvim_set_keymap('n', keys, mapping, { noremap = true, silent = true })
                end
            end,
        },
        {
            "nvim-telescope/telescope-fzf-native.nvim",
            build =
            "cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build",
        },
    }
}
