
vim.api.nvim_set_keymap('n', '<leader>tn', '<cmd>TestNearest<CR>', { noremap = true, silent = true}) -- Test file
vim.api.nvim_set_keymap('n', '<leader>tf', '<cmd>TestFile<CR>', { noremap = true, silent = true}) -- Test file
vim.api.nvim_set_keymap('n', '<leader>ts', '<cmd>TestSuite<CR>', { noremap = true, silent = true}) -- Test suite
vim.api.nvim_set_keymap('n', '<leader>tl', '<cmd>TestLast<CR>', { noremap = true, silent = true}) -- Test last test run
vim.api.nvim_set_keymap('n', '<leader>tv', '<cmd>TestVisit<CR>', { noremap = true, silent = true}) -- Test visit

vim.g['test#python#djangotest#options'] = {all = '--keepdb'}
vim.g['test#strategy'] = 'neovim'

-- local neotest = require('neotest')

-- neotest.setup({
--     adapters = {
--         require('neotest-jest')({
--           jestCommand = "npm test --",
--           jestConfigFile = "custom.jest.config.ts",
--           env = { CI = true },
--           cwd = function(path)
--             return vim.fn.getcwd()
--           end,
--         }),
--         require('neotest-vim-test')({
--             ignore_file_types = { "javascript" }
--         })
--     },
--     icons = {
--           child_indent = "│",
--           child_prefix = "├",
--           collapsed = "─",
--           expanded = "╮",
--           failed = "✖",
--           final_child_indent = " ",
--           final_child_prefix = "╰",
--           non_collapsible = "─",
--           passed = "✓",
--           running = "↻",
--           skipped = "ﰸ",
--           unknown = "?"
--     }
-- })

-- local mappings = {
--     ["<leader>tr"] = function()
--       neotest.run.run(vim.fn.expand("%"))
--     end,
--     ["<leader>ts"] = function()
--       for _, adapter_id in ipairs(neotest.run.adapters()) do
--         neotest.run.run({ suite = true, adapter = adapter_id })
--       end
--     end,
--     ["<leader>tw"] = function()
--       neotest.watch.watch()
--     end,
--     ["<leader>tx"] = function()
--       neotest.run.stop()
--     end,
--     ["<leader>tn"] = neotest.run.run,
--     ["<leader>td"] = function()
--       neotest.run.run({ strategy = "dap" })
--     end,
--     ["<leader>tl"] = neotest.run.run_last,
--     ["<leader>tD"] = function()
--       neotest.run.run_last({ strategy = "dap" })
--     end,
--     ["<leader>ta"] = neotest.run.attach,
--     ["<leader>to"] = function()
--       neotest.output.open({ enter = true })
--     end,
--     ["<leader>tO"] = function()
--       neotest.output.open({ enter = true, short = true })
--     end,
--     ["<leader>tp"] = neotest.summary.toggle,
--     ["<leader>tm"] = neotest.summary.run_marked,
--     ["[n"] = function()
--       neotest.jump.prev({ status = "failed" })
--     end,
--     ["]n"] = function()
--       neotest.jump.next({ status = "failed" })
--     end,
-- }

-- for keys, mapping in pairs(mappings) do
--     vim.api.nvim_set_keymap("n", keys, "", { callback = mapping, noremap = true })
-- end
