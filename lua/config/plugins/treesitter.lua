return {
	"nvim-treesitter/nvim-treesitter",
	branch = "main",
	build = ":TSUpdate",
	config = function()
		require("nvim-treesitter").install({
			ensure_installed = {
				"bash",
				"glimmer_javascript",
				"json",
				"css",
				"c",
				"diff",
				"html",
				"lua",
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
		})
		vim.treesitter.language.register("markdown", "markdown")
	end,
}