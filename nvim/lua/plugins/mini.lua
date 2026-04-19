return {
    {
        'echasnovski/mini.nvim',
        event = "VeryLazy",
        keys = {
            { '<leader>hs', 'ghgh',                                   desc = 'Stage hunk',         remap = true },
            { '<leader>hr', 'gHgh',                                   desc = 'Reset hunk',         remap = true },
            { '<leader>hS', 'ghaa',                                   desc = 'Stage buffer',       remap = true },
            { '<leader>hR', 'gHaa',                                   desc = 'Reset buffer',       remap = true },
            { '<leader>hh', function() MiniDiff.toggle_overlay() end, desc = 'Toggle diff overlay' },
        },
        config = function()
            require('mini.pairs').setup()
            require('mini.cursorword').setup()

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
            require('mini.ai').setup({
                custom_textobjects = {
                    a = function()
                        local from = { line = 1, col = 1 }
                        local to = {
                            line = vim.fn.line('$'),
                            col = math.max(vim.fn.getline('$'):len(), 1)
                        }
                        return { from = from, to = to }
                    end
                }
            })
            require('mini.sessions').setup()
            require('mini.diff').setup({
                view = {
                    style = 'sign',
                    signs = { add = '┃', change = '┃', delete = '┃' },
                },
                options = {
                    wrap_goto = true,
                }
            })
            -- require('mini.animate').setup({})
        end,
    },
    {
        'numToStr/Comment.nvim',
        opts = {
        }
    }
}
