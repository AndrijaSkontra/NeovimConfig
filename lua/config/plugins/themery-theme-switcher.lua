return {
	"zaldih/themery.nvim",
	lazy = false,
	init = function()
		require("config.helpers.omarchy-theme-sync").setup_autosync()
	end,
	opts = function()
		return {
			themes = require("config.helpers.omarchy-theme-sync").themery_entries(),
		}
	end,
	keys = {
		{ "<leader>th", "<CMD>Themery<CR>", desc = "Change theme" },
	},
}
