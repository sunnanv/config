return {
    { "folke/neodev.nvim", opts = {} },
    {
        "neovim/nvim-lspconfig",
        dependencies = {
            {
                "williamboman/mason.nvim",
                opts = {
                    registries = {
                        'github:nvim-java/mason-registry',
                        'github:mason-org/mason-registry',
                    },
                },
            },
            "williamboman/mason-lspconfig.nvim",
            "hrsh7th/nvim-cmp",
            "hrsh7th/cmp-nvim-lsp",
            "L3MON4D3/LuaSnip",
            "jayp0521/mason-null-ls.nvim",
            "nvimtools/none-ls.nvim",
            "nvimtools/none-ls-extras.nvim",
            {
                'nvim-java/nvim-java',
                dependencies = {
                    'nvim-java/lua-async-await',
                    'nvim-java/nvim-java-core',
                    'nvim-java/nvim-java-test',
                    'nvim-java/nvim-java-dap',
                    'MunifTanjim/nui.nvim',
                    'mfussenegger/nvim-dap',
                },
            }
        },
        config = function()
            require('java').setup()
            vim.keymap.set('n', '<leader>e', '<cmd>lua vim.diagnostic.open_float()<cr>')
            vim.keymap.set('n', '[d', '<cmd>lua vim.diagnostic.goto_prev()<cr>')
            vim.keymap.set('n', ']d', '<cmd>lua vim.diagnostic.goto_next()<cr>')

            vim.api.nvim_create_autocmd('LspAttach', {
                desc = 'LSP actions',
                callback = function(event)
                    local format = function()
                        vim.lsp.buf.format({
                            async = true,
                            filter = function(client)
                                local can_format = client.name ~= 'volar' and client.name ~= 'tsserver'
                                return can_format
                            end
                        })
                    end

                    local telescope_functions = require('telescope.builtin')

                    local keymaps = {
                        ['gd'] = function() telescope_functions.lsp_definitions() end,
                        ['gi'] = function() telescope_functions.lsp_implementations() end,
                        ['go'] = function() telescope_functions.lsp_type_definitions() end,
                        ['gr'] = function() telescope_functions.lsp_references() end,
                        ['<leader>di'] = function() telescope_functions.diagnostics() end,
                        ['K'] = '<cmd>lua vim.lsp.buf.hover()<cr>',
                        ['gD'] = '<cmd>lua vim.lsp.buf.declaration()<cr>',
                        ['gs'] = '<cmd>lua vim.lsp.buf.signature_help()<cr>',
                        ['rn'] = '<cmd>lua vim.lsp.buf.rename()<cr>',
                        ['ca'] = '<cmd>lua vim.lsp.buf.code_action()<cr>',
                        ['<leader>f'] = { { 'n', 'x' }, format },
                        -- '', telescope_functions.lsp_incoming_calls,
                        -- '', telescope_functions.lsp_outgoing_calls,
                        -- '', telescope_functions.lsp_document_symbols,
                        -- '', telescope_functions.lsp_workspace_symbols,
                    }

                    for keys, mapping in pairs(keymaps) do
                        local options = { noremap = true, silent = true, buffer = event.buf }
                        local mode = 'n'
                        local method = mapping
                        if type(mapping) == 'table' then
                            modes = mapping[1]
                            method = mapping[2]
                        end
                        vim.keymap.set(mode, keys, method, options)
                    end
                end
            })


            local lsp_capabilities = require('cmp_nvim_lsp').default_capabilities()


            local default_setup = function(server)
                require('lspconfig')[server].setup({
                    capabilities = lsp_capabilities,
                })
            end

            require('mason').setup({})
            require('mason-lspconfig').setup({
                handlers = {
                    default_setup,
                    lua_ls = function()
                        require('lspconfig').lua_ls.setup({
                            capabilities = lsp_capabilities,
                            settings = {
                                Lua = {
                                    runtime = {
                                        version = 'LuaJIT'
                                    },
                                    diagnostics = {
                                        globals = { 'vim' },
                                    },
                                    workspace = {
                                        library = {
                                            vim.env.VIMRUNTIME,
                                        }
                                    }
                                }
                            }
                        })
                    end,
                    tsserver = function()
                        require('lspconfig').tsserver.setup({
                            capabilities = lsp_capabilities,
                            init_options = {
                                plugins = {
                                    {
                                        name = "@vue/typescript-plugin",
                                        location =
                                        "/Users/johannessunnanvader/.nvm/versions/node/v20.11.0/lib/node_modules/@vue/typescript-plugin",
                                        languages = { "javascript", "typescript", "vue" },
                                    }
                                }
                            },
                            filetypes = { 'typescript', 'javascript', 'javascriptreact', 'typescriptreact', 'vue', 'json' },

                        })
                    end,
                },
            })

            require('lspconfig').jdtls.setup({
                capabilities = lsp_capabilities,
            })


            local cmp = require('cmp')
            local has_words_before = function()
                unpack = unpack or table.unpack
                local line, col = unpack(vim.api.nvim_win_get_cursor(0))
                return col ~= 0 and
                    vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
            end
            cmp.setup({
                sources = {
                    { name = 'nvim_lsp' },
                },
                mapping = cmp.mapping.preset.insert({
                    -- Enter key confirms completion item
                    ['<CR>'] = cmp.mapping.confirm({ select = false }),
                    ['<Tab>'] = cmp.mapping(function(fallback)
                        if cmp.visible() then
                            cmp.select_next_item({ behavior = cmp.SelectBehavior.Select })
                        elseif has_words_before() then
                            cmp.complete()
                        else
                            fallback()
                        end
                    end, { 'i', 's' }),
                    ['<S-Tab>'] = cmp.mapping(function(fallback)
                        if cmp.visible() then
                            cmp.select_prev_item({ behavior = cmp.SelectBehavior.Select })
                        else
                            fallback()
                        end
                    end, { 'i', 's' }),
                    -- ['<Tab>'] = cmp.mapping.select_next_item({ behavior = 'select' }),
                    -- ['<S-Tab>'] = cmp.mapping.select_prev_item({ behavior = 'select' }),
                }),
                snippet = {
                    expand = function(args)
                        require('luasnip').lsp_expand(args.body)
                    end,
                },
            })


            require("mason-null-ls").setup({
                ensure_installed = {
                    -- Opt to list sources here, when available in mason.
                },
                automatic_installation = false,
                handlers = {},
            })
            require("null-ls").setup({
                sources = {
                    -- Anything not supported by mason.
                    require("none-ls.diagnostics.eslint_d"),
                    require('null-ls').builtins.diagnostics.stylelint.with({
                        filetypes = { 'css', 'scss', 'less', 'sass', 'vue' },

                    })

                }
            })
        end
    }
}
