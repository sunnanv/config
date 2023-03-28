local M = {}

function M.setup()
    local lsp = require('lsp-zero')
    lsp.preset('recommended')
    lsp.setup()

    local format = function(payload)
        vim.lsp.buf.format({
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
