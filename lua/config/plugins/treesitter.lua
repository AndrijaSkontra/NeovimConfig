return {
	"nvim-treesitter/nvim-treesitter",
	lazy = false,
	build = ":TSUpdate",
	config = function()
		local languages = {
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
		}

		require("nvim-treesitter").setup({})
		require("nvim-treesitter").install(languages)

		vim.api.nvim_create_autocmd("FileType", {
			group = vim.api.nvim_create_augroup("treesitter-start", { clear = true }),
			callback = function(args)
				pcall(vim.treesitter.start, args.buf)
			end,
		})
	end,
}
