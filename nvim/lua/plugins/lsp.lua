return {
    {
        "folke/lazydev.nvim",
        ft = "lua",
        opts = {
            library = {
                { path = "luvit-meta/library", words = { "vim%.uv" } },
            },
        },
    },
    { "Bilal2453/luvit-meta", lazy = true },
    {
        "neovim/nvim-lspconfig",
        event = "VeryLazy",
        config = function()
            vim.keymap.set("n", "<leader>e", "<cmd>lua vim.diagnostic.open_float()<cr>")
            vim.keymap.set("n", "[d", "<cmd>lua vim.diagnostic.goto_prev()<cr>")
            vim.keymap.set("n", "]d", "<cmd>lua vim.diagnostic.goto_next()<cr>")

            vim.api.nvim_create_autocmd("LspAttach", {
                desc = "LSP actions",
                callback = function()
                    local format = function()
                        vim.lsp.buf.format({
                            async = true,
                            filter = function(client)
                                local can_format = client.name ~= "volar" and client.name ~= "ts_ls" and
                                    client.name ~= "vue_ls"
                                return can_format
                            end,
                        })
                    end

                    vim.keymap.set("n", "K", vim.lsp.buf.hover)
                    vim.keymap.set("n", "gD", vim.lsp.buf.declaration)
                    vim.keymap.set("n", "gs", vim.lsp.buf.signature_help)
                    vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action)
                    vim.keymap.set({ "n", "x" }, "<leader>f", format)
                end,
            })
            vim.lsp.config('ts_ls', {
                init_options = {
                    plugins = {
                        {
                            name = "@vue/typescript-plugin",
                            location =
                            "/Users/johannes.sunnanvader/.nvm/versions/node/v22.15.1/lib/node_modules/@vue/typescript-plugin",
                            languages = { "javascript", "typescript", "vue" },
                        },
                    },
                },
                filetypes = { "typescript", "javascript", "javascriptreact", "typescriptreact", "vue", "json" },
            })
            vim.lsp.config('stylelint_lsp', {
                settings = {
                    stylelintplus = {
                        autoFixOnFormat = true,
                    },
                }
            })

            vim.api.nvim_create_user_command('RestartLsp', function()
                local clients = vim.lsp.get_clients { bufnr = 0 }
                vim.lsp.stop_client(clients)
                vim.cmd.update()
                vim.defer_fn(vim.cmd.edit, 1000)
            end, { desc = 'Restart LSP servers' })
        end,
    },
    {
        "mason-org/mason.nvim",
        cmd = "Mason",
        opts = {
            registries = {
                "github:mason-org/mason-registry",
            },
        },
    },
    {
        "mason-org/mason-lspconfig.nvim",
        event = "VeryLazy",
        dependencies = {
            "mason-org/mason.nvim",
            "neovim/nvim-lspconfig",
        },
        opts = {}
    },
    {
        'saghen/blink.compat',
        -- use the latest release, via version = '*', if you also use the latest release for blink.cmp
        version = '*',
        -- lazy.nvim will automatically load the plugin when it's required by blink.cmp
        lazy = true,
        -- make sure to set opts so that lazy.nvim calls blink.compat's setup
        opts = {},
    },
    {
        'saghen/blink.cmp',
        lazy = false,
        dependencies = {
            'rafamadriz/friendly-snippets',
            {
                "MattiasMTS/cmp-dbee",
                dependencies = {
                    { "kndndrj/nvim-dbee" }
                },
                opts = {}, -- needed
            },
            'Kaiser-Yang/blink-cmp-avante',
        },

        version = '*',
        ---@module 'blink.cmp'
        ---@type blink.cmp.Config
        opts = {
            keymap = {
                preset = 'enter',
                ['<Tab>'] = { 'snippet_forward', 'select_next', 'fallback' },
                ['<leader-Tab>'] = { 'show' },
                ['<S-Tab>'] = { 'snippet_backward', 'select_prev', 'fallback' },
                ['<C-e>'] = { 'show', 'hide' },
                ['<C-space>'] = {},
            },
            appearance = {
                use_nvim_cmp_as_default = true,
                nerd_font_variant = 'mono'
            },
            sources = {
                default =
                { 'avante', 'lsp', 'path', 'snippets', 'buffer', 'dbee' },
                providers = {
                    dbee = {
                        name = 'cmp-dbee', -- IMPORTANT: use the same name as you would for nvim-cmp
                        module = 'blink.compat.source',
                    },
                    avante = {
                        name = 'Avante',
                        module = 'blink-cmp-avante'

                    },
                },
                per_filetype = {
                    codecompanion = { "codecompanion" },
                }
            },
            completion = {
                documentation = {
                    auto_show = true,
                    auto_show_delay_ms = 200,
                },
                accept = {
                    auto_brackets = { enabled = true },
                },
                list = {
                    selection = {
                        preselect = function(ctx)
                            return ctx.mode ~= 'cmdline'
                        end,
                        auto_insert = function(ctx) return ctx.mode == 'cmdline' end,
                    }
                    -- selection = function(ctx)
                    --     return ctx.mode == 'cmdline' and 'auto_insert' or 'preselect'
                    -- end
                }
            },
        },
        opts_extend = { "sources.default" }
    },
    {
        "nvimtools/none-ls.nvim",
        event = "VeryLazy",
        dependencies = {
            {
                "jay-babu/mason-null-ls.nvim",
                event = "VeryLazy",
            },
            "nvimtools/none-ls-extras.nvim",
            "williamboman/mason.nvim",
        },
        config = function()
            require("mason-null-ls").setup({
                ensure_installed = {
                    -- Opt to list sources here, when available in mason.
                },
                automatic_installation = false,
                handlers = {
                    autoflake = function(source_name, methods)
                        require('mason-null-ls').default_setup(source_name, methods)
                    end,
                },
            })
            local null_ls = require("null-ls")
            null_ls.setup({
                sources = {
                }
            })
        end,
    }
}
