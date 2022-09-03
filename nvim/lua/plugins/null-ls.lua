require("null-ls").setup({
    sources = {
        require("null-ls").builtins.diagnostics.flake8,
        require('null-ls').builtins.diagnostics.eslint,
    },
})
