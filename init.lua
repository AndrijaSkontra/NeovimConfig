-- Just a reminder 📝:
-- This will execute/require /lua/config/options.lua file
-- Then /lua/config/autocommands.lua file and so on...
require("config.options")
require("config.autocommands")
require("config.lazy")
require("config.basic-keymaps")
require("config.lualine-config")
require("config.language-support")

-- Slumber setup, move later
local Slumber = {}
Slumber.toggle = function()
	local Terminal = require("toggleterm.terminal").Terminal
	local slumber = Terminal:new({
		cmd = "slumber",
		hidden = true,
		direction = "float",
		float_opts = {
			border = "none",
			width = 100000,
			height = 100000,
		},
		on_open = function(_)
			vim.cmd("startinsert!")
		end,
		on_close = function(_) end,
		count = 99,
	})
	slumber:toggle()
end

local wk = require("which-key")
wk.add({
	-- Map space V S to open slumber
	{ "<leader>vs", Slumber.toggle, desc = "Open in Slumber" },
})
