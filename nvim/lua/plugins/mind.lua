local mind = require('mind')
mind.setup()


vim.keymap.set('n', '<leader>mg', mind.open_main, {noremap=true, silent=true})
vim.keymap.set('n', '<leader>mm', mind.open_project, {noremap=true, silent=true})

