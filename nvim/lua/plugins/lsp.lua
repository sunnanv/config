return {
    {
        "folke/lazydev.nvim",
        ft = "lua",
        opts = {
            library = {
                { path = "luvit-meta/library", words = { "vim%.uv" } },
            },
        },
    },
    { "Bilal2453/luvit-meta", lazy = true },
    {
        "neovim/nvim-lspconfig",
        event = "VeryLazy",
        dependencies = {
            "nvim-telescope/telescope.nvim",
        },
        config = function()
            vim.keymap.set("n", "<leader>e", "<cmd>lua vim.diagnostic.open_float()<cr>")
            vim.keymap.set("n", "[d", "<cmd>lua vim.diagnostic.goto_prev()<cr>")
            vim.keymap.set("n", "]d", "<cmd>lua vim.diagnostic.goto_next()<cr>")

            vim.api.nvim_create_autocmd("LspAttach", {
                desc = "LSP actions",
                callback = function()
                    local format = function()
                        vim.lsp.buf.format({
                            async = true,
                            filter = function(client)
                                local can_format = client.name ~= "volar" and client.name ~= "ts_ls"
                                print(client.name .. " can format: " .. tostring(can_format))
                                return can_format
                            end,
                        })
                    end

                    local telescope_functions = require("telescope.builtin")

                    vim.keymap.set("n", "gd", telescope_functions.lsp_definitions)
                    vim.keymap.set("n", "gi", telescope_functions.lsp_implementations)
                    vim.keymap.set("n", "go", telescope_functions.lsp_type_definitions)
                    vim.keymap.set("n", "gr", telescope_functions.lsp_references)
                    vim.keymap.set("n", "<leader>di", telescope_functions.diagnostics)
                    vim.keymap.set("n", "K", "<cmd>lua vim.lsp.buf.hover()<cr>")
                    vim.keymap.set("n", "gD", "<cmd>lua vim.lsp.buf.declaration()<cr>")
                    vim.keymap.set("n", "gs", "<cmd>lua vim.lsp.buf.signature_help()<cr>")
                    vim.keymap.set("n", "<leader>ca", "<cmd>lua vim.lsp.buf.code_action()<cr>")
                    vim.keymap.set({ "n", "x" }, "<leader>f", format)
                end,
            })
        end,
    },
    {
        "williamboman/mason.nvim",
        cmd = "Mason",
        opts = {
            registries = {
                "github:mason-org/mason-registry",
            },
        },
    },
    {
        "williamboman/mason-lspconfig.nvim",
        event = "VeryLazy",
        dependencies = {
            "hrsh7th/cmp-nvim-lsp",
            "neovim/nvim-lspconfig",
        },
        opts = {
            handlers = {
                function(server)
                    require("lspconfig")[server].setup({
                        capabilities = require("cmp_nvim_lsp").default_capabilities(),
                    })
                end,
                lua_ls = function()
                    require("lspconfig").lua_ls.setup({
                        capabilities = require("cmp_nvim_lsp").default_capabilities(),
                        settings = {
                            Lua = {
                                runtime = {
                                    version = "LuaJIT",
                                },
                                diagnostics = {
                                    globals = { "vim" },
                                },
                                workspace = {
                                    library = {
                                        vim.env.VIMRUNTIME,
                                    },
                                },
                            },
                        },
                    })
                end,
                ts_ls = function()
                    require("lspconfig").ts_ls.setup({
                        capabilities = require("cmp_nvim_lsp").default_capabilities(),
                        init_options = {
                            plugins = {
                                {
                                    name = "@vue/typescript-plugin",
                                    location =
                                    "/Users/johannessunnanvader/.nvm/versions/node/v20.11.0/lib/node_modules/@vue/typescript-plugin",
                                    languages = { "javascript", "typescript", "vue" },
                                },
                            },
                        },
                        filetypes = { "typescript", "javascript", "javascriptreact", "typescriptreact", "vue", "json" },
                    })
                end,
                eslint = function()
                    require("lspconfig").eslint.setup({
                        capabilities = require("cmp_nvim_lsp").default_capabilities(),
                        root_dir = require("lspconfig/util").root_pattern(
                            ".git",
                            ".eslintrc",
                            ".eslintrc.js",
                            ".eslintrc.json",
                            ".eslintrc.yaml",
                            ".eslintrc.yml"
                        ),
                    })
                end,
            },
        },
    },
    {
        "hrsh7th/nvim-cmp",
        event = "VeryLazy",
        opts = function()
            local cmp = require("cmp")

            local has_words_before = function()
                unpack = unpack or table.unpack
                local line, col = unpack(vim.api.nvim_win_get_cursor(0))
                return col ~= 0
                    and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
            end

            return {
                sources = {
                    { name = "nvim_lsp" },
                },

                mapping = cmp.mapping.preset.insert({
                    -- Enter key confirms completion item
                    ["<CR>"] = cmp.mapping.confirm({ select = false }),
                    ["<Tab>"] = cmp.mapping(function(fallback)
                        if cmp.visible() then
                            cmp.select_next_item({ behavior = cmp.SelectBehavior.Select })
                        elseif has_words_before() then
                            cmp.complete()
                        else
                            fallback()
                        end
                    end, { "i", "s" }),
                    ["<S-Tab>"] = cmp.mapping(function(fallback)
                        if cmp.visible() then
                            cmp.select_prev_item({ behavior = cmp.SelectBehavior.Select })
                        else
                            fallback()
                        end
                    end, { "i", "s" }),
                }),
            }
        end,
    },
    {
        "L3MON4D3/LuaSnip",
        version = "v2.*", -- Replace <CurrentMajor> by the latest released major (first number of latest release)
        -- install jsregexp (optional!).
        build = "make install_jsregexp",
        lazy = true,
        dependencies = {
            {
                "hrsh7th/nvim-cmp",
                opts = {
                    snippet = {
                        expand = function(args)
                            require("luasnip").lsp_expand(args.body)
                        end,
                    },
                },
            },
        },
    },
    {
        "nvimtools/none-ls.nvim",
        event = "VeryLazy",
        dependencies = {
            {
                "jay-babu/mason-null-ls.nvim",
                event = "VeryLazy",
            },
            "nvimtools/none-ls-extras.nvim",
            "williamboman/mason.nvim",
        },
        config = function()
            require("mason-null-ls").setup({
                ensure_installed = {
                    -- Opt to list sources here, when available in mason.
                },
                automatic_installation = false,
                handlers = {},
            })
            require("null-ls").setup({
                sources = {},
            })
        end,
    },
}
