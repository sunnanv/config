vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

vim.g.mapleader = ' '

vim.opt.termguicolors = true
require('config.vars')
require('config.keys')
require('config.opts')
require('config.autocmds')


require('config.lazy')
