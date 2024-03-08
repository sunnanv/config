return {
    { "folke/neodev.nvim", opts = {} },
    {
        "neovim/nvim-lspconfig",
        dependencies = {
            "williamboman/mason.nvim",
            "williamboman/mason-lspconfig.nvim",
            "hrsh7th/nvim-cmp",
            "hrsh7th/cmp-nvim-lsp",
            "L3MON4D3/LuaSnip",
            "pmizio/typescript-tools.nvim",
            "jayp0521/mason-null-ls.nvim",
            "nvimtools/none-ls.nvim",
            "nvimtools/none-ls-extras.nvim",
        },
        config = function()
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
                                local can_format = client.name ~= 'volar' and client.name ~= 'tsserver' and
                                    client.name ~= 'typescript-tools'
                                return can_format
                            end
                        })
                    end

                    local telescope_functions = require('telescope.builtin')

                    local keymaps = {
                        ['gd'] = telescope_functions.lsp_definitions,
                        ['gi'] = telescope_functions.lsp_implementations,
                        ['go'] = telescope_functions.lsp_type_definitions,
                        ['gr'] = telescope_functions.lsp_references,
                        ['<leader>di'] = function() telescope_functions.diagnostics() end,
                        ['K'] = '<cmd>lua vim.lsp.buf.hover()<cr>',
                        ['gD'] = '<cmd>lua vim.lsp.buf.declaration()<cr>',
                        ['gs'] = '<cmd>lua vim.lsp.buf.signature_help()<cr>',
                        ['<F2>'] = '<cmd>lua vim.lsp.buf.rename()<cr>',
                        ['<F4>'] = '<cmd>lua vim.lsp.buf.code_action()<cr>',
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
                ensure_installed = { 'lua_ls', 'pyright' },
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
                },
            })

            require('typescript-tools').setup({
                capabilities = lsp_capabilities,
                settings = {
                    tsserver_plugins = {
                        '@vue/typescript-plugin'
                    }
                },
                filetypes = {
                    'typescript',
                    'typescriptreact',
                    'javascript',
                    'javascriptreact',
                    'vue',
                },
            })

            local cmp = require('cmp')

            cmp.setup({
                sources = {
                    { name = 'nvim_lsp' },
                },
                mapping = cmp.mapping.preset.insert({
                    -- Enter key confirms completion item
                    ['<CR>'] = cmp.mapping.confirm({ select = false }),
                    ['<Tab>'] = cmp.mapping.select_next_item({ behavior = 'select' }),
                    ['<S-Tab>'] = cmp.mapping.select_prev_item({ behavior = 'select' }),
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
