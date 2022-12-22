local M = {}

function M.setup()
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


    local parser_config = require "nvim-treesitter.parsers".get_parser_configs()
    parser_config.tsx.filetype_to_parsername = { "javascript", "typescript.tsx" }
end

return M

