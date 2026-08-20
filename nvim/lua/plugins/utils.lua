return {
	{
		"tpope/vim-abolish",
		cmd = {
			"Abolish",
			"Subvert",
			"S",
		},
	},
	{
		"numtostr/BufOnly.nvim",
		keys = {
			{ "<leader>bb", "<cmd>BufOnly<CR>" },
		},
	},
	{
		"okuuva/auto-save.nvim",
		version = "^1.0.0",
		cmd = "ASToggle",
		event = { "InsertLeave", "TextChanged" },
		opts = {},
	},
	{
		"folke/which-key.nvim",
		event = "VeryLazy",
		opts = {},
	},
	{
		"tpope/vim-repeat",
		event = "VeryLazy",
	},
	{
		"gbprod/yanky.nvim",
		event = "VeryLazy",
		opts = {
			system_clipboard = {
				sync_with_ring = false,
			},
		},
		keys = {
			{
				"p",
				mode = { "n", "x" },
				"<Plug>(YankyPutAfter)",
			},
			{
				"P",
				mode = { "n", "x" },
				"<Plug>(YankyPutBefore)",
			},
			{
				"<C-p>",
				"<Plug>(YankyPreviousEntry)",
			},
			{
				"<C-P>",
				"<Plug>(YankyNextEntry)",
			},
		},
	},
	{
		"jiaoshijie/undotree",
		opts = {},
		keys = {
			{ "<leader>uu", "<cmd>lua require('undotree').toggle()<cr>" },
		},
	},
	{
		"saecki/live-rename.nvim",
		keys = {
			{
				"rn",
				function()
					require("live-rename").rename()
				end,
			},
		},
		opts = {
			keys = {
				submit = {
					{ "n", "<c-space>" },
					{ "v", "<c-space>" },
					{ "i", "<c-space>" },
				},
			},
		},
	},
	{
		"ranelpadon/python-copy-reference.vim",
	},
	{
		"mawkler/demicolon.nvim",
		dependencies = {
			"nvim-treesitter/nvim-treesitter",
			"nvim-treesitter/nvim-treesitter-textobjects",
		},
		opts = {},
	},
	{
		"esmuellert/codediff.nvim",
		dependencies = { "MunifTanjim/nui.nvim" },
		cmd = { "CodeDiff" },
	},
	{
		"jake-stewart/multicursor.nvim",
		branch = "1.0",
		config = function()
			local mc = require("multicursor-nvim")
			mc.setup()

			local set = vim.keymap.set

			-- Add or skip cursor above/below the main cursor.
			set({ "n", "x" }, "<C-up>", function()
				mc.lineAddCursor(-1)
			end)
			set({ "n", "x" }, "<C-down>", function()
				mc.lineAddCursor(1)
			end)
			set({ "n", "x" }, "<leader><C-up>", function()
				mc.lineSkipCursor(-1)
			end)
			set({ "n", "x" }, "<leader><C-down>", function()
				mc.lineSkipCursor(1)
			end)

			-- Add or skip adding a new cursor by matching word/selection
			set({ "n", "x" }, "<M-j>", function()
				mc.matchAddCursor(1)
			end)
			set({ "n", "x" }, "<leader><M-j>", function()
				mc.matchSkipCursor(1)
			end)
			set({ "n", "x" }, "<M-k>", function()
				mc.matchAddCursor(-1)
			end)
			set({ "n", "x" }, "<leader><M-K>", function()
				mc.matchSkipCursor(-1)
			end)

			-- Disable and enable cursors.
			set({ "n", "x" }, "<c-q>", mc.toggleCursor)

			-- Mappings defined in a keymap layer only apply when there are
			-- multiple cursors. This lets you have overlapping mappings.
			mc.addKeymapLayer(function(layerSet)
				-- Select a different cursor as the main one.
				layerSet({ "n", "x" }, "<left>", mc.prevCursor)
				layerSet({ "n", "x" }, "<right>", mc.nextCursor)

				-- Delete the main cursor.
				layerSet({ "n", "x" }, "<leader>x", mc.deleteCursor)

				-- Enable and clear cursors using escape.
				layerSet("n", "<esc>", function()
					if not mc.cursorsEnabled() then
						mc.enableCursors()
					else
						mc.clearCursors()
					end
				end)
			end)
		end,
	},

}
