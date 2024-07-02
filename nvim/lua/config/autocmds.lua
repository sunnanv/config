vim.api.nvim_create_autocmd("FileType", {
    group = vim.api.nvim_create_augroup("indentations", {}),
    pattern = { "*.vue", "*.js", "*.ts" },
    callback = function()
        vim.opt.autoindent = true
        vim.opt.expandtab = true
        vim.opt.shiftwidth = 8
        vim.opt.tabstop = 8
    end,
})
