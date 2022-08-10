local map = vim.api.nvim_set_keymap
local dap = require('dap')
local dap_python = require('dap-python')

dap_python.setup('~/.local/venv/nvim/bin/python')

local test_runners = dap_python.test_runners
local function prune_nil(items)
  return vim.tbl_filter(function(x) return x end, items)
end
test_runners.django2 = function(classname, methodname, opts) 
  local path = vim.fn.expand('%:r:gs?/?.?')
  local test_path = table.concat(prune_nil({path, classname, methodname}), '.')
  local args = {'test', test_path}
  return 'django', args
end

dap_python.test_runner = "django2"



local mappings = {
  ['<leader>db'] = dap.toggle_breakpoint,
  ['<leader>dc'] = dap.continue,
  ['<leader>do'] = dap.step_over,
  ['<leader>di'] = dap.step_into,
  ['<leader>ds'] = dap.repl.open,
  ['<leader>dn'] = dap_python.test_method,
  ['<leader>df'] = dap_python.test_class,

}
options = { noremap = true, silent = true }

for keys, mapping in pairs(mappings) do
  vim.api.nvim_set_keymap('n', keys, '', { callback = mapping, noremap = true, silent = true})
end
