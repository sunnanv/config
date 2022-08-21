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
        "kotlin"
    },
    highlight = {
        enable = true,
    },
}

require'nvim-ts-autotag'.setup {}
