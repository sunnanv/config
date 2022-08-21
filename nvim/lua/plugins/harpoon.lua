
local mappings = {
  ['<leader>hm'] = require("harpoon.mark").toggle_file,
  ['<leader>hu'] = require("harpoon.ui").toggle_quick_menu,
  ['<leader>hc'] = require('harpoon.mark').clear_all,
  ['<leader>h1'] = function()
	  require('harpoon.ui').nav_file(1)
  end,
  ['<leader>h2'] = function()
	  require('harpoon.ui').nav_file(2)
  end,
  ['<leader>h3'] = function()
	  require('harpoon.ui').nav_file(3)
  end,
  ['<leader>h4'] = function()
	  require('harpoon.ui').nav_file(4)
  end,
  ['<leader>hj'] = require('harpoon.ui').nav_next,
  ['<leader>hk'] = require('harpoon.ui').nav_prev,
}
options = { noremap = true, silent = true }

for keys, mapping in pairs(mappings) do
  vim.api.nvim_set_keymap('n', keys, '', { callback = mapping, noremap = true, silent = true})
end
