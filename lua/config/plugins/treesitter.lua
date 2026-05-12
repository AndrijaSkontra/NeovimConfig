return {
	"nvim-treesitter/nvim-treesitter",
	build = ":TSUpdate",
	config = function()
		require("nvim-treesitter.configs").setup({
			ensure_installed = {
				"bash",
				"glimmer_javascript",
				"json",
				"css",
				"c",
				"diff",
				"html",
				"luadoc",
				"typescript",
				"toml",
				"elixir",
				"eex",
				"vim",
				"vimdoc",
				"regex",
				"markdown",
				"markdown_inline",
			},
			highlight = { enable = true },
		})
		vim.treesitter.language.register("markdown", "markdown")
	end,
}
