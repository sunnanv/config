local g = vim.g

g.t_co = 256
g.background = "dark"


local packer_path = vim.fn.stdpath('config') .. '/site'
vim.o.packpath = vim.o.packpath .. ',' .. packer_path

g.python3_host_prog = '~/.local/venv/nvim/bin/python'
g.vim_json_syntax_conceal=0
