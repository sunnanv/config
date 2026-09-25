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
		"georgeguimaraes/review.nvim",
		version = "*",
		dependencies = {
			"esmuellert/codediff.nvim",
			"MunifTanjim/nui.nvim",
		},
		event = "VeryLazy",
		keys = {
			{ "<leader>rr", "<cmd>Review<cr>", desc = "Review working tree" },
			{ "<leader>rc", "<cmd>Review commits<cr>", desc = "Review commits" },
			{ "<leader>rb", "<cmd>Review branch<cr>", desc = "Review branch" },
			{ "<leader>rn", ":Review note<cr>", mode = { "n", "v" }, desc = "Review: note here" },
			{ "<leader>re", "<cmd>Review edit<cr>", desc = "Review: edit comment" },
			{ "<leader>rd", "<cmd>Review delete<cr>", desc = "Review: delete comment" },
			{ "<leader>rx", "<cmd>Review export<cr>", desc = "Review: export" },
			{ "<leader>rh", "<cmd>ReviewHistory<cr>", desc = "Review: commit history" },
			{ "<leader>rp", "<cmd>ReviewPost<cr>", desc = "Review: post to the pull request" },
		},
		-- review.nvim hardcodes its four comment types in popup.lua's
		-- type_keys and binds them to fixed add_* keymaps, so extra entries in
		-- comment_types are unreachable. Rebrand the built-in slots instead:
		-- note -> Question, praise -> Bug. Stored comments keep the built-in
		-- type names; only the display changes.
		opts = {
			comment_types = {
				suggestion = { name = "Suggestion", icon = "🎨", hl = "ReviewSuggestion" },
				issue = { name = "Issue", icon = "❗️", hl = "ReviewIssue" },
				note = { name = "Question", icon = "❓", hl = "ReviewSuggestion", line_hl = "ReviewSuggestionLine" },
				praise = { name = "Bug", icon = "💥", hl = "ReviewIssue", line_hl = "ReviewIssueLine" },
			},
			keymaps = {
				add_note = "<localleader>cq",
				add_praise = "<localleader>cb",
			},
		},
		config = function(_, opts)
			require("review").setup(opts)

			-- codediff's history panel is the only view that lets you step
			-- between commits without reopening a picker. Going through it
			-- directly skips review.nvim's store.load(), so existing comments
			-- would not render as marks; load the store first.
			vim.api.nvim_create_user_command("ReviewHistory", function(command)
				require("review.store").load()
				vim.cmd({ cmd = "CodeDiff", args = vim.list_extend({ "history" }, command.fargs) })
			end, {
				nargs = "*",
				desc = "Review commits in codediff's history panel (optional: git range or -- <file>)",
			})

			-- review.nvim only ever exports markdown; it never talks to
			-- GitHub. scripts/review-post.py is that missing half. It runs in
			-- a terminal split so its preview and y/N confirmation stay
			-- interactive, and takes the comments through a temp file so its
			-- own stdin is free for that prompt.
			local review_events = {
				comment = "COMMENT",
				approve = "APPROVE",
				["request-changes"] = "REQUEST_CHANGES",
			}

			vim.api.nvim_create_user_command("ReviewPost", function(command)
				local choice = command.fargs[1] or "comment"
				local event = review_events[choice]
				if not event then
					vim.notify("ReviewPost: unknown event '" .. choice .. "'", vim.log.levels.ERROR)
					return
				end

				local store = require("review.store")
				store.load()
				local comments = store.get_all()
				if #comments == 0 then
					vim.notify("ReviewPost: no comments to post", vim.log.levels.WARN)
					return
				end

				local payload = vim.fn.tempname() .. ".json"
				vim.fn.writefile({ vim.json.encode(comments) }, payload)

				vim.cmd("botright 20split")
				vim.fn.jobstart({
					vim.fn.stdpath("config") .. "/scripts/review-post.py",
					"--comments",
					payload,
					"--event",
					event,
				}, {
					term = true,
					-- gh resolves the pull request from the repository it is
					-- run in, and a codediff buffer has no file to derive one
					-- from, hence the cwd fallback.
					cwd = vim.fs.root(0, ".git") or vim.fn.getcwd(),
					on_exit = function()
						vim.fn.delete(payload)
					end,
				})
				vim.cmd("startinsert")
			end, {
				nargs = "?",
				complete = function(lead)
					return vim.tbl_filter(function(name)
						return name:find(lead, 1, true) == 1
					end, vim.tbl_keys(review_events))
				end,
				desc = "Post review comments to the pull request (comment|approve|request-changes)",
			})
		end,
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
