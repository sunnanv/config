return {
	{
		"zbirenbaum/copilot.lua",
        enabled = false,
		requires = {
			"copilotlsp-nvim/copilot-lsp", -- (optional) for NES functionality
		},
		opts = {
			suggestion = {
				enabled = true,
				auto_trigger = true,
				keymap = {
					accept = "<C-space>",
				},
			},
		},
	},
}
