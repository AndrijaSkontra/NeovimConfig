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
		local neocodeium_status = require("config.helpers.neocodeium-status")
		local neocodeium = require("neocodeium")
		neocodeium.setup({ enabled = neocodeium_status.saved_enabled() })
		neocodeium_status.enable_persistence()
		vim.keymap.set("i", "<Tab>", neocodeium.accept)
	end,
}
