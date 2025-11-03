return {
	"XXiaoA/atone.nvim",
	cmd = "Atone",
	opts = {}, -- your configuration here
	keys = {
		{
			"<leader>u",
			"<cmd>Atone<cr>",
			mode = { "n", "x" },
			desc = "undo history",
		},
	},
}
