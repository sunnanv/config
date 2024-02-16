local M = {}

function M.setup()
    local lsp = require('lsp-zero')
    lsp.preset({
        name = 'recommended',
        manage_nvim_cmp = {
            set_extra_mappings = true
        }
    })
    require('mason-lspconfig').setup({
        handlers = {
            lsp.default_setup,
            tsserver = function()
                require('lspconfig').tsserver.setup({
                    filetypes = { 'typescript', 'javascript', 'javascriptreact', 'typescriptreact', 'json' },

                })
            end,

            volar = function()
                require('lspconfig').volar.setup({
                    filetypes = { 'typescript', 'javascript', 'javascriptreact', 'vue', 'typescriptreact', 'json' },

                })
            end,
        }
    })
    -- require('lspconfig').volar.setup({
    --     filetypes = { 'typescript', 'javascript', 'javascriptreact', 'typescriptreact', 'vue', 'json' }

    -- })

    lsp.on_attach(function(client, bufnr)
        lsp.default_keymaps({
            buffer = bufnr,
        })

        vim.keymap.set('n', 'gr', '<cmd>Telescope lsp_references show_line=false<cr>', { buffer = true })
    end)


    lsp.setup()
    local cmp = require('cmp')

    cmp.setup({
        mapping = {
            ['<CR>'] = cmp.mapping.confirm({ select = true }),
        }
    })

    local format = function(payload)
        vim.lsp.buf.format({
            async = true,
            filter = function(client)
                return client.name ~= 'volar' and client.name ~= 'tsserver'
            end
        })
    end

    local callback_mappings = {
        ['<leader>e'] = vim.diagnostic.open_float,
        ['<leader>rn'] = vim.lsp.buf.rename,
        ['<leader>f'] = format
    }

    for keys, mapping in pairs(callback_mappings) do
        vim.api.nvim_set_keymap('n', keys, '', { callback = mapping, noremap = true, silent = true })
    end


    local ls = require('luasnip')
    local s = ls.snippet
    local i = ls.insert_node
    local fmt = require("luasnip.extras.fmt").fmt

    ls.add_snippets("python", {
        s("tst",
            fmt("def test_{}_{}_{}(self):\n" ..
                "    # Arrange\n\n" ..
                "    # Act\n\n" ..
                "    # Assert\n",
                {
                    i(1),
                    i(2),
                    i(3),
                }
            ))

    })
end

return M
