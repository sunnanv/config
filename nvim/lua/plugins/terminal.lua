return {
    {
        'akinsho/toggleterm.nvim',
        version = "*",
        opts = {

            size = function(term)
                if term.direction == 'horizontal' then
                    return 30
                elseif term.direction == 'vertical' then
                    return vim.o.columns * 0.4
                end
            end,
            open_mapping = [[<C-t>]],
            direction = 'vertical',
            float_opts = {
                border = 'curved',
            },
        },
        keys = {
            '<C-t>',
        },
        config = function(_, opts)
            require('toggleterm').setup(opts)

            function _G.set_terminal_keymaps()
                vim.keymap.set('t', '<C-\\>', [[<C-\><C-n>]], { buffer = 0 })
            end

            -- if you only want these mappings for toggle term use term://*toggleterm#* instead
            vim.cmd('autocmd! TermOpen term://* lua set_terminal_keymaps()')
        end
    }
}
