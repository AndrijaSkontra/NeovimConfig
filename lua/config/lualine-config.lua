local lualine = require("lualine")
local neocodeium_status = require("config.helpers.neocodeium-status")

lualine.setup({
	options = { theme = "onedark" },
	sections = {
		lualine_x = {
			{
				neocodeium_status.label,
				color = neocodeium_status.color,
				on_click = neocodeium_status.toggle,
			},
			"encoding",
			"fileformat",
			"filetype",
		},
	},
})

vim.api.nvim_create_autocmd("User", {
	pattern = {
		"NeoCodeiumEnabled",
		"NeoCodeiumDisabled",
		"NeoCodeiumBufEnabled",
		"NeoCodeiumBufDisabled",
	},
	callback = neocodeium_status.refresh_lualine,
})
