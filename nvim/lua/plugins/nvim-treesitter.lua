return {
    {
        "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate",
        opts = {
            auto_install = true,
            ensure_installed = {
                "bash",
                "html",
                "javascript",
                "json",
                "json5",
                "lua",
                "markdown",
                "markdown_inline",
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
        },
        config = function(_, opts)
            require('nvim-treesitter.configs').setup(opts)


            local parser_config = require "nvim-treesitter.parsers".get_parser_configs()
            parser_config.tsx.filetype_to_parsername = { "javascript", "typescript.tsx" }
        end,
    }
}
