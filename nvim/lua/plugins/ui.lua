return {
	-- {
	-- 	"EdenEast/nightfox.nvim",
	-- 	priority = 1000,
	-- 	lazy = false,
	-- 	opts = {
	-- 		groups = {
	-- 			nordfox = {
	-- 				-- slightly brighten comments & UI
	-- 				Comment = { fg = "#7a8599" },
	-- 				LineNr = { fg = "#6b758e" },
	-- 			},
	-- 		},
	-- 	},
	-- 	config = function(_, opts)
	-- 		require("nightfox").setup(opts)
	-- 		vim.cmd("colorscheme nordfox")
	-- 	end,
	-- },
	{
		"catppuccin/nvim",
		name = "catppuccin",
		priority = 1000,
		lazy = false,
		opts = {
			flavour = "macchiato",
		},
		config = function(_, opts)
			require("catppuccin").setup(opts)
			vim.cmd("colorscheme catppuccin")
		end,
	},
	-- {
	-- 	"rebelot/kanagawa.nvim",
	-- 	priority = 1000,
	-- 	lazy = false,
	-- 	config = function(_, opts)
	-- 		require("kanagawa").setup(opts)
	-- 		vim.cmd("colorscheme kanagawa-wave")
	-- 	end,
	-- },
	-- {
	-- 	"folke/tokyonight.nvim",
	-- 	priority = 1000,
	-- 	lazy = false,
	-- 	opts = {
	-- 		style = "moon",
	-- 	},
	-- 	config = function(_, opts)
	-- 		require("tokyonight").setup(opts)
	-- 		vim.cmd("colorscheme tokyonight")
	-- 	end,
	-- },
	{
		"nvim-lualine/lualine.nvim",
		config = function()
			require("lualine").setup({
				sections = {
					lualine_a = { "filename" },
					lualine_b = {},
					lualine_c = {},
					lualine_x = {},
					lualine_y = {},
					lualine_z = {},
				},
			})
		end,
	},
	{
		"nvim-tree/nvim-web-devicons",
	},
	{
		"folke/noice.nvim",
		event = "VeryLazy",
		opts = {
			lsp = {
				override = {
					["vim.lsp.util.convert_input_to_markdown_lines"] = true,
					["vim.lsp.util.stylize_markdown"] = true,
					["cmp.entry.get_documentation"] = true, -- requires hrsh7th/nvim-cmp
				},
			},
			presets = {
				bottom_search = true, -- use a classic bottom cmdline for search
				command_palette = true, -- position the cmdline and popupmenu together
				long_message_to_split = true, -- long messages will be sent to a split
				inc_rename = true, -- enables an input dialog for inc-rename.nvim
				lsp_doc_border = false, -- add a border to hover docs and signature help
			},
		},
		dependencies = {
			"MunifTanjim/nui.nvim",
			-- "rcarriga/nvim-notify",
		},
	},
	{
		"folke/trouble.nvim",
		opts = {}, -- for default options, refer to the configuration section for custom setup.
		cmd = "Trouble",
		keys = {
			{
				"<leader>xx",
				"<cmd>Trouble diagnostics toggle<cr>",
				desc = "Diagnostics (Trouble)",
			},
			{
				"<leader>xX",
				"<cmd>Trouble diagnostics toggle filter.buf=0<cr>",
				desc = "Buffer Diagnostics (Trouble)",
			},
			{
				"<leader>cs",
				"<cmd>Trouble symbols toggle focus=false<cr>",
				desc = "Symbols (Trouble)",
			},
			{
				"<leader>cl",
				"<cmd>Trouble lsp toggle focus=false win.position=right<cr>",
				desc = "LSP Definitions / references / ... (Trouble)",
			},
			{
				"<leader>xL",
				"<cmd>Trouble loclist toggle<cr>",
				desc = "Location List (Trouble)",
			},
			{
				"<leader>xQ",
				"<cmd>Trouble qflist toggle<cr>",
				desc = "Quickfix List (Trouble)",
			},
		},
		init = function()
			vim.api.nvim_create_autocmd("BufRead", {
				callback = function(ev)
					if vim.bo[ev.buf].buftype == "quickfix" then
						vim.schedule(function()
							vim.cmd([[cclose]])
							vim.cmd([[Trouble qflist open]])
						end)
					end
				end,
			})
		end,
	},
	{
		"delphinus/md-render.nvim",
		version = "*",
		dependencies = {
			{ "nvim-tree/nvim-web-devicons", version = "*" }, -- optional: file type icons in code blocks
			{ "delphinus/budoux.lua", version = "*" }, -- optional: CJK phrase-level line breaking
		},
		cmd = "MdRender",
		keys = {
			{ "<leader>mp", "<Plug>(md-render-preview)", desc = "Markdown preview (toggle)" },
			{ "<leader>mt", "<Plug>(md-render-preview-tab)", desc = "Markdown preview in tab (toggle)" },
			{ "<leader>md", "<Plug>(md-render-demo)", desc = "Markdown render demo" },
			{
				"<leader>mk",
				function()
					-- tmux keeps the KITTY_LISTEN_ON of the kitty that started its server,
					-- which goes stale once that kitty restarts
					local socket = vim.env.KITTY_LISTEN_ON
					if not socket or vim.fn.getftype((socket:gsub("^unix:", ""))) ~= "socket" then
						local found = vim.fn.glob("/tmp/mykitty-*", false, true)[1]
						socket = found and "unix:" .. found
					end
					if not socket then
						vim.notify("No kitty remote control socket found", vim.log.levels.WARN)
						return
					end
					vim.system({
						"kitty",
						"@",
						"--to",
						socket,
						"launch",
						"--type=overlay",
						-- kitty launches children with its own GUI environment, not tmux's
						"--env",
						"PATH=" .. vim.env.PATH,
						"--cwd",
						vim.fn.getcwd(),
						vim.v.progpath,
						vim.fn.expand("%:p"),
						"-c",
						"MdRender pager",
						-- recursive so it reaches the pager's own q, which also clears images
						"-c",
						"nmap <buffer> <Esc> q",
					}, {}, function(result)
						if result.code ~= 0 then
							vim.schedule(function()
								vim.notify("kitty overlay failed: " .. result.stderr, vim.log.levels.ERROR)
							end)
						end
					end)
				end,
				desc = "Markdown preview in kitty overlay",
			},
		},
	},
	{
		"OXY2DEV/markview.nvim",
		lazy = false,
		-- Completion for `blink.cmp`
		dependencies = { "saghen/blink.cmp" },
		opts = function()
			local presets = require("markview.presets").headings

			return {
				markdown = {
					headings = presets.glow,
					list_items = {
						shift_width = function(buffer, item)
							--- Reduces the `indent` by 1 level.
							---
							---         indent                      1
							--- ------------------------- = 1 ÷ --------- = new_indent
							--- indent * (1 / new_indent)       new_indent
							---
							local parent_indnet = math.max(1, item.indent - vim.bo[buffer].shiftwidth)

							return item.indent * (1 / (parent_indnet * 2))
						end,
						marker_minus = {
							text = "•",
							add_padding = function(_, item)
								return item.indent > 1
							end,
						},
					},
				},
			}
		end,
	},
	{
		"selimacerbas/markdown-preview.nvim",
		dependencies = { "selimacerbas/live-server.nvim" },
		config = function()
			require("markdown_preview").setup({
				-- all optional; sane defaults shown
				instance_mode = "takeover", -- "takeover" (one tab) or "multi" (tab per instance)
				port = 0, -- 0 = auto (8421 for takeover, OS-assigned for multi)
				open_browser = true,
				debounce_ms = 300,
			})
		end,
	},
}
