return {
    {
        'echasnovski/mini.nvim',
        event = "VeryLazy",
        config = function()
            require('mini.comment').setup({})
            require('mini.pairs').setup()
            require('mini.surround').setup()
            require('mini.cursorword').setup()
            require('mini.indentscope').setup({
                draw = {
                    animation = require('mini.indentscope').gen_animation.none()
                },
            })

            local hipatterns = require('mini.hipatterns')
            hipatterns.setup({
                highlighters = {
                    fixme     = { pattern = '%f[%w]()FIXME()%f[%W]', group = 'MiniHipatternsFixme' },
                    hack      = { pattern = '%f[%w]()HACK()%f[%W]', group = 'MiniHipatternsHack' },
                    todo      = { pattern = '%f[%w]()TODO()%f[%W]', group = 'MiniHipatternsTodo' },
                    note      = { pattern = '%f[%w]()NOTE()%f[%W]', group = 'MiniHipatternsNote' },
                    hex_color = hipatterns.gen_highlighter.hex_color(),
                },
            })
            require('mini.ai').setup()
            require('mini.sessions').setup()
            require('mini.diff').setup({})
        end,
    }
}
