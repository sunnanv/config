return {
    {
        "nvim-treesitter/nvim-treesitter",
        branch = "main",
        lazy = false,
        build = ":TSUpdate",
        init = function()
            local ts_parsers = {
                "bash",
                "dockerfile",
                "git_config",
                "git_rebase",
                "gitattributes",
                "gitcommit",
                "gitignore",
                "json",
                "toml",
                "yaml",
                "lua",
                "make",
                "markdown",
                "python",
                "vim",
                "vimdoc",
                "html",
                "javascript",
                "typescript",
                "vue",
                "tsx",
                "sql",
            }

            local treesitter = require("nvim-treesitter")
            treesitter.install(ts_parsers)

            vim.api.nvim_create_autocmd("FileType", {
                callback = function(args)
                    local filetype = args.match
                    local lang = vim.treesitter.language.get_lang(filetype)
                    if vim.treesitter.language.add(lang) then
                        vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
                        vim.treesitter.start()
                    end
                end,
            })
        end,
    },
    {
        "nvim-treesitter/nvim-treesitter-context",
        dependencies = {
            "nvim-treesitter/nvim-treesitter",
        },
    },
    {
        "windwp/nvim-ts-autotag",
        dependencies = {
            "nvim-treesitter/nvim-treesitter",
        },
        event = "InsertEnter",
        opts = {},
    },
}
