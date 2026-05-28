return {
	"chrisgrieser/nvim-scissors",
	lazy = true,
	dependencies = {
		{ "nvim-telescope/telescope.nvim", lazy = true },
	},
	opts = {
		snippetDir = "~/.config/nvim/lua/snippets",
	},
	keys = {
		{
			"<leader>sa",
			function()
				require("scissors").addNewSnippet()
			end,
			mode = { "n", "x" },
			desc = "Snippet: Add",
		},
		{
			"<leader>se",
			function()
				require("scissors").editSnippet()
			end,
			mode = "n",
			desc = "Snippet: Edit",
		},
	},
}
