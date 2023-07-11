vim.g.mapleader = ' '
vim.g.localleader = '\\'

vim.opt.termguicolors = true
require('vars')    -- Variables
require('plugins') -- Plugins
require('keys')    -- Keymaps
require('opts')    -- Options
require('folding')
