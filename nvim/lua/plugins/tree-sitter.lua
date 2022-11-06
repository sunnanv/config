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
        "tsx",
        "yaml",
        "org"
    },
    highlight = {
        enable = true,
        disable = {},
    },
    indent = {
        enable = true,
        disable = {},
    },
    autotag = {
        enable = true,
    },
}

require'nvim-ts-autotag'.setup {}
local parser_config = require "nvim-treesitter.parsers".get_parser_configs()
parser_config.tsx.filetype_to_parsername = { "javascript", "typescript.tsx" }
