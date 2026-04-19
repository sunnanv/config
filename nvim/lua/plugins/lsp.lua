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
        init = function()
            local make_client_capabilities = vim.lsp.protocol.make_client_capabilities
            function vim.lsp.protocol.make_client_capabilities()
                local caps = make_client_capabilities()
                if caps.workspace then
                    caps.workspace.didChangeWatchedFiles = nil
                end
                return caps
            end
        end,
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

            local vue_language_server_path = vim.fn.expand '$MASON/packages' ..
                '/vue-language-server' .. '/node_modules/@vue/language-server'
            local vue_plugin = {
                name = '@vue/typescript-plugin',
                location = vue_language_server_path,
                languages = { 'vue' },
                configNamespace = 'typescript',
            }
            vim.lsp.config('vtsls', {
                settings = {
                    vtsls = {
                        tsserver = {
                            globalPlugins = {
                                vue_plugin,
                            },
                        },
                    },
                },
                filetypes = { 'typescript', 'javascript', 'javascriptreact', 'typescriptreact', 'vue' },
            })
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
            'Kaiser-Yang/blink-cmp-avante',
            'moyiz/blink-emoji.nvim',
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
                { 'avante', 'lsp', 'path', 'snippets', 'buffer', 'emoji' },
                providers = {
                    avante = {
                        name = 'Avante',
                        module = 'blink-cmp-avante'
                    },
                    emoji = {
                        name = 'Emoji',
                        module = 'blink-emoji',
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
                    null_ls.builtins.diagnostics.stylelint,
                }
            })
        end,
    },
    {
        'dmmulroy/ts-error-translator.nvim',
        opts = {}
    }


}
