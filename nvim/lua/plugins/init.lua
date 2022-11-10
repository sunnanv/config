require('plugins.plug')

require('plugins.tree-sitter')
require('plugins.nvim-tree-conf')
require('plugins.lualine')
require('plugins.lsp')
require('plugins.vim-test')
require('plugins.dap')
require('plugins.neoformat')
require('plugins.null-ls')
require('plugins.telescope')
require('plugins.projectionist')
require('plugins.harpoon')
require('plugins.mind')
require('plugins.hop')
require('plugins.theme')

require('nvim-autopairs').setup{}
require 'colorizer'.setup(nil, { css = true; })

