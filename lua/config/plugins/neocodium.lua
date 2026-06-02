return {
	"monkoose/neocodeium",
	event = "VeryLazy",
	keys = {
		{
			"<leader>ai",
			function()
				require("config.helpers.neocodeium-status").toggle()
			end,
			desc = "Toggle AI assist",
		},
	},
	config = function()
		local neocodeium = require("neocodeium")
		neocodeium.setup()
		vim.keymap.set("i", "<Tab>", neocodeium.accept)
	end,
}
