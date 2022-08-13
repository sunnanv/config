vim.g['neoformat_try_node_exe'] = 1
vim.g['neoformat_try_formatprg'] = 1

vim.api.nvim_create_autocmd("InsertLeave", {
    pattern = '*',
    command = 'Neoformat'
})

-- vim.api.nvim_command([[
--     augroup AutoFormat
--     autocmd BufWritePre *.j
-- ]])
