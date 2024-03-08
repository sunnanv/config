return {
    {
        "folke/tokyonight.nvim",
        priority = 1000,
        config = function()
            require('tokyonight').setup({
                style = 'night',
            })
            vim.cmd [[colorscheme tokyonight]]
        end,
    },
    {
        "kyazdani42/nvim-tree.lua",
        dependencies = "kyazdani42/nvim-web-devicons",
        lazy = false,
        priority = 1000,
        config = function()
            require("nvim-tree").setup({
                filters = {
                    git_ignored = false,
                },
                view = {
                    width = {},
                },
                actions = {
                    open_file = {
                        quit_on_open = true,
                    },
                },
                renderer = {
                    icons = {
                        glyphs = {
                            git = {
                                untracked = "",
                            },
                        },
                    },
                },
                on_attach = function(bufnr)
                    local api = require "nvim-tree.api"

                    local function opts(desc)
                        return { desc = "nvim-tree: " .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
                    end

                    -- default mappings
                    api.config.mappings.default_on_attach(bufnr)

                    -- custom mappings
                    vim.keymap.set('n', 'fi', api.live_filter.start, opts('Filter'))
                end,
            })

            local mappings = {
                ["<leader>n"] = "<cmd>NvimTreeFocus<CR>",
                ["<leader>N"] = "<cmd>NvimTreeFindFile<CR>",
            }

            for keys, mapping in pairs(mappings) do
                vim.api.nvim_set_keymap("n", keys, mapping, { noremap = true, silent = true })
            end
        end,
    },
    {
        "nvim-lualine/lualine.nvim",
        opts = {
            options = {
                theme = 'tokyonight'
            }
        },
    },
}
