return {
	"stevearc/oil.nvim",
	---@module 'oil'
	---@type oil.SetupOpts
	opts = {},
	-- Optional dependencies
	dependencies = { { "echasnovski/mini.icons", opts = {} } },
	-- dependencies = { "nvim-tree/nvim-web-devicons" }, -- use if prefer nvim-web-devicons
	use_default_keymaps = false,
	-- keymaps = {
	-- 	["g?"] = { "actions.show_help", mode = "n" },
	-- 	["-"] = { "actions.parent", mode = "n" },
	-- 	["_"] = { "actions.open_cwd", mode = "n" },
	-- 	["`"] = { "actions.cd", mode = "n" },
	-- 	["~"] = { "actions.cd", opts = { scope = "tab" }, mode = "n" },
	-- 	["g."] = { "actions.toggle_hidden", mode = "n" },
	-- },
	-- oil
	keys = {
		{ "<leader>;", "<CMD>Oil<CR>", desc = "Open parent directory" },
	},
}
