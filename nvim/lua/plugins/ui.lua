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
                git = {
                    timeout = 10000
                }
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
        config = function()
            require('lualine').setup({
                sections = {
                    lualine_x = { 'require("pomodoro").statusline()', 'filetype' },
                }
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
            -- if you lazy-load any plugin below, make sure to add proper `module="..."` entries
            "MunifTanjim/nui.nvim",
            -- OPTIONAL:
            --   `nvim-notify` is only needed, if you want to use the notification view.
            --   If not available, we use `mini` as the fallback
            -- "rcarriga/nvim-notify",
        }
    },
    {
        "smjonas/inc-rename.nvim",
        config = function()
            require("inc_rename").setup()
            vim.keymap.set("n", "rn", function()
                return ":IncRename " .. vim.fn.expand("<cword>")
            end, { noremap = true, silent = true, expr = true })
        end,
    },
    { 'projekt0n/github-nvim-theme' },

    -- {
    --     "startup-nvim/startup.nvim",
    --     requires = { "nvim-telescope/telescope.nvim", "nvim-lua/plenary.nvim" },
    --     config = function()
    --         require "startup".setup {}
    --     end
    -- }

}
