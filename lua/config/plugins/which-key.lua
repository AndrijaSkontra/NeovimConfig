return {
	"folke/which-key.nvim",
	event = "VeryLazy",
	opts = {
		-- your configuration comes here
		-- or leave it empty to use the default settings
		-- refer to the configuration section below
		win = {
			border = "rounded",
		},
		delay = 1000,
	},
	config = function(_, opts)
		require("which-key").setup(opts)
		-- Holding Alt-j/k repeats faster than which-key's recursion guard
		-- (50 starts in 500ms). That guard is a false positive here, and
		-- `opts.notify` does not cover this particular error.
		local notify = vim.notify
		vim.notify = function(msg, level, notify_opts)
			local text = type(msg) == "table" and table.concat(msg, "\n") or msg
			local false_recursion = type(text) == "string"
				and text:find("Recursion detected", 1, true)
				and text:find("opts.triggers", 1, true)
			if false_recursion then
				return
			end
			return notify(msg, level, notify_opts)
		end
	end,
	keys = {
		{
			"<leader>?",
			function()
				require("which-key").show({ global = false })
			end,
			desc = "Buffer Local Keymaps (which-key)",
		},
	},
}
