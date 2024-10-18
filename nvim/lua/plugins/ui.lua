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
        "nvim-tree/nvim-tree.lua",
        dependencies = "nvim-tree/nvim-web-devicons",
        keys = {
            { "<leader>N", "<cmd>NvimTreeFocus<CR>" },
            { "<leader>n", "<cmd>NvimTreeFindFile<CR>" },
        },
        opts = {
            filters = {
                git_ignored = false,
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
            git = {
                timeout = 10000
            }
        }
    },
    {
        "nvim-lualine/lualine.nvim",
        config = function()
            require('lualine').setup({
            })
        end,
    },
    {
        "folke/noice.nvim",
        event = "VeryLazy",
        opts = {
            lsp = {
                override = {
                    ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
                    ["vim.lsp.util.stylize_markdown"] = true,
                    ["cmp.entry.get_documentation"] = true, -- requires hrsh7th/nvim-cmp
                },
            },
            presets = {
                bottom_search = true,         -- use a classic bottom cmdline for search
                command_palette = true,       -- position the cmdline and popupmenu together
                long_message_to_split = true, -- long messages will be sent to a split
                inc_rename = true,            -- enables an input dialog for inc-rename.nvim
                lsp_doc_border = false,       -- add a border to hover docs and signature help
            },
        },
        dependencies = {
            "MunifTanjim/nui.nvim",
            -- "rcarriga/nvim-notify",
        }
    },
    {
        "OXY2DEV/helpview.nvim",
        lazy = false,
        dependencies = {
            "nvim-treesitter/nvim-treesitter"
        }
    },
    {
        "OXY2DEV/markview.nvim",
        ft = "markdown",
        dependencies = {
            "nvim-treesitter/nvim-treesitter",
            "nvim-tree/nvim-web-devicons"
        },
        config = function()
            local presets = require("markview.presets")

            require("markview").setup({
                checkboxes = presets.checkboxes.nerd,
                headings = presets.headings.glow,
            })
        end,
    },
}
