return {
    {
        'echasnovski/mini.nvim',
        event = "VeryLazy",
        config = function()
            require('mini.comment').setup({})
            -- require('mini.move').setup({
            --     mappings = {
            --         -- Move visual selection in Visual mode. Defaults are Alt (Meta) + hjkl.
            --         left = '˙',
            --         right = '¬',
            --         down = '∆',
            --         up = '˚',
            --
            --         -- Move current line in Normal mode
            --         line_left = '˙',
            --         line_right = '¬',
            --         line_down = '∆',
            --         line_up = '˚',
            --     },
            -- })
            require('mini.pairs').setup()
            require('mini.surround').setup()
            require('mini.cursorword').setup()
            require('mini.comment').setup()
            require('mini.indentscope').setup({
                draw = {
                    animation = require('mini.indentscope').gen_animation.none()
                },
            })

            local hipatterns = require('mini.hipatterns')
            hipatterns.setup({
                highlighters = {
                    -- Highlight standalone 'FIXME', 'HACK', 'TODO', 'NOTE'
                    fixme     = { pattern = '%f[%w]()FIXME()%f[%W]', group = 'MiniHipatternsFixme' },
                    hack      = { pattern = '%f[%w]()HACK()%f[%W]', group = 'MiniHipatternsHack' },
                    todo      = { pattern = '%f[%w]()TODO()%f[%W]', group = 'MiniHipatternsTodo' },
                    note      = { pattern = '%f[%w]()NOTE()%f[%W]', group = 'MiniHipatternsNote' },

                    -- Highlight hex color strings (`#rrggbb`) using that color
                    hex_color = hipatterns.gen_highlighter.hex_color(),
                },
            })
            require('mini.ai').setup()
        end,
    }
}
