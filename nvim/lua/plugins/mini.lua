return {
    {
        'echasnovski/mini.nvim',
        config = function()
            require('mini.comment').setup({})
            require('mini.move').setup({
                mappings = {
                    -- Move visual selection in Visual mode. Defaults are Alt (Meta) + hjkl.
                    left = '˙',
                    right = '¬',
                    down = '∆',
                    up = '˚',

                    -- Move current line in Normal mode
                    line_left = '˙',
                    line_right = '¬',
                    line_down = '∆',
                    line_up = '˚',
                },
            })
        end,
    }
}
