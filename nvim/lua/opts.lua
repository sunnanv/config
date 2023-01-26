local opt = vim.opt
local cmd = vim.api.nvim_command

opt.colorcolumn = '80'
opt.number = true
opt.relativenumber = true
opt.scrolloff = 4
opt.signcolumn = 'yes'
opt.cursorline = true

opt.mouse='a'
-- opt.clipboard='unnamedplus'

opt.encoding = 'utf8'
opt.fileencoding = 'utf8'

opt.syntax = 'ON'
opt.termguicolors = true
-- cmd('colorscheme dracula')

opt.ignorecase = true
opt.smartcase = true
opt.incsearch = true
opt.hlsearch = false

opt.expandtab = true
opt.shiftwidth = 4
opt.softtabstop = 4
opt.tabstop = 4

opt.splitright = true
opt.splitbelow = true

opt.exrc = true
