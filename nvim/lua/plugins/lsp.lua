return {
	{
		"neovim/nvim-lspconfig",
		event = "VeryLazy",
		config = function()
			vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float)
			vim.diagnostic.config({
				virtual_text = true,
				underline = true,
				signs = true,
			})

			vim.api.nvim_create_autocmd("LspAttach", {
				desc = "LSP actions",
				callback = function()
					vim.keymap.set("n", "K", vim.lsp.buf.hover)
					vim.keymap.set("n", "gD", vim.lsp.buf.declaration)
					vim.keymap.set("n", "gs", vim.lsp.buf.signature_help)
					vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action)
				end,
			})

			local vue_language_server_path = vim.fn.expand("$MASON/packages")
				.. "/vue-language-server"
				.. "/node_modules/@vue/language-server"
			local vue_plugin = {
				name = "@vue/typescript-plugin",
				location = vue_language_server_path,
				languages = { "vue" },
				configNamespace = "typescript",
			}

			vim.lsp.config("vtsls", {
				settings = {
					typescript = {
						preferences = {
							importModuleSpecifierEnding = "js",
						},
					},
					vtsls = {
						tsserver = {
							globalPlugins = {
								vue_plugin,
							},
						},
					},
				},
				filetypes = { "typescript", "javascript", "javascriptreact", "typescriptreact", "vue" },
			})
		end,
	},
	{
		"mason-org/mason.nvim",
		cmd = "Mason",
		opts = {
			registries = {
				"github:mason-org/mason-registry",
			},
		},
	},
	{
		"mason-org/mason-lspconfig.nvim",
		event = "VeryLazy",
		dependencies = {
			"mason-org/mason.nvim",
			"neovim/nvim-lspconfig",
		},
		opts = {},
	},
	{
		"saghen/blink.cmp",
		version = "1.*",
		lazy = false,
		dependencies = {
			"moyiz/blink-emoji.nvim",
		},
		opts = {
			keymap = {
				preset = "enter",
				["<Tab>"] = { "select_next", "fallback" },
				["<leader-Tab>"] = { "show" },
				["<S-Tab>"] = { "select_prev", "fallback" },
				["<C-e>"] = { "show", "hide" },
				["<C-space>"] = {},
			},
			appearance = {
				nerd_font_variant = "mono",
			},
			completion = {
				documentation = {
					auto_show = true,
					auto_show_delay_ms = 200,
				},
			},

			sources = {
				default = { "lsp", "path", "buffer", "emoji" },
				providers = {
					emoji = {
						name = "Emoji",
						module = "blink-emoji",
					},
				},
			},
		},
		opts_extend = { "sources.default" },
	},
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
		"stevearc/conform.nvim",
		lazy = false,
		config = function()
			require("conform").setup({
				formatters_by_ft = {
					python = { "isort", "black", "autoflake" },
					javascript = { "prettierd" },
					typescript = { "prettierd" },
					javascriptreact = { "prettierd" },
					typescriptreact = { "prettierd" },
					vue = { "prettierd" },
					markdown = { "markdownlint" },
				},
				formatters = {
					autoflake = {
						append_args = { "--in-place", "--remove-all-unused-imports" },
					},
				},
			})
			vim.keymap.set({ "n", "x" }, "<leader>f", function()
				-- vim.lsp.buf.code_action({
				-- 	apply = true,
				-- 	context = { only = { "source.fixAll.eslint" } },
				-- })
				require("conform").format({ lsp_format = "fallback" })
			end, { desc = "Format buffer" })
		end,
	},
	{
		"agent-sh/agnix",
		opts = {},
	},
}
