return {
    -- {
    --     "folke/tokyonight.nvim",
    --     priority = 1000,
    --     config = function()
    --         -- require('tokyonight').setup({
    --         --     style = 'storm',
    --         -- })
    --         -- vim.cmd [[colorscheme tokyonight]]
    --     end,
    -- },
    {
        "catppuccin/nvim",
        name = "catppuccin",
        priority = 1000,
        opts = {
            integrations = {
                neotest = true,
                blink_cmp = true,
                harpoon = true,
                noice = true,
                snacks = {
                    enabled = true,
                },
                lsp_trouble = true,
                which_key = true,
            },
        },
        init = function()
            vim.cmd.colorscheme "catppuccin-frappe"
        end
    },
    {
        "nvim-lualine/lualine.nvim",
        dependencies = {
            "letieu/harpoon-lualine",
        },
        config = function()
            require('lualine').setup({
                sections = {
                    lualine_b = { 'filename', 'diff', 'diagnostics' },
                    lualine_c = { "harpoon2" },
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
        'MeanderingProgrammer/render-markdown.nvim',
        dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-tree/nvim-web-devicons' }, -- if you prefer nvim-web-devicons
        ---@module 'render-markdown'
        ---@type render.md.UserConfig
        opts = {
            file_types = { "markdown", "Avante" },
        },
        ft = { "markdown", "Avante" },
    },
    -- {
    --     "OXY2DEV/markview.nvim",
    --     ft = { "markdown", "Avante" },
    --     dependencies = {
    --         "nvim-treesitter/nvim-treesitter",
    --         "nvim-tree/nvim-web-devicons"
    --     },
    --     config = function(_, opts)
    --         local presets = require("markview.presets")
    --
    --         require("markview").setup({
    --             markdown = {
    --                 list_items = {
    --                     shift_width = function(buffer, item)
    --                         local parent_indnet = math.max(1, item.indent - vim.bo[buffer].shiftwidth);
    --                         return (item.indent) * (1 / (parent_indnet * 2));
    --                     end,
    --                     marker_minus = {
    --                         add_padding = function(_, item)
    --                             return item.indent > 1;
    --                         end
    --                     }
    --                 },
    --                 headings = presets.headings.glow,
    --                 block_quotes = {
    --                     enable = true,
    --                     wrap = true,
    --
    --                     default = {
    --                         border = "▋", hl = "MarkviewBlockQuoteDefault"
    --                     },
    --
    --                     ["INPROGRESS"] = {
    --                         hl = "MarkviewBlockQuoteNote",
    --                         preview = "󰲽 In Progress",
    --
    --                         title = true,
    --                         icon = "󰲽",
    --
    --                         border = "▋"
    --                     },
    --                     ["REVIEW"] = {
    --                         hl = "MarkviewBlockQuoteWarn",
    --                         preview = " Review",
    --
    --                         title = true,
    --                         icon = "",
    --
    --                         border = "▋"
    --                     },
    --                     ["TESTING"] = {
    --                         hl = "MarkviewBlockQuoteSpecial",
    --                         preview = "󰙨 Testing",
    --
    --                         title = true,
    --                         icon = "󰙨",
    --
    --                         border = "▋"
    --                     },
    --                 }
    --             },
    --             preview = {
    --                 icon_provider = "devicons"
    --             },
    --         })
    --     end,
    -- },
    -- {
    --     'stevearc/quicker.nvim',
    --     event = "FileType qf",
    --     ---@module "quicker"
    --     ---@type quicker.SetupOptions
    --     opts = {},
    -- },
    {
        "folke/trouble.nvim",
        opts = {}, -- for default options, refer to the configuration section for custom setup.
        cmd = "Trouble",
        keys = {
            {
                "<leader>xx",
                "<cmd>Trouble diagnostics toggle<cr>",
                desc = "Diagnostics (Trouble)",
            },
            {
                "<leader>xX",
                "<cmd>Trouble diagnostics toggle filter.buf=0<cr>",
                desc = "Buffer Diagnostics (Trouble)",
            },
            {
                "<leader>cs",
                "<cmd>Trouble symbols toggle focus=false<cr>",
                desc = "Symbols (Trouble)",
            },
            {
                "<leader>cl",
                "<cmd>Trouble lsp toggle focus=false win.position=right<cr>",
                desc = "LSP Definitions / references / ... (Trouble)",
            },
            {
                "<leader>xL",
                "<cmd>Trouble loclist toggle<cr>",
                desc = "Location List (Trouble)",
            },
            {
                "<leader>xQ",
                "<cmd>Trouble qflist toggle<cr>",
                desc = "Quickfix List (Trouble)",
            },
        },
        init = function()
            vim.api.nvim_create_autocmd("BufRead", {
                callback = function(ev)
                    if vim.bo[ev.buf].buftype == "quickfix" then
                        vim.schedule(function()
                            vim.cmd([[cclose]])
                            vim.cmd([[Trouble qflist open]])
                        end)
                    end
                end,
            })
        end
    },
    {
        'kevinhwang91/nvim-ufo',
        dependencies = { 'kevinhwang91/promise-async' },
        keys = {
            {
                "zR",
                function()
                    require('ufo').openAllFolds()
                end,
                desc = "Open all folds (ufo)",
            },
            {
                "zM",
                function()
                    require('ufo').closeAllFolds()
                end,
                desc = "Close all folds (ufo)",
            },
            {
                "zK",
                function()
                    local winid = require('ufo').peekFoldedLinesUnderCursor()
                    if not winid then
                        vim.lsp.buf.hover()
                    end
                end,
                desc = "Peek folded lines under cursor (ufo)",
                remap = true,
            }
        },
        event = "VeryLazy",
        init = function()
            vim.o.foldcolumn = '1' -- '0' is not bad
            vim.o.foldlevel = 99   -- Using ufo provider need a large value, feel free to decrease the value
            vim.o.foldlevelstart = 99
            vim.o.foldenable = true

            local capabilities = vim.lsp.protocol.make_client_capabilities()
            capabilities.textDocument.foldingRange = {
                dynamicRegistration = false,
                lineFoldingOnly = true
            }
            local language_servers = vim.lsp.get_clients() -- or list servers manually like {'gopls', 'clangd'}
            for _, ls in ipairs(language_servers) do
                require('lspconfig')[ls].setup({
                    capabilities = capabilities
                    -- you can add other fields for setting up lsp server in this table
                })
            end
            require('ufo').setup()
        end
    },
}
