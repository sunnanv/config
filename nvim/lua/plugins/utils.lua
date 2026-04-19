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
				"<C-n>",
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
            { "rn", function() require('live-rename').rename() end },
        },
        opts = {
            keys = {
                submit = {
                    { "n", "<c-space>" },
                    { "v", "<c-space>" },
                    { "i", "<c-space>" },
                }
            }
        },
    },
    {
        "ranelpadon/python-copy-reference.vim"
    },
    {
        'mawkler/demicolon.nvim',
        dependencies = {
            'nvim-treesitter/nvim-treesitter',
            'nvim-treesitter/nvim-treesitter-textobjects',
        },
        opts = {}
    },
    {
        "esmuellert/codediff.nvim",
        dependencies = { "MunifTanjim/nui.nvim" },
        cmd = { "CodeDiff" },
    }
}
