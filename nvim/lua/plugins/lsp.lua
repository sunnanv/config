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
                                local can_format = client.name ~= "volar" and client.name ~= "ts_ls"
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
        end,
    },
    {
        "williamboman/mason.nvim",
        cmd = "Mason",
        opts = {
            registries = {
                "github:mason-org/mason-registry",
            },
        },
    },
    {
        "williamboman/mason-lspconfig.nvim",
        event = "VeryLazy",
        dependencies = {
            "saghen/blink.cmp",
            "neovim/nvim-lspconfig",
        },
        opts = {
            handlers = {
                function(server)
                    require("lspconfig")[server].setup({
                        capabilities = require('blink.cmp').get_lsp_capabilities(),
                    })
                end,
                lua_ls = function()
                    require("lspconfig").lua_ls.setup({
                        capabilities = require('blink.cmp').get_lsp_capabilities(),
                        settings = {
                            Lua = {
                                runtime = {
                                    version = "LuaJIT",
                                },
                                diagnostics = {
                                    globals = { "vim" },
                                },
                                workspace = {
                                    library = {
                                        vim.env.VIMRUNTIME,
                                    },
                                },
                            },
                        },
                    })
                end,
                ts_ls = function()
                    require("lspconfig").ts_ls.setup({
                        capabilities = require('blink.cmp').get_lsp_capabilities(),
                        init_options = {
                            plugins = {
                                {
                                    name = "@vue/typescript-plugin",
                                    location =
                                    "/Users/johannessunnanvader/.nvm/versions/node/v20.11.0/lib/node_modules/@vue/typescript-plugin",
                                    languages = { "javascript", "typescript", "vue" },
                                },
                            },
                        },
                        filetypes = { "typescript", "javascript", "javascriptreact", "typescriptreact", "vue", "json" },
                    })
                end,
                eslint = function()
                    require("lspconfig").eslint.setup({
                        capabilities = require('blink.cmp').get_lsp_capabilities(),
                        root_dir = require("lspconfig/util").root_pattern(
                            ".git",
                            ".eslintrc",
                            ".eslintrc.js",
                            ".eslintrc.json",
                            ".eslintrc.yaml",
                            ".eslintrc.yml"
                        ),
                    })
                end,
            },
        },
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
        dependencies = { 'rafamadriz/friendly-snippets', {
            "MattiasMTS/cmp-dbee",
            dependencies = {
                { "kndndrj/nvim-dbee" }
            },
            opts = {}, -- needed
        }, },

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
                { 'lsp', 'path', 'snippets', 'buffer', 'dbee' },
                providers = {
                    dbee = {
                        name = 'cmp-dbee', -- IMPORTANT: use the same name as you would for nvim-cmp
                        module = 'blink.compat.source',
                    }
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
                handlers = {},
            })
            local null_ls = require("null-ls")
            null_ls.setup({
            })
        end,
    }
}
