require'nvim-treesitter.configs'.setup {
    ensure_installed = {
        "bash",
        "html",
        "javascript",
        "json",
        "json5",
        "lua",
        "markdown",
        "python",
        "regex",
        "sql",
        "typescript",
        "vue",
        "yaml",
        "org"
    },
    highlight = {
        enable = true,
        additional_vim_regex_highlighting = {'org'}
    },
}

require'nvim-ts-autotag'.setup {}
