-- don't pay attention to this, it just needs to exist here for lazy to work
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
	local lazyrepo = "https://github.com/folke/lazy.nvim.git"
	local out = vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"--branch=stable",
		lazyrepo,
		lazypath,
	})
	if vim.v.shell_error ~= 0 then
		vim.api.nvim_echo({
			{ "Failed to clone lazy.nvim:\n", "ErrorMsg" },
			{ out, "WarningMsg" },
			{ "\nPress any key to exit..." },
		}, true, {})
		vim.fn.getchar()
		os.exit(1)
	end
end
vim.opt.rtp:prepend(lazypath)
-- don't pay attention to this, it just needs to exist here for lazy to work

require("lazy").setup({
	spec = {
		"neovim/nvim-lspconfig",
		require("config.plugins.treesitter"),
		require("config.plugins.colorscheme"),
		"tpope/vim-sleuth", -- INFO: auto tab space
		require("config.plugins.mini"),
		require("config.plugins.todo-comments"),
		require("config.plugins.lualine"),
		require("config.plugins.autoclose-tags"),
		require("config.plugins.autoclose-brackets"),
		require("config.plugins.multicursor"),
		require("config.plugins.themery-theme-switcher"),
		require("config.plugins.git"),
		require("config.plugins.buffer-jabs"),
		require("config.plugins.snacks"),
		require("config.plugins.quick-scope"),
		require("config.plugins.snippets-creation-plugin"),
		require("config.plugins.blink"),
		require("config.plugins.autoformat"),
		require("config.plugins.sidekick"),
		require("config.plugins.little-colors-theme"),
		require("config.plugins.undotree"),
		require("config.plugins.which-key"),
		require("config.plugins.catpuccin"),
		require("config.plugins.oil"),
		require("config.plugins.99"),
		-- require("config.plugins.opencode"),
		-- require("config.plugins.copilot"),
		-- require("config.plugins.supermaven"),
	},
	checker = { enabled = true },
})
